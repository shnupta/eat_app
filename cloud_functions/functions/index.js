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

var square_oauth2 = squareClient.authentications['oauth2'];
square_oauth2.accessToken = functions.config().square.access_token;

var TransactionsAPI = new squareConnect.TransactionsApi();
var squareLocationID = functions.config().square.location_id;

exports.addAllRestaurantsToAlgolia = functions.https.onRequest((req, res) => {
    var items = [];

    admin.firestore().collection('restaurants').get().then((docs) => {
        docs.forEach((doc) => {
            var restaurant = doc.data();
            restaurant.objectID = doc.id;

            items.push(restaurant);
        });

        const index = client.initIndex(ALGOLIA_INDEX_NAME);

        index.saveObjects(items, function (err, content) {
            res.status(200).send(content);
        });
    }).catch((err) => {
        console.log('Error = ' + err);
    });
});

exports.onRestaurantCreated = functions.firestore.document('restaurants/{restaurant_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();

    document.objectID = context.params.restaurant_id;

    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(document);
});

exports.onRestaurantUpdated = functions.firestore.document('restaurants/{restaurant_id}').onUpdate((snapshot, context) => {
    const document = snapshot.after.data();

    document.objectID = context.params.restaurant_id;

    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(document);
});

exports.onVoucherCreated = functions.firestore.document('vouchers/{voucher_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();
    const batch = db.batch();

    var restaurantRef = db.collection(`restaurants/${document.restaurantId}/vouchers`).doc(context.params.voucher_id);
    var userRef = db.collection(`users/${document.userId}/vouchers`).doc(context.params.voucher_id);
    var voucherRef = snapshot.ref;

    var chargeBody = new squareConnect.ChargeRequest();

    var money = new squareConnect.Money();
    money.amount = document.numberOfPeople * 100;
    money.currency = "GBP";

    chargeBody.card_nonce = document.cardNonce;
    chargeBody.idempotency_key = context.params.voucher_id;
    chargeBody.amount_money = money;

    return TransactionsAPI.charge(squareLocationID, chargeBody).then((value) => {
        var newVoucher = snapshot.data();
        newVoucher['transactionId'] = value.transaction.id;
        newVoucher.status = 'transaction_complete';

        batch.set(voucherRef, newVoucher, { merge: true });
        batch.set(userRef, newVoucher);
        batch.set(restaurantRef, newVoucher);

        batch.commit();

    }, (error) => {
        snapshot.ref.set({
            status: 'transaction_failed',
            error: JSON.parse(error.response.error.text).errors[0].detail,
        }, { merge: true });
    });
});

exports.onRestaurantBookingReceived = functions.firestore.document('restaurants/{restaurant_id}/vouchers/{voucher_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();

    // use document data to change availability field of document.bookingDay...
    var restaurantRef = db.doc(`restaurants/${context.params.restaurant_id}`);
    return restaurantRef.get().then((value) => {
        var doc = value.data();
        var availability = doc.availability;
        var availabilityOfDay = doc.availability[document.bookingDay];
        for(var interval in availabilityOfDay) {
            var bt = document.bookingTime.toDate();

            var startTime = new Date(bt.getFullYear(), bt.getMonth(), bt.getDate(), parseInt(interval.split('-')[0]));
            var endTime = new Date(bt.getFullYear(), bt.getMonth(), bt.getDate(), parseInt(interval.split('-')[1]));

            if(startTime.getTime() <= bt.getTime() && bt.getTime() <= endTime.getTime()) {
                availabilityOfDay[interval]['booked'] = availabilityOfDay[interval]['booked'] + 1;
                // TODO: fix this
                if(availabilityOfDay[interval].vouchers == null) {
                    availabilityOfDay[interval].vouchers = {};
                }
                availabilityOfDay[interval].vouchers[context.params.voucher_id] = document;
                break;
            }
        }

        availability[document.bookingDay] = availabilityOfDay;

        restaurantRef.update({
            availability: availability,
        });
    });
});