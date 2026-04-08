import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/data/models/user_model.dart';

abstract class UserDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> getUsersByRole(String role);
  Future<UserModel> getUserById(String userId);
  Future<void> updateUserStatus(String userId, bool isActive);
  Future<void> deleteUser(String userId);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseFirestore firestore;

  UserDataSourceImpl({required this.firestore});

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .get();

      final allUsers = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
          
      final users = allUsers.where((user) => user.role == role).toList();
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return users;
    } catch (e) {

      throw Exception('Failed to fetch users by role: $e');
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {

      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'isActive': isActive,
      });
    } catch (e) {

      throw Exception('Failed to update user status: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).delete();
    } catch (e) {

      throw Exception('Failed to delete user: $e');
    }
  }

  String extractIndexUrl(String errorMessage) {
    final regex = RegExp(r'https://console\.firebase\.google\.com[^\s\]]+');
    final match = regex.firstMatch(errorMessage);
    return match?.group(0) ?? 'URL not found in error message';
  }
}