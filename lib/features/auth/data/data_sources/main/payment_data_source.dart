import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmartadmin/features/auth/data/model/payment_analitics_model.dart';
import 'package:rizqmartadmin/features/auth/data/model/payment_model.dart';

abstract class PaymentDataSource {
  Future<List<PaymentModel>> getAllPayments();
  Future<List<PaymentModel>> getPaymentsByStatus(String status);
  Future<List<PaymentModel>> getPaymentsByDateRange(DateTime start, DateTime end);
  Future<PaymentModel> getPaymentById(String paymentId);
  Future<PaymentAnalyticsModel> getPaymentAnalytics();
  Future<void> refundPayment(String paymentId, double amount);
  Future<PaymentModel> getPaymentByOrderId(String orderId);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final FirebaseFirestore firestore;

  PaymentDataSourceImpl({required this.firestore});

  @override
  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch payments: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByStatus(String status) async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch payments by status: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {

      throw Exception('Failed to fetch payments by date range: $e');
    }
  }

  @override
  Future<PaymentModel> getPaymentById(String paymentId) async {
    try {
      final doc = await firestore.collection('payments').doc(paymentId).get();
      return PaymentModel.fromFirestore(doc);
    } catch (e) {

      throw Exception('Failed to fetch payment: $e');
    }
  }

  @override
  Future<PaymentAnalyticsModel> getPaymentAnalytics() async {
    try {
      final snapshot = await firestore.collection('payments').get();

      double totalRevenue = 0;
      double completedAmount = 0;
      double pendingAmount = 0;
      double failedAmount = 0;
      double refundedAmount = 0;
      int completedCount = 0;
      int pendingCount = 0;
      int failedCount = 0;
      int refundedCount = 0;

      for (var doc in snapshot.docs) {
        final model = PaymentModel.fromFirestore(doc);
        final amount = model.amount;

        totalRevenue += amount;

        switch (model.status) {
          case 'completed':
            completedAmount += amount;
            completedCount++;
            break;
          case 'pending':
            pendingAmount += amount;
            pendingCount++;
            break;
          case 'failed':
            failedAmount += amount;
            failedCount++;
            break;
          case 'refunded':
            refundedAmount += model.refundedAmount ?? 0;
            refundedCount++;
            break;
        }
      }

      final successRate = snapshot.docs.isNotEmpty
          ? (completedCount / snapshot.docs.length * 100)
          : 0.0;

      return PaymentAnalyticsModel(
        totalRevenue: totalRevenue,
        completedAmount: completedAmount,
        pendingAmount: pendingAmount,
        failedAmount: failedAmount,
        refundedAmount: refundedAmount,
        totalTransactions: snapshot.docs.length,
        completedCount: completedCount,
        pendingCount: pendingCount,
        failedCount: failedCount,
        refundedCount: refundedCount,
        successRate: successRate,
      );
    } catch (e) {

      throw Exception('Failed to fetch payment analytics: $e');
    }
  }

  @override
  Future<void> refundPayment(String paymentId, double amount) async {
    try {
      await firestore.collection('payments').doc(paymentId).update({
        'status': 'refunded',
        'refundedAmount': amount,
        'refundedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {

      throw Exception('Failed to refund payment: $e');
    }
  }

  @override
  Future<PaymentModel> getPaymentByOrderId(String orderId) async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Payment not found for Order ID: $orderId');
      }

      return PaymentModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to fetch payment by order ID: $e');
    }
  }

  // Helper method to extract index URL from error message
  String _extractIndexUrl(String errorMessage) {
    final regex = RegExp(r'https://console\.firebase\.google\.com[^\s\]]+');
    final match = regex.firstMatch(errorMessage);
    return match?.group(0) ?? 'URL not found in error message';
  }
}
