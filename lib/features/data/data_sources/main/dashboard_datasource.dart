import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/data/models/dashboard_stats_model.dart';

abstract class DashboardDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final FirebaseFirestore firestore;

  DashboardDataSourceImpl({required this.firestore});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final ordersSnapshot = await firestore.collection('orders').get();
      double dailyRevenue = 0;
      int pendingOrders = 0;
      
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        
        if (data['orderStatus'] == 'pending' || data['orderStatus'] == 'processing') {
          pendingOrders++;
        }

        if (data['paymentStatus'] == 'succeeded' && 
            data['orderStatus'] != 'cancelled' && 
            data['orderStatus'] != 'rejected' &&
            data['orderStatus'] != 'refunded') {
            
             var amount = data['totalAmount'] ?? data['total'] ?? data['totalCost'] ?? 0.0;
             if (amount is int) amount = amount.toDouble();
             if (amount is String) amount = double.tryParse(amount) ?? 0.0;
             
             dynamic createdAtData = data['createdAt'];
             DateTime? createdAt;
             if (createdAtData is Timestamp) {
               createdAt = createdAtData.toDate();
             } else if (createdAtData is String) {
               createdAt = DateTime.tryParse(createdAtData);
             }
             
             if (createdAt != null && 
                 createdAt.isAfter(todayStart) && 
                 createdAt.isBefore(todayEnd)) {
               dailyRevenue += amount;
             }
        }
      }

      final productsSnapshot = await firestore.collection('products').count().get();
      final totalProducts = productsSnapshot.count ?? 0;

      final allUsersSnapshot = await firestore.collection('users').get();
      final totalUsers = allUsersSnapshot.docs.where((doc) {
        final data = doc.data();
        return (data['role'] ?? 'user') == 'user';
      }).length;

      return DashboardStatsModel.fromData(
        dailyRevenue: dailyRevenue,
        totalOrders: ordersSnapshot.size,
        pendingOrders: pendingOrders,
        totalProducts: totalProducts,
        totalUsers: totalUsers,
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }
}
