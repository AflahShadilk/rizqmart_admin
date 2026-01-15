import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/dashboard_stats_model.dart';

abstract class DashboardDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final FirebaseFirestore firestore;

  DashboardDataSourceImpl({required this.firestore});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      // 1. Calculate Revenue and Order Counts
      // Note: In a real large-scale app, we should use aggregation queries or cloud functions.
      // For now, we will use default queries or aggregation if available in this SDK version.
      // Assuming standard queries for now to be safe with existing dependencies.
      
      // Total Orders & Revenue
      final ordersSnapshot = await firestore.collection('orders').get();
      double totalRevenue = 0;
      int pendingOrders = 0;
      
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        if (data['paymentStatus'] == 'succeeded' && 
            data['orderStatus'] != 'cancelled' && 
            data['orderStatus'] != 'rejected' &&
            data['orderStatus'] != 'refunded') {
            
             // Parse amount safely
             var amount = data['totalAmount'] ?? data['total'] ?? data['totalCost'] ?? 0.0;
             if (amount is int) amount = amount.toDouble();
             if (amount is String) amount = double.tryParse(amount) ?? 0.0;
             
             totalRevenue += amount;
        }

        if (data['orderStatus'] == 'pending' || data['orderStatus'] == 'processing') {
          pendingOrders++;
        }
      }

      // 2. Product Count
      final productsSnapshot = await firestore.collection('products').count().get();
      final totalProducts = productsSnapshot.count ?? 0;

      // 3. User Count
      final usersSnapshot = await firestore.collection('users').count().get();
      final totalUsers = usersSnapshot.count ?? 0;

      return DashboardStatsModel.fromData(
        totalRevenue: totalRevenue,
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
