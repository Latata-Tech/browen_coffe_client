import 'dart:math';
import 'package:browenz_coffee/widget/alert.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../model/menu.dart';
import '../model/order_menu.dart';

const List<String> variant = <String>['hot', 'ice'];

class CardMenu extends StatefulWidget {
  final Menu menu;
  final Function menuSelected;
  const CardMenu({Key? key, required this.menu, required this.menuSelected})
      : super(key: key);

  @override
  State<CardMenu> createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  late String selectedVariant;
  late int price;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    if (widget.menu.hotPrice == 0) {
      selectedVariant = variant.last;
      price = widget.menu.coldPrice;
    } else {
      selectedVariant = variant.first;
      price = widget.menu.hotPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.menu.photo))),
            )),
            SizedBox(height: 30, child: Center(child: Text(widget.menu.name)))
          ],
        ),
      ),
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.menu.name),
                      Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(price),
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Varian'),
                        DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(gapPadding: 2.0)),
                            value: selectedVariant,
                            items: variant
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedVariant = value!;
                                price = selectedVariant == 'hot'
                                    ? widget.menu.hotPrice
                                    : widget.menu.coldPrice;
                              });
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  if (quantity != 0) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.black)),
                                child: const Icon(Icons.remove_circle,
                                    color: Colors.black),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black)),
                                width: 100,
                                height: 40,
                                child: Center(child: Text(quantity.toString())),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                    log(quantity);
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                                child: const Icon(Icons.add_circle,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () {
                        setState(() {
                          quantity = 0;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Simpan'),
                      onPressed: () {
                        if(quantity == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(alert('Quantity tidak boleh 0', Colors.redAccent));
                        } else {
                          widget.menuSelected(
                            OrderMenu(
                                id: widget.menu.id,
                                thumbnail: widget.menu.photo,
                                name: widget.menu.name,
                                price: price,
                                quantity: quantity,
                                variant: selectedVariant),
                          );
                        }
                        setState(() {
                          quantity = 0;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              })),
    );
  }
}
