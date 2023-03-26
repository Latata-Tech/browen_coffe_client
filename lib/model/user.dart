class User {
  final int id;
  final String name;
  final String email;
  final int roleId;

  User(this.id, this.name, this. email, this.roleId);

  factory User.fromMap(Map<String, dynamic> json) {
    return User(json['id'], json['name'], json['email'], json['role_id']);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['name'], json['email'], json['role_id']);
  }
}