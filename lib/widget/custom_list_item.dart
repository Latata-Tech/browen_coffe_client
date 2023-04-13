import 'package:browenz_coffee/model/order_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _ListItemDescription extends StatelessWidget {
  const _ListItemDescription(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.variant});

  final String name, variant;
  final int quantity, price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(price),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                 "varian: $variant",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Text(quantity.toString()),
          ),
        )
      ],
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.index,
    required this.action,
    required this.menu,
  });
  final Function action;
  final OrderMenu menu;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 77,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(menu.thumbnail),
                  ),
                ),
              ),
            ),
            Expanded(
                child: _ListItemDescription(
              name: menu.name,
              price: menu.price,
              quantity: menu.quantity,
              variant: menu.variant,
            )),
            AspectRatio(
              aspectRatio: 0.5,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content:
                              const Text('Yakin ingin menghapus data ini?'),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Simpan'),
                              onPressed: () {
                                action(index);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Icon(Icons.delete_forever),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
