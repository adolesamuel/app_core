import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

///This is just a don't repeat yourself function
///to process network responses

Future<T> processResponse<T>({
  ///this is the response object
  required Response response,

  ///this is the function used to do the serialization.
  required T Function(dynamic) serializer,

  ///This is the code to check for in the response.
  int successCode = 200,

  //The map is the error serialized.
  Exception Function(dynamic)? serializeError,
}) async {
  //Deserialize.
  final data = await json.decode(response.body);
  log(data.toString());

  if (response.statusCode < (successCode + 90)) {
    try {
      return serializer(data);
    } on Exception catch (_) {
      rethrow;
    }
  } else {
    if (serializeError != null) {
      throw serializeError(data);
    } else {
      debugPrint(response.statusCode.toString());
      final Map errors = data;
      debugPrint(errors.toString());
      dynamic message = '';
      try {
        if (errors['message'] != null) {
          message = errors['message'];
        } else if (errors['error'].isNotEmpty) {
          message = errors['error'][0];
        } else if (errors['errors'].keys.contains('otp_code')) {
          //this regex removes errors,{},:,[] from any string.
          message = errors['errors']
              .toString()
              .replaceAll(RegExp(r'(?:errors)|[{}\[\]\:]'), '');
        } else if (errors['errors'].keys.contains('code')) {
          message = errors['errors']['code'];
        } else if (errors['errors'].keys.contains('detail')) {
          message = errors['errors']['detail'];
        } else {
          message = errors['errors']['message'];
        }
        //handle password error message appearing in list
        //issue
        //remove if resolved from the backend.
        throw Exception(message
            .toString()
            .replaceAll(RegExp(r'(?:errors)|[{}\[\]\:]'), ''));
      } on Exception catch (_) {
        rethrow;
      }
    }
  }
}
