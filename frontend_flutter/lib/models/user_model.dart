// ============================================================
// user_model.dart — User Data Model
// ============================================================
class UserModel {
  final String  id;
  final String  name;
  final String  email;
  final String? avatarUrl;
  final String  role; // 'user' | 'admin'

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:        json['_id']      as String,
    name:      json['name']     as String,
    email:     json['email']    as String,
    avatarUrl: json['avatar']   as String?,
    role:      json['role']     as String? ?? 'user',
  );

  Map<String, dynamic> toJson() => {
    '_id':    id,
    'name':   name,
    'email':  email,
    'avatar': avatarUrl,
    'role':   role,
  };
}
