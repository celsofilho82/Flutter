import 'dart:convert';

import 'package:bytebank2/http/interceptors/logging_interceptor.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Client client = HttpClientWithInterceptor.build(
      interceptors: [LoggingInterceptor()],
    );
    final Uri url = Uri.tryParse('http://10.0.0.104:8080/transactions');
    final Response response =
        await client.get(url).timeout(Duration(seconds: 15));
    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = decodedJson.map((dynamic json) {
      return Transaction.fromJson(json);
    }).toList();

    return transactions;
  }

  Future<Transaction> save(
      Transaction transaction, String password, BuildContext context) async {
    final Client client = HttpClientWithInterceptor.build(
      interceptors: [LoggingInterceptor()],
    );
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber,
      }
    };

    final String transactionJson = jsonEncode(transactionMap);
    final Uri url = Uri.tryParse('http://10.0.0.104:8080/transactions');
    final Response response = await client.post(url,
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return toMap(json);
    }

    _throwHttpError(response);
  }

  void _throwHttpError(Response response) {
    final Map<int, String> _statusCodeResponse = {
      400 : 'there was an error submitting transaction',
      401 : 'authentication failed'
    };

    throw Exception(_statusCodeResponse[response.statusCode]);
  }

  Transaction toMap(Map<String, dynamic> json) {
    final Map<String, dynamic> contactJson = json['contact'];
    return Transaction(
      json['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
  }
}
