class User {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;

  User({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
  });
}
