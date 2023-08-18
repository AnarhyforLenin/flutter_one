import 'dart:async';
import 'package:flutter_one/cart_product_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
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
    final db = await initDatabase();
    await db.insert(
      'cart',
      cartProductEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartProductEntity>> products() async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) {
      return CartProductEntity(
        productId: maps[i]['product_id'],
        quantity: maps[i]['quantity']
      );
    });
  }

  Future<List<CartProductEntity>> getEntityByProductId(int productId) async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );


    return List.generate(maps.length, (i) {
      return CartProductEntity(
        productId: maps[i]['product_id'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  Future<void> updateProduct(CartProductEntity cartProductEntity) async {
    final db = await initDatabase();

    await db.update(
      'cart',
      cartProductEntity.toMap(),
      where: 'product_id = ?',
      whereArgs: [cartProductEntity.productId],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await initDatabase();
    await db.delete(
      'cart',
      where: 'product_id = ?',
      whereArgs: [id],
    );
  }
}