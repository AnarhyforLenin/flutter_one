import '../domain_layer/user_role.dart';

class Util {
  static const String columnProductId = 'product_id';
  static const String columnEmail = 'email';
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnRole = 'role';
  static const String columnRoleId = 'role_id';
  static const String tableCart = 'cart';
  static const String tableUsers = 'users';
  static const String tableUserRoles = 'user_roles';
  static const String tableRoles = 'roles';
  static const String tableProducts = 'products';
  static const UserRole defaultRole = UserRole.user;

  static UserRole getUserRoleByString(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      case 'unauthorised':
        return UserRole.unauthorised;
      default:
        throw ArgumentError();
    }
  }

  static String getStringByUserRole(UserRole userRole) {
    return userRole.toString().split('.').last;
  }

  static Map<String, dynamic> mapToUserRole(int userId, int roleId) {
    return {
      columnUserId: userId,
      columnRoleId: roleId
    };
  }


}