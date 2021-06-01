import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/contact_dao.dart';

Future<Database> createDatabase() async {
  // Implementação usando async -> await

  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    },
    version: 1,
  );
}
