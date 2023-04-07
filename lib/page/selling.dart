import 'dart:math';

import 'package:browenz_coffee/model/menu.dart';
import 'package:browenz_coffee/service/menu.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';

const List<String> variant = <String>['Hot', 'Ice'];

class Selling extends StatefulWidget {
  final LocalStorage storage;
  const Selling({Key? key, required this.storage}) : super(key: key);

  @override
  State<Selling> createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  late final MenuService menuService;
  late Future<List<Menu>> _futureMenu;
  List<String> categories = <String>['Semua', 'Coffee', 'Tea'];

  @override
  void initState() {
    super.initState();
    menuService = MenuService(widget.storage);
    _futureMenu = menuService.getMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => print("Profil"),
              icon: const Icon(Icons.account_circle_rounded))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              title: const Text('Penjualan'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/selling');
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chipCategories(),
                const SizedBox(
                  height: 20,
                ),
                menuList(),
              ],
            ),
            orderMenu()
          ],
        ),
      ),
    );
  }

  Widget menuList() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 700,
        decoration: BoxDecoration(
            color: const Color(0XFFD9D9D9),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 36,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Cari...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureMenu,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        return CardMenu(
                          menu: snapshot.data![index],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chipCategories() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 700,
      height: 83,
      decoration: BoxDecoration(
          color: const Color(0XFFD9D9D9),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kategori'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(categories[index]),
                    backgroundColor: Colors.white,
                    onSelected: (bool value) {},
                    selected: index == 0,
                    selectedColor: Colors.lightBlue,
                    labelStyle: TextStyle(
                        color: index == 0 ? Colors.white : Colors.black),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget orderMenu() {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color(0XFFD9D9D9)),
        child: Column(
          children: [const Text('Pesanan'), const Divider()],
        ),
      ),
    );
  }
}

class CardMenu extends StatefulWidget {
  final Menu menu;
  const CardMenu({Key? key, required this.menu}) : super(key: key);

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
            Container(height: 30, child: Center(child: Text(widget.menu.name)))
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(gapPadding: 2.0)
                          ),
                            value: selectedVariant,
                            items: variant
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedVariant = value!;
                                price = selectedVariant == 'Hot'
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
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Simpan'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              })),
    );
  }
}
