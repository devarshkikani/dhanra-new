import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String phoneNumber;
  final String displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        displayName,
        photoUrl,
        createdAt,
      ];
}
