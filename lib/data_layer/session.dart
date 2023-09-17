import '../domain_layer/user.dart';
import '../domain_layer/user_role.dart';

class Session {
  User? _user;
  UserRole _role = UserRole.unauthorised;
  bool _isAuthenticated = false;

  static Session? _instance;

  Session._();

  static Session getInstance() {
    _instance ??= Session._();
    return _instance!;
  }

  bool isAuthenticated() => _isAuthenticated;
  UserRole? getRole() => _role;
  User? getUser() => _user;

  void login(User user, UserRole role) {
    _user = user;
    _role = role;
    _isAuthenticated = true;
  }

  void logout() {
    _user = null;
    _role = UserRole.unauthorised;
    _isAuthenticated = false;
  }
}