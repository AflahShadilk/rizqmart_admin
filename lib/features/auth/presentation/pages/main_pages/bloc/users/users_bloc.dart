import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/services/web_messaging_service.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/delete_user_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/get_all_users_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/get_users_by_role_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/update_user_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetUsersByRoleUseCase getUsersByRoleUseCase;
  final UpdateUserStatusUseCase updateUserStatusUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UsersBloc({
    required this.getAllUsersUseCase,
    required this.getUsersByRoleUseCase,
    required this.updateUserStatusUseCase,
    required this.deleteUserUseCase,
  }) : super(UsersInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadUsersByRole>(_onLoadUsersByRole);
    on<UpdateUserStatus>(_onUpdateUserStatus);
    on<DeleteUser>(_onDeleteUser);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getAllUsersUseCase();
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users: users, filteredUsers: users)),
    );
  }

  Future<void> _onLoadUsersByRole(
    LoadUsersByRole event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getUsersByRoleUseCase(event.role);
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users: users, filteredUsers: users)),
    );
  }

  Future<void> _onUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<UsersState> emit,
  ) async {
    final result = await updateUserStatusUseCase(event.userId, event.isActive);
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(LoadAllUsers()),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UsersState> emit,
  ) async {
    final result = await deleteUserUseCase(event.userId);
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) {
        WebMessagingService.triggerLocalNotification(
          'User Deleted',
          'User has been deleted successfully.',
          data: {'type': 'user', 'id': event.userId},
        );
        add(LoadAllUsers());
      },
    );
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UsersState> emit,
  ) async {
    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;
      if (event.query.isEmpty) {
        emit(currentState.copyWith(filteredUsers: currentState.users));
      } else {
        final filtered = currentState.users.where((user) {
          final query = event.query.toLowerCase();
          return user.email.toLowerCase().contains(query) ||
              (user.name?.toLowerCase().contains(query) ?? false) ||
              (user.phoneNumber?.toLowerCase().contains(query) ?? false);
        }).toList();
        emit(currentState.copyWith(filteredUsers: filtered));
      }
    }
  }
}