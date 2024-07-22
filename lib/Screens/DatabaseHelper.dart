import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqldemo/Screens/Model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE products ( 
      id $idType, 
      name $textType,
      description $textType,
      imagePath $textType
      )
    ''');
  }

  Future<Product> create(Product product) async {
    final db = await instance.database;
    final id = await db.insert('products', product.toMap());
    return product;
  }

  Future<Product> readProduct(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'products',
      columns: ['id', 'name', 'description', 'imagePath'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;

    final orderBy = 'id ASC';
    final result = await db.query('products', orderBy: orderBy);

    return result.map((json) => Product.fromMap(json)).toList();
  }

  Future<int> update(Product product) async {
    final db = await instance.database;

    return db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
