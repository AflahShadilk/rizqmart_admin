import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;

  const UsersLoaded({
    required this.users,
    required this.filteredUsers,
  });

  @override
  List<Object?> get props => [users, filteredUsers];

  UsersLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
    );
  }
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserStatusUpdated extends UsersState {}

class UserDeleted extends UsersState {}