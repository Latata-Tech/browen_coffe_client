import 'package:browenz_coffee/helpers/converter.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/detail_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/order.dart' as order_model;
import '../model/order.dart';

class OwnerSelling extends StatefulWidget {
  final OrderService orderService;
  const OwnerSelling({Key? key, required this.orderService}) : super(key: key);

  @override
  State<OwnerSelling> createState() => _OwnerSellingState();
}

class _OwnerSellingState extends State<OwnerSelling> {
  late Future<int> totalOrder;
  late Future<List<Order>> orders;

  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    stateGet(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  void stateGet(String? date) {
    totalOrder = widget.orderService.getTotalOrders(date);
    orders = widget.orderService.getOrders(date);
  }

  void displayOrder(order_model.Order order) {
    showDialog(
        context: context,
        builder: (BuildContext context) => DetailOrder(order: order));
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daftar Penjualan',
                        style: TextStyle(fontSize: 21),
                      ),
                      FutureBuilder(
                          future: totalOrder,
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  Converter.currencyIndonesia(snapshot.data!));
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            return CircularProgressIndicator();
                          })
                    ],
                  ),
                  Container(
                    width: 200,
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller:
                          dateinput, //editing controller of this TextField
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                            stateGet(formattedDate);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: orders,
                builder: (BuildContext context,
                    AsyncSnapshot<List<order_model.Order>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.isNotEmpty
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.receipt),
                                  title: Text(snapshot.data![index].code),
                                  trailing: Text(Converter.currencyIndonesia(
                                      snapshot.data![index].total)),
                                  onTap: () =>
                                      displayOrder(snapshot.data![index]),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'Tidak ada pesanan',
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
      ),
    );
  }
}
