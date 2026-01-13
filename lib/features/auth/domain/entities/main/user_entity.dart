import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final String role; 
  final Map<String, dynamic>? metadata;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
    required this.isActive,
    required this.role,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        profileImageUrl,
        createdAt,
        lastLoginAt,
        isActive,
        role,
        metadata,
      ];
}