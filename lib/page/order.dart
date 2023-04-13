import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/detail_order.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 12),
              child: const Text('Daftar pesanan belum di proses', style: TextStyle(
                fontSize: 21
              ),),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: _futureOrder,
                    builder: (BuildContext context, AsyncSnapshot<List<order_model.Order>> snapshot) {
                      if(snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                            var orderItems = snapshot.data![index].orderDetail.map((value) => Text("${value.name}-Qty:${value.qty}")).toList();
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.receipt),
                                  title: Text(snapshot.data![index].code),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: orderItems.length > 2 ? orderItems.sublist(0, 2) : orderItems,
                                  ),
                                  trailing: const Icon(Icons.more_vert),
                                  onTap: () => showDialog(context: context, builder: (BuildContext context) => DetailOrder(order: snapshot.data![index])),
                                ),
                              );
                            },
                        );
                      } else if(snapshot.hasError) {
                        return Text(snapshot.hasError as String);
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                )
            )
          ],
      ),
    );
  }
}
