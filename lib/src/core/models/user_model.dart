class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final bool isSeniorOrPwd;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.allergies,
    required this.dietaryPreferences,
    this.isSeniorOrPwd = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'allergies': allergies,
      'dietaryPreferences': dietaryPreferences,
      'isSeniorOrPwd': isSeniorOrPwd,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      dietaryPreferences: List<String>.from(map['dietaryPreferences'] ?? []),
      isSeniorOrPwd: map['isSeniorOrPwd'] ?? false,
    );
  }
}
