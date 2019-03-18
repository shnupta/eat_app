// The constants and vars below are just there to initialise different services that
// I will need to use in the functions later.

const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const admin = require('firebase-admin');
const squareConnect = require('square-connect');

const squareClient = squareConnect.ApiClient.instance;

const ALGOLIA_ID = functions.config().algolia.app_id;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key;

const ALGOLIA_INDEX_NAME = 'restaurants_search';
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp(functions.config().firestore);
const db = admin.firestore();
const settings = { timestampsInSnapshots: true };
db.settings(settings);

var square_oauth2 = squareClient.authentications['oauth2'];
square_oauth2.accessToken = functions.config().square.access_token;

var TransactionsAPI = new squareConnect.TransactionsApi();
var squareLocationID = functions.config().square.location_id;

const SENDGRID_API_KEY = functions.config().sendgrid.key;

const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(SENDGRID_API_KEY);

// On a HTTP request to the URL created by firebase, iterate through all of the restaurants
// in the database and add them to my Algolia search index using the Algolia API
exports.addAllRestaurantsToAlgolia = functions.https.onRequest((req, res) => {
    var items = [];

    // Get the restaurants colletion
    admin.firestore().collection('restaurants').get().then((docs) => {
        // Iterate through each restaurant
        docs.forEach((doc) => {
            var restaurant = doc.data();
            // Algolia requires every item in an index to have a unique objectID,
            // I'm using the id of the object from Firebase
            restaurant.objectID = doc.id;

            items.push(restaurant);
        });

        const index = client.initIndex(ALGOLIA_INDEX_NAME);

        // Save the restaurants to Algolia
        index.saveObjects(items, function (err, content) {
            res.status(200).send(content);
        });
    }).catch((err) => {
        console.log('Error = ' + err);
    });
});

// This function is triggered when a new restaurant object is created in the database
// It receives the restaurant id and the snapshot (which contains the data)
exports.onRestaurantCreated = functions.firestore.document('restaurants/{restaurant_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();

    document.objectID = context.params.restaurant_id;

    // When a new restaurant is created we want to automatically add it to Algolia
    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(document);
});

// This function is triggered whenever a restaurant in the database has any of its data changed
// We want to add it to Algolia to make sure the search information is up to date
exports.onRestaurantUpdated = functions.firestore.document('restaurants/{restaurant_id}').onUpdate((snapshot, context) => {
    const document = snapshot.after.data();

    document.objectID = context.params.restaurant_id;

    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(document);
});


// If a restaurant is deleted, remove it from algolia so it doesn't appear in any search results
exports.onRestaurantDeleted = functions.firestore.document('restaurants/{restaurant_id}').onDelete((snapshot, context) => {
    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.deleteObject(context.params.restaurant_id);
})

// This is triggered whenever a voucher is created in the database. This only ever occurs in the vouchers
// collection when someone has confirmed they wish to buy a voucher and so this indicate we should 
// attempt to charge their card and book their place
exports.onVoucherCreated = functions.firestore.document('vouchers/{voucher_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();
    const batch = db.batch();

    // These are references to other locations in Firebase, namely the restaurant and user
    // that the voucher is for
    var restaurantRef = db.collection(`restaurants/${document.restaurantId}/vouchers`).doc(context.params.voucher_id);
    var userRef = db.collection(`users/${document.userId}/vouchers`).doc(context.params.voucher_id);
    var voucherRef = snapshot.ref;

    var restaurantObj = db.doc(`restaurants/${document.restaurantId}`);

    const createdAt = snapshot.get('createdAt');
    if (((createdAt - Date.now()) / 1000) > 60) {
        return snapshot.ref.set({
            status: 'transaction_failed',
            error: 'Timed out',
        }, { merge: true });
    }

    // To make a Transaction with the Square API it requires a charge body.
    var chargeBody = new squareConnect.ChargeRequest();

    var money = new squareConnect.Money();
    money.amount = document.numberOfPeople * 100; // amount is in pence
    money.currency = "GBP";

    chargeBody.card_nonce = document.cardNonce; // The card nonce generated by the Square SDK card input
    chargeBody.idempotency_key = context.params.voucher_id;
    chargeBody.amount_money = money;

    // Attempt to charge the card
    return TransactionsAPI.charge(squareLocationID, chargeBody).then((value) => {
        var newVoucher = snapshot.data();
        newVoucher['transactionId'] = value.transaction.id;
        newVoucher.status = 'transaction_complete';

        restaurantObj.get().then(function (doc) {
            console.log(newVoucher['numberOfPeople']);
            const restMsg = {
                to: doc.get('email'),
                from: 'williamshoops96@gmail.com',
                templateId: 'd-f35834c6e087410b824f02a8e4d7e1e0',
                dynamic_template_data: {
                    numberOfPeople: newVoucher['numberOfPeople'],
                    time: `${newVoucher['bookingTime'].getHours()}:${newVoucher['bookingTime'].getMinutes()}`,
                    date: newVoucher['bookingTime'].toLocaleDateString(),
                    discount: `${newVoucher['discount']}%`,
                    voucherId: context.params.voucher_id
                }
            }
            sgMail.send(restMsg).then().catch(err => console.log(err));

            // Add the updated vouchers to the batch ready to be saved to their own locations in the database
            batch.set(voucherRef, newVoucher, { merge: true });
            batch.set(userRef, newVoucher);
            batch.set(restaurantRef, newVoucher);

            batch.commit(); // save them to the database
        });


    }, (error) => {
        snapshot.ref.set({
            status: 'transaction_failed',
            error: JSON.parse(error.response.error.text).errors[0].detail,
        }, { merge: true });
    });
});

