class User {
  int? id;
  String? email;
  String? password;

  User({this.id, this.email, this.password});

  String? get getPassword => password;

  String? get getEmail => email;

  int? get getId => id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'].toString(),
    );
  }
}