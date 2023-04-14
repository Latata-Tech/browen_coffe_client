import 'package:browenz_coffee/helpers/converter.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/detail_order.dart';
import 'package:flutter/material.dart';
import '../model/order.dart' as order_model;
import '../model/order.dart';

class StaffSelling extends StatefulWidget {
  final OrderService orderService;
  const StaffSelling({Key? key, required this.orderService}) : super(key: key);

  @override
  State<StaffSelling> createState() => _StaffSellingState();
}

class _StaffSellingState extends State<StaffSelling> {
  late final Future<int> totalOrder;
  late final Future<List<Order>> orders;

  @override
  void initState() {
    totalOrder = widget.orderService.getTotalOrderToday();
    orders = widget.orderService.getOrderToday();
    super.initState();
  }

  void displayOrder(order_model.Order order) {
    showDialog(context: context, builder: (BuildContext context) => DetailOrder(order: order));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Penjualan Hari Ini', style: TextStyle(
                      fontSize: 21
                  ),),
                  FutureBuilder(
                    future: totalOrder,
                      builder: (BuildContext context, AsyncSnapshot<int>snapshot) {
                      if(snapshot.hasData) {
                        return Text(Converter.currencyIndonesia(snapshot.data!));
                      } else if(snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()),);
                      }
                        return CircularProgressIndicator();
                      }
                  )
                ],
              ),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: orders,
                    builder: (BuildContext context, AsyncSnapshot<List<order_model.Order>> snapshot) {
                      if(snapshot.hasData) {
                        return snapshot.data!.isNotEmpty ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.receipt),
                                title: Text(snapshot.data![index].code),
                                trailing: Text(Converter.currencyIndonesia(snapshot.data![index].total)) ,
                                onTap: () => displayOrder(snapshot.data![index]),
                              ),
                            );
                          },
                        ) : const Center(child: Text('Tidak ada pesanan', style: TextStyle(color: Colors.grey),),);
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
      ),
    );
  }
}
