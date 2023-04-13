class Dashboard {
  final int earning, totalOrder, orderDone, orderProcess;
  Dashboard({required this.earning, required this.totalOrder, required this.orderDone, required this.orderProcess});

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(earning: json['total_earning'], totalOrder: json['total_order'], orderDone: json['order_done'], orderProcess: json['order_process']);
  }
}