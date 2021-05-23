import 'package:bytebank2/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() async {
  // Implementação usando async -> await

  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute('CREATE TABLE contacts('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'account_number INTEGER)');
    },
    version: 1,
    // onDowngrade: onDatabaseDowngradeDelete,
  );

  // Implementação usando callback com o then()

  // return getDatabasesPath().then((dbPath) {
  //   final String path = join(dbPath, 'bytebank.db');
  //   return openDatabase(
  //     path,
  //     onCreate: (db, version) {
  //       db.execute('CREATE TABLE contacts('
  //           'id INTEGER PRIMARY KEY, '
  //           'name TEXT, '
  //           'account_number INTEGER)');
  //     },
  //     version: 1,
  //     // onDowngrade: onDatabaseDowngradeDelete,
  //   );
  // });
}

Future<int> save(Contact contact) async {
  // Implementação usando async -> await

  final Database db = await createDatabase();
  return createDatabase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  });

  // Implementação usando callback com o then()

  // return createDatabase().then((db) {
  //   final Map<String, dynamic> contactMap = Map();
  //   contactMap['name'] = contact.name;
  //   contactMap['account_number'] = contact.accountNumber;
  //   return db.insert('contacts', contactMap);
  // });
}

Future<List<Contact>> findAll() async {
  // Implementação usando async -> await

  final List<Contact> contacts = [];
  final Database db = await createDatabase();
  final List<Map<String, dynamic>> result = await db.query('contacts');
  for (Map<String, dynamic> row in result) {
    final Contact contact = Contact(
      row['id'],
      row['name'],
      row['account_number'],
    );
    contacts.add(contact);
  }
  return contacts;

  // Implementação usando callback com o then()

  // return createDatabase().then((db) {
  //   return db.query('contacts').then((maps) {
  //     final List<Contact> contacts = [];
  //     for (Map<String, dynamic> map in maps) {
  //       final Contact contact = Contact(
  //         map['id'],
  //         map['name'],
  //         map['account_number'],
  //       );
  //       contacts.add(contact);
  //     }
  //     return contacts;
  //   });
  // });
}
