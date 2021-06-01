class Contact {
  final String name;
  final int accountNumber;
  final int id;

  Contact(
    this.id,
    this.name,
    this.accountNumber,
  );

  @override
  String toString() {
    return 'Contact{name: $name, accountNumber: $accountNumber, id: $id}';
  }
}
