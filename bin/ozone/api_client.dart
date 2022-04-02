import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_request.dart';

class OApiClient {
  final String realMethodHeaderName;
  final bool useRealMethodHeader;
  final OApiRequestEnventHandler handler;

  OApiClient(
      {this.realMethodHeaderName,
      this.useRealMethodHeader = false,
      this.handler});

  Future<http.Response> _request(OApiRequest req) async {
    http.Response response;

    try {
      response = await _requestReal(req);
    } on OApiRequestError catch (_) {
      if (handler != null) {
        handler.onError(_);
      }
    }

    return response;
  }

  Future<http.Response> _requestReal(OApiRequest req) async {
    if (handler != null) {
      handler.onRequest(req);
    }

    http.Response response;

    var method = req.method,
        url = req.url,
        headers = req.headers,
        body = req.body;

    try {
      switch (method) {
        case OApiRequestMethod.GET:
          response = await http.get(url, headers: headers);
          break;
        case OApiRequestMethod.POST:
          response = await http.post(url, body: body, headers: headers);
          break;
        case OApiRequestMethod.DELETE:
          if (useRealMethodHeader) {
            headers[realMethodHeaderName] = 'delete';
            response = await http.post(url, headers: headers);
          } else {
            response = await http.delete(url, headers: headers);
          }
          break;
        case OApiRequestMethod.PUT:
          if (useRealMethodHeader) {
            headers[realMethodHeaderName] = 'put';
            response = await http.post(url, body: body, headers: headers);
          } else {
            response = await http.put(url, body: body, headers: headers);
          }
          break;
        case OApiRequestMethod.PATCH:
          if (useRealMethodHeader) {
            headers[realMethodHeaderName] = 'patch';
            response = await http.post(url, body: body, headers: headers);
          } else {
            response = await http.patch(url, body: body, headers: headers);
          }
          break;
      }
    } on SocketException {
      throw OApiRequestError(type: 'network', message: 'OZ_ERROR_NETWORK');
    } on HttpException catch (_) {
      throw OApiRequestError(type: 'http', message: _.message);
    }

    if (handler != null) {
      handler.onResponse(response);
    }

    return response;
  }

  Future<http.Response> get(url, {Map<String, String> headers = const {}}) {
    return _request(
        OApiRequest(url, method: OApiRequestMethod.GET, headers: headers));
  }

  Future<http.Response> post(url,
      {dynamic body, Map<String, String> headers = const {}}) {
    return _request(OApiRequest(url,
        method: OApiRequestMethod.POST, body: body, headers: headers));
  }

  Future<http.Response> patch(url,
      {dynamic body, Map<String, String> headers = const {}}) async {
    return _request(OApiRequest(url,
        method: OApiRequestMethod.PATCH, body: body, headers: headers));
  }

  Future<http.Response> put(url,
      {dynamic body, Map<String, String> headers = const {}}) async {
    return _request(OApiRequest(url,
        method: OApiRequestMethod.PUT, body: body, headers: headers));
  }

  Future<http.Response> delete(url,
      {Map<String, String> headers = const {}}) async {
    return _request(
        OApiRequest(url, method: OApiRequestMethod.DELETE, headers: headers));
  }
}
