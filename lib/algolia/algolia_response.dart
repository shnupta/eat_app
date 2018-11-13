import 'package:flutter/material.dart';

import 'dart:convert';


class AlgoliaResponse {
	final Map<String, dynamic> body;
	final String error;
	final bool hasError;

	AlgoliaResponse({this.body = const {}, this.hasError = false, this.error = ''});

	factory AlgoliaResponse.fromResponse(response) {
			if(response.statusCode == 200) {
				//print(response.body);
				return AlgoliaResponse(body: json.decode(response.body));
			}
			else {
				return AlgoliaResponse(hasError: true, body: json.decode(response.body), error: response.message);
			}

		return AlgoliaResponse(body: {});
	}
}
