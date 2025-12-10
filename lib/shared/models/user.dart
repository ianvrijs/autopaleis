class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final List<String> authorities;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.authorities = const ['ROLE_USER'],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<String> authorities = ['ROLE_USER'];
    final authoritiesList = json['authorities'] as List?;
    if (authoritiesList != null && authoritiesList.isNotEmpty) {
      authorities = authoritiesList.cast<String>();
    }
    return User(
      id: (json['id'] ?? '').toString(),
      username: json['login'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      authorities: authorities,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'login': username, 'email': email, 'firstName': firstName, 'lastName': lastName};
  }

  User copyWith({String? id, String? username, String? email, String? firstName, String? lastName, List<String>? authorities}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      authorities: authorities ?? this.authorities,
    );
  }
}
