import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllUsers extends UsersEvent {}

class LoadUsersByRole extends UsersEvent {
  final String role;

  const LoadUsersByRole(this.role);

  @override
  List<Object?> get props => [role];
}

class UpdateUserStatus extends UsersEvent {
  final String userId;
  final bool isActive;

  const UpdateUserStatus(this.userId, this.isActive);

  @override
  List<Object?> get props => [userId, isActive];
}

class DeleteUser extends UsersEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SearchUsers extends UsersEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}