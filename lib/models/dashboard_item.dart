import 'package:flutter/material.dart';


class DashboardItem {
  IconData icon;
  String title;

  DashboardItem({
    required this.icon,
    required this.title});

  static const String product = 'Product';
  static const String category = 'Category';
  static const String orders = 'Orders';
  static const String users = 'Users';
  static const String settings = 'Settings';
  static const String report = 'Report';
}

final List<DashboardItem> dashboardItem =[
  DashboardItem(icon: Icons.card_giftcard, title: DashboardItem.product),
  DashboardItem(icon: Icons.category, title: DashboardItem.category),
  DashboardItem(icon: Icons.currency_exchange, title: DashboardItem.orders),
  DashboardItem(icon: Icons.person, title: DashboardItem.users),
  DashboardItem(icon: Icons.settings, title: DashboardItem.settings),
  DashboardItem(icon: Icons.bar_chart, title: DashboardItem.report),
];
