import 'package:flutter/material.dart';

class ProfitModel {
  final String date;
  final int totalTransactions;
  final int totalProfit;
  final int totalIncome;
  final int totalOutcome;

  ProfitModel({
    required this.date,
    required this.totalTransactions,
    required this.totalProfit,
    required this.totalIncome,
    required this.totalOutcome,
  });

  factory ProfitModel.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 Parsing: $json');

    return ProfitModel(
      date: json['date'] ?? '',
      totalTransactions: json['total_transactions'] ?? 0,
      totalProfit: json['total_profit'] ?? 0,
      totalIncome: json['total_income'] ?? 0,
      totalOutcome: json['total_outcome'] ?? 0,
    );
  }
}
