import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:eat_app/algolia/algolia_response.dart';

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
	Future<AlgoliaResponse> search(String query) async {
		Map<String, String> body = {
			'params': 'query=$query'
		};
		final response = await http.post(url, headers: headers, body: json.encode(body));
		return Future.value(AlgoliaResponse.fromResponse(response));
	}
}
