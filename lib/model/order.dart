import 'order_detail.dart';

class Order {
  final String code, paymentType;
  final List<OrderDetail> orderDetail;
  final int total;
  final String orderDate;
  final String cashier;
  final int discount;
  Order({required this.code, required this.orderDetail, required this.paymentType, required this.total, required this.orderDate, required this.cashier, required this.discount});
  
  factory Order.fromJson(Map<String, dynamic> json, List<OrderDetail> orderDetail) {
    return Order(code: json['code'], paymentType: json['payment_type'], orderDetail: orderDetail, total: json['total'], orderDate: json['orderDate'], cashier: json['cashier'], discount: json['discount']);
  }
}