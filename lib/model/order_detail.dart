class OrderDetail {
  final int total, qty;
  final String name, variant;

  OrderDetail({required this.total, required this.qty, required this.name, required this.variant});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(total: json['total'], qty: json['qty'], name: json['name'], variant: json['variant']);
  }
}