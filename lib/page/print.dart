import 'package:flutter/material.dart';

import '../helpers/converter.dart';
import '../model/order.dart';


class Print extends StatelessWidget {
  final Order order;
  final List<String> orderDate;

  const Print({Key? key, required this.order, required this.orderDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Struk'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 2,
          child: Column(
            children: [
              const Text('BROWENZ COFFEE'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDate[0]),
                  Text(orderDate[1])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kasir'),
                  Text(order.cashier)
                ],
              ),
              Divider(),
              Column(
                children: order.orderDetail.map((value) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${value.name}(${value.variant})'),
                      Text('x${value.qty}'),
                      Text('${Converter.currencyIndonesia(value.total)}')
                    ],
                  )
                ,
              ).toList()),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Diskon'),
                  Text('${Converter.currencyIndonesia(order.discount)}')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text('${Converter.currencyIndonesia(order.total)}')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
