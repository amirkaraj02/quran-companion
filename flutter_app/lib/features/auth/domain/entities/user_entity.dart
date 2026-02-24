class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.createdAt,
  });
}