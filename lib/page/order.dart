import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/alert.dart';
import 'package:browenz_coffee/widget/detail_order.dart';
import 'package:flutter/material.dart';
import '../model/order.dart' as order_model;

class Order extends StatefulWidget {
  final OrderService orderService;

  const Order({Key? key, required this.orderService}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late final Future<List<order_model.Order>> _futureOrder;

  @override
  void initState() {
    _futureOrder = widget.orderService.getOrder();
    super.initState();
  }

  void displayOrder(order_model.Order order) {
    showDialog(
        context: context,
        builder: (BuildContext context) => DetailOrder(order: order));
  }

  void markAsDone(String orderCode) {
    widget.orderService.orderDone(orderCode).then((value) {
      final snackBar = alert(
          value[1], value[0] == 'success' ? Colors.green : Colors.redAccent);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: const Text(
              'Daftar pesanan belum di proses',
              style: TextStyle(fontSize: 21),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: widget.orderService.getOrder(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<order_model.Order>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var orderItems = snapshot.data![index].orderDetail
                                .map((value) =>
                                    Text("${value.name}-Qty:${value.qty}"))
                                .toList();
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.receipt),
                                title: Text(snapshot.data![index].code),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: orderItems.length > 2
                                      ? orderItems.sublist(0, 2)
                                      : orderItems,
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<Widget>>[
                                    PopupMenuItem(
                                      child: const Text('Selesai'),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(seconds: 0),
                                            () => showDialog(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  content: Text(
                                                        'Apakah anda ingin menyelesaikan\nproses pesanan ${snapshot.data![index].code}', textAlign: TextAlign.center),
                                                  actionsAlignment: MainAxisAlignment.center,
                                                  actions: [
                                                    OutlinedButton(
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      style: OutlinedButton.styleFrom(
                                                          side: const BorderSide(color: Colors.redAccent)),
                                                      child: const Text('Tutup', style: TextStyle(color: Colors.redAccent)),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        markAsDone(snapshot.data![index].code);
                                                        Navigator.of(context).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green
                                                      ),
                                                      child: const Text('Ya', style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ],
                                                ))
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () =>
                                    displayOrder(snapshot.data![index]),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Tidak ada pesanan yang belum di proses.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError as String);
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ))
        ],
      ),
    );
  }
}
