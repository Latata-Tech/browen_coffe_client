import 'package:browenz_coffee/helpers/converter.dart';
import 'package:browenz_coffee/model/order.dart';
import 'package:browenz_coffee/model/order_detail.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

const TextStyle defaultStyle = TextStyle(
  fontSize: 13,
);

class UpdateSelling extends StatefulWidget {
  final OrderService service;
  final String code;
  const UpdateSelling({Key? key, required this.service, required this.code}) : super(key: key);

  @override
  State<UpdateSelling> createState() => _UpdateSellingState();
}

class _UpdateSellingState extends State<UpdateSelling> {
  List<OrderDetail> quantity = [];
  late Future<Order?> futureOrder;
  TextEditingController pay = TextEditingController();
  TextEditingController change = TextEditingController(text: '0');
  List<int> total = [];

  void changeTextFieldValue() {
    int valuePay = 0;
    var totalResult = total.reduce((value, element) => value + element);
    if (pay.value.text.contains('.')) {
      valuePay = int.parse(pay.value.text.split('.').join());
      change.text = '0';
    } else {
      valuePay = int.parse(pay.value.text);
      change.text = '0';
    }
    if (valuePay >= totalResult) {
      change.text = Converter.cIWithoutSymbol(valuePay - totalResult);
    }
  }

  @override
  void initState() {
    super.initState();
    futureOrder = widget.service.getOrderDetail(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Pesanan'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: futureOrder,
                    builder: (BuildContext context, AsyncSnapshot<Order?>snapshot) {
                      print(snapshot.hasData);
                      if(snapshot.hasData) {
                        total = [];
                        quantity = [];
                        for (var element in snapshot.data!.orderDetail) {
                          total.add(element.qty * (element.price ?? 0));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.orderDetail.length,
                          itemBuilder: (context, index) {
                            quantity.add(snapshot.data!.orderDetail[index]);
                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data!.orderDetail[index].name),
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              if (quantity[index].qty != 0) {
                                                setState(() {
                                                  var data = quantity[index].qty - 1;
                                                  quantity[index].qty--;
                                                  total[index] = data * (quantity[index].price ?? 0);
                                                });
                                              }
                                            },
                                            style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black)),
                                            child: const Icon(Icons.remove_circle,
                                                color: Colors.black, size: 11,),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.black)),
                                          width: 50,
                                          height: 20,
                                          child: Center(child: Text(quantity[index].qty.toString())),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                var data = quantity[index].qty + 1;
                                                quantity[index].qty++;
                                                total[index] = data * (quantity[index].price ?? 0);
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  width: 1, color: Colors.black),
                                            ),
                                            child: const Icon(Icons.add_circle,
                                                color: Colors.black, size: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(Converter.currencyIndonesia(quantity[index].qty * (snapshot.data!.orderDetail[index].price ?? 0)))
                                ],
                              ),
                            );
                          },
                        );
                      } else if(snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()),);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: defaultStyle,
                  ),
                  Text(
                    Converter.currencyIndonesia(total.length > 0 ? total.reduce((value, element) => value + element) : 0),
                    style: defaultStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bayar',
                    style: defaultStyle,
                  ),
                  SizedBox(
                    width: 100,
                    height: 18,
                    child: TextField(
                      controller: pay,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (String? value) {
                        changeTextFieldValue();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                              const BorderSide(color: Colors.black))),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          decimalDigits: 0,
                          symbol: '',
                        )
                      ],
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        widget.service.updateOrder(quantity, int.parse(pay.value.text.split('.').join()), widget.code).then((value){
          print("Success");
        });
      }, icon: const Icon(Icons.save), backgroundColor: Colors.blueAccent, label: const Text('Simpan'),),
    );
  }
}
