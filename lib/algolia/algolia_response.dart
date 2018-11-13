import 'package:flutter/material.dart';

import 'dart:convert';


class AlgoliaResponse {
	final Map<String, dynamic> body;
	List<dynamic> hits;
	final String error;
	final bool hasError;

	AlgoliaResponse({this.body = const {}, this.hits = const [], this.hasError = false, this.error = ''});

	factory AlgoliaResponse.fromResponse(response) {
			if(response.statusCode == 200) {
				Map<String, dynamic> _body = json.decode(response.body);
				List<dynamic> _hits = _body['hits'];
				
				// So the first item in a 'hit' is the actual map of data in Firebase

				return AlgoliaResponse(body: _body, hits: _hits);
			}
			else {
				return AlgoliaResponse(hasError: true, body: json.decode(response.body), error: response.message);
			}

		return AlgoliaResponse(body: {});
	}
}
