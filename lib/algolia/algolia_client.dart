import 'package:flutter/material.dart';

import 'package:snacc/algolia/algolia_index.dart';

/// Acts as the base for the communication with your Algolia application and your app.
/// Requires IDs and keys to connect with the Algolia REST API
class AlgoliaClient {
	String appID;
	String searchKey;
	
	/// [appID] is the application Id of the Aloglia App you want to connect to
	/// [searchKey] is the search key of that application
	AlgoliaClient({@required this.appID, @required this.searchKey}); 


	AlgoliaIndex initIndex(String indexName) {
		return AlgoliaIndex(indexName: indexName, appID: this.appID, searchKey: this.searchKey);
	}

}