// This occurs when a voucher has been successfully purchased and booked by a user
exports.onRestaurantBookingReceived = functions.firestore.document('restaurants/{restaurant_id}/vouchers/{voucher_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();

    var restaurantRef = db.doc(`restaurants/${context.params.restaurant_id}`);
    return restaurantRef.get().then((value) => {
        // use document data to change availability field of document.bookingDay...
        var doc = value.data();
        var availability = doc.availability;
        var availabilityOfDay = doc.availability[document.bookingDay]; // Get the availability for the day of booking

        // Iterate through all of the time intervals for the day
        for (var interval in availabilityOfDay) {
            var bt = document.bookingTime; // Booking time of the voucher

            // Interval start and end times
            var startTime = new Date(bt.getFullYear(), bt.getMonth(), bt.getDate(), parseInt(interval.split('-')[0]));
            var endTime = new Date(bt.getFullYear(), bt.getMonth(), bt.getDate(), parseInt(interval.split('-')[1]));

            // Find the correct interval that the voucher booking time is inside
            if (startTime.getTime() <= bt.getTime() && bt.getTime() <= endTime.getTime()) {
                // update the number of booked spaces
                availabilityOfDay[interval]['booked'] = availabilityOfDay[interval]['booked'] + 1;

                if (availabilityOfDay[interval].vouchers == null) {
                    availabilityOfDay[interval].vouchers = {};
                }
                availabilityOfDay[interval].vouchers[context.params.voucher_id] = document;
                break;
            }
        }

        availability[document.bookingDay] = availabilityOfDay;

        // Save the newly updated availability info
        restaurantRef.update({
            availability: availability,
        });
    });
});

// This function is triggered when a message is received by pubsub on the topic of 'daily-tick'
exports.daily_job = functions.pubsub
    .topic('daily-tick')
    .onPublish((message) => {

        // has to be in this order as Sunday is 0 when calling javascript .getDay()q
        var daysArr = [
            'sunday',
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday',
        ];

        // Update all restaurant's availabilty
        // First save the current booking data into {restaurant_id}/past_bookings
        // Then reset each restaurant's availability back to default

        var restaurantsRef = db.collection('restaurants');
        restaurantsRef.get().then(snapshot => {
            var batch = db.batch();
            // Iterate through every restaurant in the database
            snapshot.forEach((child) => {
                var restRef = child.ref;

                var doc = child.data();

                if (doc.availability == null) return;

                var docAvailability = doc.availability;
                var today = new Date();
                today.setDate(today.getDate() - 1);
                var day = daysArr[today.getDay()];
                if (docAvailability[day] == null) return;
                else {
                    // copy all of this data to pastBookings collection of this restaurant
                    var pastBookingDay = `${today.getFullYear()}_${today.getMonth() + 1}_${today.getDate()}`
                    restRef.collection('pastBookings').doc(pastBookingDay).create(docAvailability[day]);
                }

                // Reset every interval back to 0 bookings and wipe the vouchers
                for (interval in docAvailability[day]) {
                    if (interval == 'closed') continue;
                    else {
                        if (docAvailability[day][interval]['vouchers'] != null) delete docAvailability[day][interval]['vouchers'];
                        docAvailability[day][interval]['booked'] = 0;
                    }
                }

                doc.availability = docAvailability;

                batch.set(restRef, doc);

            });
            batch.commit();
        });

        return true;
    });