import 'package:gobl_utils_dart/gobl_utils_dart.dart';

import 'api_request.dart';
import 'api_response.dart';
import 'ozone.dart';

class OApiService<Entity extends GoblEntity> {
  final String name;
  final OZone oz;

  OApiService({
    this.name,
    this.oz,
  });

  Map<String, dynamic> _buildOptions(
      {Map<String, dynamic> filters = const {},
      int max = 20,
      int page = 1,
      String collection = '',
      String relations = ''}) {
    return {
      if (relations.isNotEmpty) 'relations': relations,
      if (collection.isNotEmpty) 'collection': collection,
      if (max.isFinite) 'max': max.toString(),
      if (page.isFinite) 'page': page.toString(),
      if (filters.isNotEmpty) 'filters': filters,
    };
  }

  Future<OApiGetItemResponse<Entity>> getItem(String id,
      {String relations = ''}) async {
    var client = oz.getClient();
    var path = '$name/$id';
    var url = oz.buildUrl(path,
        queries: {if (relations.isNotEmpty) 'relations': relations});

    final response = await client.get(url);

    return OApiGetItemResponse<Entity>(response);
  }

  Future<OApiGetItemsResponse<Entity>> getItems(
      {OApiFilters filters,
      int max = 20,
      int page = 1,
      String collection = '',
      String relations = ''}) async {
    var client = oz.getClient();
    var path = '$name';
    var url = oz.buildUrl(path,
        queries: _buildOptions(
            max: max,
            page: page,
            collection: collection,
            relations: relations));

    final response = await client.get(url);

    return OApiGetItemsResponse<Entity>(response);
  }

  Future<OApiUpdateResponse<Entity>> updateItem(
      {String id, Map<String, dynamic> data}) async {
    var client = oz.getClient();
    var path = '$name/$id';
    var url = oz.buildUrl(path);
    var response = await client.patch(url, body: data);

    return OApiUpdateResponse<Entity>(response);
  }

  Future<OApiUpdateAllResponse> updateItems(
      {OApiFilters filters,
      Map<String, dynamic> data,
      int max = 20,
      int page = 1}) async {
    var client = oz.getClient();
    var path = '$name';
    var url = oz.buildUrl(path);
    var body = _buildOptions(max: max, page: page, filters: filters.toJson());

    body['form_data'] = data;

    var response = await client.patch(url, body: body);

    return OApiUpdateAllResponse(response);
  }

  Future<OApiUpdateResponse<Entity>> deleteItem(String id) async {
    var client = oz.getClient();
    var path = '$name/$id';
    var url = oz.buildUrl(path);
    final response = await client.delete(url);

    return OApiUpdateResponse<Entity>(response);
  }

  Future<OApiDeleteAllResponse> deleteItems(
      {OApiFilters filters, int max = 20, int page = 1}) async {
    var client = oz.getClient();
    var path = '$name';
    var url =
        oz.buildUrl(path, queries: _buildOptions(filters: filters.toJson()));
    final response = await client.delete(url);

    return OApiDeleteAllResponse(response);
  }
}
