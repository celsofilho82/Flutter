import 'package:path/path.dart';

import 'contact.dart';

class Transaction {
  final String id;
  final double value;
  final Contact contact;

  Transaction(
    this.value,
    this.contact,
    this.id,
  );

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        contact = Contact.fromJson(json['contact']);

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
