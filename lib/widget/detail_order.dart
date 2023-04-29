import 'package:browenz_coffee/helpers/converter.dart';
import 'package:flutter/material.dart';
import '../model/order.dart';

const TextStyle defaultStyle = TextStyle(
  fontSize: 13,
);

class _ListOrderItem extends StatelessWidget {
  const _ListOrderItem(
      {Key? key,
      required this.name,
      required this.quantity,
      required this.price,
      required this.variant})
      : super(key: key);

  final String name, variant;
  final int quantity, price;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$name - $variant", style: defaultStyle),
              Text(
                "Qty:$quantity",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(Converter.currencyIndonesia(price),
              style: const TextStyle(
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}

class DetailOrder extends StatelessWidget {
  final Order order;
  const DetailOrder({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detail Pesanan ${order.code} - ${order.paymentType}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: order.orderDetail
                    .map(
                      (value) => _ListOrderItem(
                        name: value.name,
                        quantity: value.qty,
                        price: value.total,
                        variant: value.variant,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: defaultStyle,
                ),
                Text(
                  Converter.currencyIndonesia(order.total),
                  style: defaultStyle,
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        Container(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent)),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
