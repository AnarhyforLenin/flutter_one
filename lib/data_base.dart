import 'dart:async';
import 'dart:ffi';
import 'package:flutter_one/cart_product_entity.dart';
import 'package:flutter_one/util.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {

  static DataBase? _instance;

  factory DataBase() {
    _instance ??= DataBase._();
    return _instance!;
  }

  DataBase._();

  Database? _database;

  Future<Database> getDatabase() async {
    _database ??= await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'cart_products.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS cart(product_id INTEGER UNIQUE, quantity INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertProductIntoCart(CartProductEntity cartProductEntity) async {
    final db = await getDatabase();
    await db.insert(
      Util.tableCart,
      cartProductEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartProductEntity>> products() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) => CartProductEntity.fromMap(maps[i]));
  }

  Future<bool> hasProducts(int productId) async{
    return await getProductById(productId) == null;
  }

  Future<CartProductEntity?> getProductById(int productId) async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      Util.tableCart,
      where: '${Util.columnProductId} = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return CartProductEntity.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  Future<void> updateProduct(CartProductEntity cartProductEntity) async {
    final db = await getDatabase();

    await db.update(
      Util.tableCart,
      cartProductEntity.toMap(),
      where: '${Util.columnProductId} = ?',
      whereArgs: [cartProductEntity.productId],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await getDatabase();
    await db.delete(
      Util.tableCart,
      where: '${Util.columnProductId} = ?',
      whereArgs: [id],
    );
  }
}