import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class NetworkRequest {
  Future<Response> get(
    String url, {
    Map<String, String>? bodyFields,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });
  Future<Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Map<String, dynamic>? queryParams,
  });

  Future<Response> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  });

  Future<Response> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  });

  Future<Response> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  });
}

/// This class adds the token header to all requests.
/// If you need to log token, this is where you'll do it.
class TokenInterceptor extends BaseClient {
  final Client _client;
  final String? token;

  TokenInterceptor(
    this._client,
    this.token,
  );

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    String? token = this.token;
    if (kDebugMode) {
      log(token ?? 'No Token');
      log(request.toString());
    }

    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return _client.send(request);
  }
}

class NetworkRequestImpl implements NetworkRequest {
  factory NetworkRequestImpl({
    required String baseUrl,
    required String scheme,
    String? token,
  }) =>
      _instance(
        baseUrl: baseUrl,
        scheme: scheme,
        token: token,
      );
  static NetworkRequestImpl _instance({
    required String baseUrl,
    required String scheme,
    String? token,
  }) =>
      NetworkRequestImpl._(
        baseUrl: baseUrl,
        scheme: scheme,
        token: token,
      );

  NetworkRequestImpl._({
    required this.baseUrl,
    required this.scheme,
    this.token,
  }) : client = TokenInterceptor(Client(), token);
  final String baseUrl;
  final String scheme;
  final String? token;
  final BaseClient client;

  @override
  Future<Response> get(
    String url, {
    Map<String, String>? bodyFields,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    if (bodyFields == null) {
      return client
          .get(
              Uri(
                scheme: scheme,
                host: baseUrl,
                path: url,
                queryParameters: queryParams,
              ),
              headers: headers)
          .timeout(const Duration(seconds: 17), onTimeout: () {
        throw TimeoutException('Time Out Error');
      });
    } else {
      final Request request = Request(
        'GET',
        Uri(
          scheme: scheme,
          host: baseUrl,
          path: url,
          queryParameters: queryParams,
        ),
      );

      request.bodyFields = bodyFields;

      log(token ?? 'no token');

      if (token != null) {
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      final streamedResponse = await request.send().asStream().first;

      return Response.fromStream(streamedResponse);
    }
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  }) {
    return client.post(
      Uri(
        scheme: scheme,
        host: baseUrl,
        path: url,
        queryParameters: queryParams,
      ),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  }) {
    return client.patch(
      Uri(
        scheme: scheme,
        host: baseUrl,
        path: url,
        queryParameters: queryParams,
      ),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Map<String, dynamic>? queryParams,
  }) {
    return client.put(
      Uri(
        scheme: scheme,
        host: baseUrl,
        path: url,
        queryParameters: queryParams,
      ),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<Response> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  }) {
    return client.delete(
      Uri(
        scheme: scheme,
        host: baseUrl,
        path: url,
        queryParameters: queryParams,
      ),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }
}
