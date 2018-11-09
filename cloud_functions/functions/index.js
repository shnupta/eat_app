const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const admin = require('firebase-admin');

const ALGOLIA_ID = functions.config().algolia.app_id;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key;
const ALGOLIA_SEARCH_KEY = functions.config().algolia.search_key;

const ALGOLIA_INDEX_NAME = 'restaurants_search';
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp(functions.config().firestore);

exports.addAllRestaurantsToAlgolia = functions.https.onRequest((req, res) => {
    var items = [];

    admin.firestore().collection('restaurants').get().then((docs) => {
        docs.forEach((doc) => {
            var restaurant = doc.data;
            restaurant.objectID = doc.id;

            items.push(restaurant);
        });

        const index = client.initIndex(ALGOLIA_INDEX_NAME);

        index.saveObjects(items, function(err, content) {
            res.status(200).send(content);
        });
    });
});

exports.onRestaurantCreated = functions.firestore.document('restaurants/{restaurant_id}').onCreate((snapshot, context) => {
    const document = snapshot.data();

    document.objectID = context.params.restaurant_id;

    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(document);
});
