import 'ozone/api_request.dart';
import 'ozone/api_service.dart';
import 'ozone/ozone.dart';

const DEV_MODE = false,
    API = 'https://api.example.com',
    API_DEV = 'http://api.example.com',
    API_KEY = 'C055DB5D-7EF6DB26-48A5043E-D10BD9D0',
    API_KEY_DEV = 'C055DB5D-7EF6DB26-48A5043E-D10BD9D0';

Future<void> run() async {
  var oz = OZone(
    api: DEV_MODE ? API_DEV : API,
    apiKey: DEV_MODE ? API_KEY_DEV : API_KEY,
  );

  var svc = OApiService(name: 'service-name', oz: oz);
  try {
    var res = await svc.getItem('1');

    if (res.isError) {
      print('Server responded with error: ${res.message}; utime: ${res.utime}');
    } else {
      print(res.data);
    }
  } on OApiRequestError catch (_) {
    print(_.toJson());
  }
}

void main(List<String> arguments) {
  run();
}
