class UserModel {
  final String fullName;
  final String avatar;
  final int gender;
  final int role;
  UserModel({
    required this.fullName,
    this.avatar = 'default_avatar.jpg',
    this.gender = 0,
    this.role = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'avatar': avatar,
      'gender': gender,
      'role': role,
    };
  }
}
