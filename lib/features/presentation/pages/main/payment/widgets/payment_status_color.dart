import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';

Color getPaymentStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return AppColors.matGreen;
    case 'pending':
      return AppColors.amber;
    case 'failed':
      return AppColors.matRed;
    case 'refunded':
      return AppColors.purple;
    default:
      return AppColors.grey;
  }
}
