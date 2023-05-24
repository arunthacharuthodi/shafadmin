class FirebaseUser {
  final String adhar;
  final String email;
  final bool isAdmin;
  final bool isApproved;
  final String name;

  FirebaseUser({
    required this.adhar,
    required this.email,
    required this.isAdmin,
    required this.isApproved,
    required this.name,
  });

  factory FirebaseUser.fromMap(Map<String, dynamic> data) {
    return FirebaseUser(
      adhar: data['adhar'],
      email: data['email'],
      isAdmin: data['isAdmin'],
      isApproved: data['isApproved'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adhar': adhar,
      'email': email,
      'isAdmin': isAdmin,
      'isApproved': isApproved,
      'name': name,
    };
  }
}
