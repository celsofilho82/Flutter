import 'package:http/http.dart';

Future<void> findAll() async {
  final Uri url = Uri.tryParse('http://192.168.0.109:8080/transactions');
  final Response response = await get(url);
  print(response.body);
}