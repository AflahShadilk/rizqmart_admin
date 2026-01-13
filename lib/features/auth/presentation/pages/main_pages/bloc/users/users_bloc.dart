import 'package:flutter_bloc/flutter_bloc.dart';
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
    try {
      final users = await getAllUsersUseCase();
      emit(UsersLoaded(users: users, filteredUsers: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUsersByRole(
    LoadUsersByRole event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final users = await getUsersByRoleUseCase(event.role);
      emit(UsersLoaded(users: users, filteredUsers: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await updateUserStatusUseCase(event.userId, event.isActive);
      add(LoadAllUsers());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await deleteUserUseCase(event.userId);
      add(LoadAllUsers());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
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