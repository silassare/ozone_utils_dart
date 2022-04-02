import 'package:http/http.dart' as http;
import 'utils.dart';

enum OApiRequestMethod { GET, POST, DELETE, PUT, PATCH }
enum OApiRule { EQ, NEQ, LT, LTE, GT, GTE, IS_NULL, IS_NOT_NULL, IN }
enum OApiRuleUnion { OR, AND }

class OApiRequestError {
  final String type;
  final String message;
  final Map<String, dynamic> data;

  OApiRequestError({this.type, this.message, this.data = const {}});

  Map<String, dynamic> toJson() {
    return {'type': type, 'message': message, 'data': data};
  }
}

class OApiRequest {
  final String url;
  final OApiRequestMethod method;
  final Map<String, String> headers;
  final dynamic body;

  OApiRequest(this.url,
      {this.method = OApiRequestMethod.GET,
      this.headers = const {},
      this.body});
}

typedef HandlerFn<A, T> = T Function(A params);
void voidFn(dynamic _) {}

class OApiRequestEnventHandler {
  final HandlerFn<OApiRequest, void> onRequest;
  final HandlerFn<OApiRequestError, void> onError;
  final HandlerFn<http.Response, void> onResponse;

  OApiRequestEnventHandler(
      {this.onRequest = voidFn,
      this.onError = voidFn,
      this.onResponse = voidFn});
}

class OApiFilter {
  final OApiRule rule;
  final String value;
  final OApiRuleUnion ruleUnion;

  OApiFilter(
      {this.rule = OApiRule.EQ,
      this.value,
      this.ruleUnion = OApiRuleUnion.AND});

  factory OApiFilter.fromJson(List<String> json) {
    return OApiFilter(
        rule: enumFromString<OApiRule>(OApiRule.values, json[0]),
        value: json[1],
        ruleUnion:
            enumFromString<OApiRuleUnion>(OApiRuleUnion.values, json[2]));
  }

  List<String> toJson() {
    return [
      rule.toString(),
      value,
      if (ruleUnion != OApiRuleUnion.AND) ruleUnion.toString()
    ];
  }
}

class OApiFilters {
  final Map<String, List<OApiFilter>> _filters = {};

  OApiFilters();

  bool get isEmpty {
    return _filters.isEmpty;
  }

  bool get isNotEmpty {
    return _filters.isNotEmpty;
  }

  OApiFilters addFilter({String column, OApiFilter filter}) {
    assert(column.isNotEmpty);

    if (!_filters.containsKey(column)) {
      _filters[column] = <OApiFilter>[];
    }

    _filters[column].add(filter);

    return this;
  }

  OApiFilters setFilters({String column, List<OApiFilter> filters}) {
    assert(column.isNotEmpty);

    _filters[column] = filters;

    return this;
  }

  List<OApiFilter> getFilters(String column) {
    assert(column.isNotEmpty);

    return _filters[column];
  }

  factory OApiFilters.fromJson(Map<String, List<List<String>>> json) {
    var filters = OApiFilters();
    json.forEach((String column, List<List<String>> filterGroup) {
      filterGroup.forEach((List<String> filterJson) {
        filters.addFilter(
            column: column, filter: OApiFilter.fromJson(filterJson));
      });
    });
    return filters;
  }

  Map<String, List<List<String>>> toJson() {
    return _filters.map((String column, List<OApiFilter> filterGroup) {
      return MapEntry(column, filterGroup.map((item) {
        return item.toJson();
      }));
    });
  }
}
