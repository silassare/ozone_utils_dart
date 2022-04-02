import 'package:gobl_utils_dart/gobl_utils_dart.dart';
import 'package:http/http.dart';

class OApiResponse {
  Map<String, dynamic> result;

  OApiResponse(Response response) {
    result = Gobl.parse(response.body);
  }

  bool get isError {
    return result['error'].toString() != '0';
  }

  String get message {
    return result['msg'];
  }

  dynamic get data {
    return result['data'];
  }

  String get utime {
    return result['utime'];
  }

  String get stime {
    return result['stime'];
  }

  String get stoken {
    return result['stoken'];
  }
}

class OApiItemResponse<Entity> extends OApiResponse {
  OApiItemResponse(response) : super(response);

  Entity get item {
    return result['data']['item'];
  }

  Map<String, dynamic> get relations {
    return result['data']['relations'];
  }

  Type getRelation<Type>(String name) {
    return result['data']['relations'][name];
  }
}

class OApiItemWithRelationsResponse<Entity> extends OApiResponse {
  OApiItemWithRelationsResponse(response) : super(response);

  Entity get item {
    return result['data']['item'];
  }
}

class OApiItemsWithRelationsResponse<Entity> extends OApiResponse {
  OApiItemsWithRelationsResponse(response) : super(response);

  int get max {
    return result['data']['max'];
  }

  int get page {
    return result['data']['page'];
  }

  int get total {
    return result['data']['total'];
  }

  List<Entity> get items {
    return result['data']['items'];
  }

  Map<String, dynamic> get relations {
    return result['data']['relations'];
  }

  Type getRelation<Type>(String name) {
    return result['data']['relations'][name];
  }
}

class OApiAffectedCountResponse extends OApiResponse {
  OApiAffectedCountResponse(response) : super(response);

  int get affected {
    return result['data']['affected'];
  }
}

// =================================

class OApiAddResponse<Entity> extends OApiItemWithRelationsResponse<Entity> {
  OApiAddResponse(response) : super(response);
}

class OApiGetItemResponse<Entity>
    extends OApiItemWithRelationsResponse<Entity> {
  OApiGetItemResponse(response) : super(response);
}

class OApiGetItemsResponse<Entity>
    extends OApiItemsWithRelationsResponse<Entity> {
  OApiGetItemsResponse(response) : super(response);
}

class OApiUpdateResponse<Entity> extends OApiItemResponse<Entity> {
  OApiUpdateResponse(response) : super(response);
}

class OApiUpdateAllResponse extends OApiAffectedCountResponse {
  OApiUpdateAllResponse(response) : super(response);
}

class OApiDeleteResponse<Entity> extends OApiItemResponse<Entity> {
  OApiDeleteResponse(response) : super(response);
}

class OApiDeleteAllResponse extends OApiAffectedCountResponse {
  OApiDeleteAllResponse(response) : super(response);
}
