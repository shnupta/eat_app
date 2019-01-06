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

var square_oauth2 = squareClient.authentications['oauth2'];
square_oauth2.accessToken = "sq0atp-v-CQmt2pfhzcGP8mzxhPrQ";

var TransactionsAPI = new squareConnect.TransactionsApi();
var squareLocationID = "TPN0CDMFTK4FY";

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

    try {
        var chargeBody = new squareConnect.ChargeRequest();

        var money = new squareConnect.Money();
        money.amount = document.numberOfPeople * 100;
        money.currency = "GBP";

        chargeBody.card_nonce = document.cardNonce;
        chargeBody.idempotency_key = context.params.voucher_id;
        chargeBody.amount_money = money;

        return TransactionsAPI.charge(squareLocationID, chargeBody).then((data) => {
            snapshot.ref.set({
                transactionId: data.transaction.id,
                status: 'transaction_complete'
            }, { merge: true });

            // Now write to the user's area and the restaurant's area
        }, function (error) {
            throw error;
        });
    } catch (ex) {
        snapshot.ref.set({
            status: 'transaction_failed',
            error: ex.message
        }, { merge: true });
    }
});