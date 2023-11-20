import 'dart:async';
import 'package:flutter_one/domain_layer/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain_layer/cart_product_entity.dart';
import '../domain_layer/user.dart';
import '../domain_layer/user_role.dart';
import '../utils/util.dart';

class DataBase {

  static DataBase? _instance;

  factory DataBase() {
    _instance ??= DataBase._();
    return _instance!;
  }

  DataBase._();

  Database? _database;

  Future<Database> _getDatabase() async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'cart_and_users.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS cart(product_id INTEGER UNIQUE, quantity INTEGER)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, email STRING UNIQUE, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS roles(id INTEGER PRIMARY KEY AUTOINCREMENT, role STRING)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS user_roles(user_id INTEGER REFERENCES users(id), role_id INTEGER REFERENCES roles(id))',
        );
        await db.execute(
            "INSERT OR IGNORE INTO users(email, password) VALUES('admin', 'admin228');"
        );
        await db.execute(
            "INSERT OR IGNORE INTO roles (role) VALUES ('USER');"
        );
        await db.execute(
            "INSERT OR IGNORE INTO roles (role) VALUES ('ADMIN');"
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS products(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, imageUrl STRING, price INTEGER, description STRING)',
        );
        await db.execute(
            "INSERT OR IGNORE INTO products(name, imageUrl, price, description) VALUES"
                "('RedBull BeachBreeze', 'assets/images/beachbreeze.png', '20', 'Энергетик со вкусом бриза на пляже. В России не продается.'),"
                "('RedBull Acai', 'assets/images/acai.png', '10', 'Энергетик с Асаи. В России не продается.'),"
                "('RedBull Cactus', 'assets/images/cactus.png', '999', 'Энергетик со вкусом кактуса. В России не продается.'),"
                "('RedBull Classic', 'assets/images/classic.png', '40', 'Энергетик RedBull классический. Есть в России и по всему миру.'),"
                "('RedBull Coconut', 'assets/images/coconut.png', '50', 'Энергетик со вкусом кокоса и ягод. Есть по всему миру. Просто прекрасен.'),"
                "('RedBull Grapefruit', 'assets/images/grapefruit.png', '60', 'Энергетик со вкусом грейпфрута. В России не продается.'),"
                "('RedBull Kiwi&Apple', 'assets/images/kiwiapple.png', '70', 'Энергетик со вкусом киви и яблока. В России не продается.'),"
                "('RedBull No Sugar', 'assets/images/nosugar.png', '80', 'Энергетик RedBull без сахара. Есть в России и по всему миру.'),"
                "('RedBull Kratingdaeng', 'assets/images/small.png', '90', 'Энергетик странный и маленький. В России не продается.'),"
                "('RedBull Tangerine', 'assets/images/tangerine.png', '150', 'Энергетик с тангарином. В России не продается.'),"
                "('RedBull Watermelon', 'assets/images/watermelon.png', '110', 'Энергетик со вкусом арбуза. Есть в России и по всему миру.');"
        );
        final adminUserId = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT id FROM users WHERE email = 'admin';",
        ));
        final adminRoleId = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT id FROM roles WHERE role = 'ADMIN';",
        ));
        if (adminUserId != null && adminRoleId != null) {
          db.execute(
            "INSERT OR IGNORE INTO user_roles(user_id, role_id) VALUES($adminUserId, $adminRoleId);",
          );
        }
      },
      version: 2,
    );
    return database;
  }

  Future<void> insertProductIntoCart(CartProductEntity cartProductEntity) async {
    final db = await _getDatabase();
    await db.insert(
      Util.tableCart,
      cartProductEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUser(User user) async {
    final db = await _getDatabase();
    await db.insert(
      Util.tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUserRole(int userId, int roleId) async {
    final db = await _getDatabase();
    await db.insert(
      Util.tableUserRoles,
      Util.mapToUserRole(userId, roleId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserRole?> getUserRoleById(int roleId) async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> roles = await db.query(
      Util.tableRoles,
      where: '${Util.columnId} = ?',
      whereArgs: [roleId],
      limit: 1,
    );

    if (roles.isNotEmpty) {
      return Util.getUserRoleByString(roles[0][Util.columnRole]);
    } else {
      return null;
    }
  }

  Future<int?> getIdByUserRole(UserRole userRole) async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> roles = await db.query(
      Util.tableRoles,
      where: 'LOWER(${Util.columnRole}) = ?',
      whereArgs: [Util.getStringByUserRole(userRole)],
      limit: 1,
    );

    if (roles.isNotEmpty) {
      return roles[0][Util.columnId];
    } else {
      return null;
    }
  }

  Future<int?> reload() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> roles = await db.query(
      'cart',
      where: 'id = ?',
      limit: 1,
    );
  }

  Future<int?> getRoleIdByUserId(int userId) async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> roles = await db.query(
      Util.tableUserRoles,
      where: '${Util.columnUserId} = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (roles.isNotEmpty) {
      return roles[0][Util.columnRoleId];
    } else {
      return null;
    }
  }

  Future<List<CartProductEntity>> products() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) => CartProductEntity.fromMap(maps[i]));
  }

  //новая бд
  Future<List<Product>> getProductList() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }
  //

  Future<bool> hasProducts(int productId) async{
    return await getProductById(productId) == null;
  }

  Future<CartProductEntity?> getProductById(int productId) async {
    final db = await _getDatabase();

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

  Future<bool> hasUser(String email) async{
    return await getUserByEmail(email) != null;
  }

  Future<String?> getPasswordByEmail(String email) async{
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      Util.tableUsers,
      where: '${Util.columnEmail} = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]).getPassword;
    } else {
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      Util.tableUsers,
      where: '${Util.columnEmail} = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  Future<void> updateProduct(CartProductEntity cartProductEntity) async {
    final db = await _getDatabase();

    await db.update(
      Util.tableCart,
      cartProductEntity.toMap(),
      where: '${Util.columnProductId} = ?',
      whereArgs: [cartProductEntity.productId],
    );
  }

  Future<void> updateUser(User user) async {
    final db = await _getDatabase();

    await db.update(
      Util.tableUsers,
      User().toMap(),
      where: '${Util.columnEmail} = ?',
      whereArgs: [user.email],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _getDatabase();
    await db.delete(
      Util.tableCart,
      where: '${Util.columnProductId} = ?',
      whereArgs: [id],
    );
  }
}
