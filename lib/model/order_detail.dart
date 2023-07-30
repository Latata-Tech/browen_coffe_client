class OrderDetail {
  int total, qty;
  final String name, variant;
  final int? price, id;
  OrderDetail({required this.total, required this.qty, required this.name, required this.variant, this.price, this.id});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(total: json['total'], qty: json['qty'], name: json['name'], variant: json['variant'], price: json['price'] ?? 0, id: json['id'] ?? 0);
  }
}