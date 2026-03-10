import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

// ---------------- Order Status Color Helper ----------------
Color getOrderStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppColors.amber;
    case 'processing':
      return AppColors.matBlue;
    case 'shipped':
      return AppColors.indigo;
    case 'out for delivery':
      return AppColors.teal;
    case 'delivered':
      return AppColors.matGreen[800]!;
    case 'received':
      return AppColors.matGreen;
    case 'cancelled':
      return AppColors.matRed;
    default:
      return AppColors.grey;
  }
}
