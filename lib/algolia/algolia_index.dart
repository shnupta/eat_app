import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:snacc/algolia/algolia_response.dart';

/// An index is the place where the data used by a search engine is stored. 
/// It is the equivalent for search of what a “table” is for a database.
/// Each index has a name and a related appID, the search API key is also needed to connect
class AlgoliaIndex {
	final String indexName;
	final String appID;
	final String searchKey;
	final String url;
	final Map<String, String> headers;

	AlgoliaIndex({@required indexName, @required appID, @required searchKey}) :
		appID = appID,
		searchKey = searchKey,
		indexName = indexName,
		url = 'https://$appID-dsn.algolia.net/1/indexes/$indexName/query',
		headers = {
			'X-Algolia-API-Key': searchKey,
			'X-Algolia-Application-Id': appID
		};


	// So all the requests are going to be made to the Algolia REST API
	// These will return a JSON object if the HTTP response is 200 OK
	Future<AlgoliaResponse> search(String query, [Map<String, List<String>> facetFilters]) async {
		Map<String, dynamic> body = {
			'params': 'query=$query'
		};

    // If the search has filters attached, put these into the body
    // of the request
    if(facetFilters != null) {
      List<List<String>> finalFacets = List();
      for (var key in facetFilters.keys) {
        List<String> keyList = List();
        for(var item in facetFilters[key]) {
          keyList.add('$key:$item');
        }
        finalFacets.add(keyList);
      }
      body['facets'] = ['*'];
      body['facetFilters'] = finalFacets;
    }

    // Make a http request to the url related to the index and wait for the response
		final response = await http.post(url, headers: headers, body: json.encode(body));
		return Future.value(AlgoliaResponse.fromResponse(response));
	}
}
