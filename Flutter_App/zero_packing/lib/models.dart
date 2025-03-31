import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuItem {
  final String id;
  final String name;
  final int price;

  MenuItem({required this.id, required this.name, required this.price});
}

// lib/models/order.dart
class Order {
  final List<MenuItem> items;
  final String customerName;
  final String customerPhone;
  final DateTime orderTime;
  bool isCompleted;

  Order(
      {required this.items,
      required this.customerName,
      required this.customerPhone,
      required this.orderTime,
      this.isCompleted = false});
}

class OrderProvider with ChangeNotifier {
  List<MenuItem> _cartItems = [];
  List<Order> _orders = [];

  List<MenuItem> get cartItems => [..._cartItems];
  List<Order> get orders => [..._orders];

  void addToCart(MenuItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void createOrder(String name, String phone) {
    _orders.add(Order(
        items: _cartItems,
        customerName: name,
        customerPhone: phone,
        orderTime: DateTime.now()));
    _cartItems.clear();
    notifyListeners();
  }

  void completeOrder(Order order) {
    order.isCompleted = true;
    notifyListeners();
  }
}