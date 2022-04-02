import 'api_client.dart';
import 'api_request.dart';
import 'utils.dart';

class OZone {
  final String api;
  final String apiKey;
  final String apiKeyHeaderName;
  final String realMethodHeaderName;
  final bool useRealMethodHeader;

  OZone(
      {this.api,
      this.apiKey,
      this.apiKeyHeaderName = 'x-ozone-api-key',
      this.realMethodHeaderName = 'x-ozone-real-method',
      this.useRealMethodHeader = false});

  String buildUrl(String path, {Map<String, dynamic> queries = const {}}) {
    var base = api.replaceAll(RegExp(r'/$'), '');
    path = path.replaceAll(RegExp(r'^/'), '');

    var query = buildQueryString(queries);

    query = query.isNotEmpty ? '?$query' : '';

    return '$base/$path$query';
  }

  OApiClient getClient() {
    var handler = OApiRequestEnventHandler(onRequest: (OApiRequest _) {
      _.headers[apiKeyHeaderName] = apiKey;
    });
    var client = OApiClient(
        realMethodHeaderName: realMethodHeaderName,
        useRealMethodHeader: useRealMethodHeader,
        handler: handler);

    return client;
  }
}
