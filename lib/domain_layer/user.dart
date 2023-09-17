class User {
  int? id;
  String? email;
  String? password;
  String? role;

  User({this.id, this.email, this.password, this.role});

  String? get getPassword => password;

  String? get getRole => role;

  String? get getEmail => email;

  int? get getId => id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'].toString(),
      role: map['role'].toString(),
    );
  }
}