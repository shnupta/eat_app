const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');

const ALGOLIA_ID = functions.config().algolia.app_id;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key;
const ALGOLIA_SEARCH_KEY = functions.config().algolia.search_key;

const ALGOLIA_INDEX_NAME = 'restaurant_search';
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

function onRestaurantCreated() {
    functions.firestore.document('restaurants/{restaurant_id}').onCreate((snapshot, context) => {
        const document = snapshot.data();

        document.objectID = context.params.restaurant_id;

        const index = client.initIndex(ALGOLIA_INDEX_NAME);
        return index.saveObject(document);
    });
}