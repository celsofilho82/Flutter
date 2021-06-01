class Contact {
  final String name;
  final int accountNumber;
  final int id;

  Contact(
    this.id,
    this.name,
    this.accountNumber,
  );

  Contact.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      name = json['name'],
      accountNumber = json['accountNumber'];

  @override
  String toString() {
    return 'Contact{name: $name, accountNumber: $accountNumber, id: $id}';
  }
}
