import 'package:uuid/uuid.dart';

var uuid = Uuid();

class User {
  final String userId;
  final String name;
  final String email;

  User({String? userId, required this.name, required this.email})
    : userId = userId ?? uuid.v4();

  User copyWith({String? name, String? email}) {
    return User(
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
