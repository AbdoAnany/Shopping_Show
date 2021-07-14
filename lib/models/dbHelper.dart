import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Product.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();
  Database _db;
  createDatabase() async {
    //  _db.delete('pr1');
    if (_db != null) return _db;

    String path = join(await getDatabasesPath(), 'pr.db');
    _db = await openDatabase(path, version: 2,
        onCreate: (Database db, int v) async {
      await db.execute('CREATE TABLE pr1 ('
          'id INTEGER PRIMARY KEY,'
          'title varchar(100),'
          'price INTEGER ,'
          'priceBefore INTEGER,'
          'date  varchar(100) ,'
          'barcode  varchar(100),'
          'description  varchar(500),'
          'image  varchar(500),'
          'type  varchar(100),'
          'category  varchar(100),'
          'rating INTEGER,'
          'isPopular INTEGER '
          ')');
    });
    return _db;
  }

  Future<int> createDateItem(Product productItem) async {
    Database db = await createDatabase();
    return db.insert('pr1', productItem.toMaps());
  }

  allDateItem() async {
    Database db = await createDatabase();
    db.query('pr1');
    return db.query('pr1');
  }

  countItem() async {
    Database db = await createDatabase();
    db.query('pr1');
    return db.query('pr1');
  }

  deleteDateItem(id) async {
    Database db = await createDatabase();
    return db.delete('pr1', where: 'id = ?', whereArgs: [id]);
  }
}
