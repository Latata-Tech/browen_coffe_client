import 'dart:developer';

import 'package:browenz_coffee/model/menu.dart';
import 'package:browenz_coffee/service/menu.dart';
import 'package:browenz_coffee/widget/card_menu.dart';
import 'package:browenz_coffee/widget/chip_category.dart';
import 'package:browenz_coffee/widget/custom_list_item.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../model/order_menu.dart';

class Selling extends StatefulWidget {
  final LocalStorage storage;
  const Selling({Key? key, required this.storage}) : super(key: key);

  @override
  State<Selling> createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  late final MenuService menuService;
  late Future<List<Menu>> _futureMenu;
  List<OrderMenu> menu = [];

  @override
  void initState() {
    super.initState();
    menuService = MenuService(widget.storage);
    _futureMenu = menuService.getMenus();
  }

  void addMenuItem(OrderMenu orderMenu) {
    setState(() {
      menu.add(orderMenu);
    });
  }

  void removeMenuItem(int index) {
    setState(() {
      menu.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(menu);
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
                const ChipCategory(),
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
                          menuSelected: addMenuItem,
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

  Widget orderMenu() {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color(0XFFD9D9D9)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Pesanan'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: menu.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomListItem(
                    action: removeMenuItem,
                    menu: menu[index],
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF509D57),
                      fixedSize: Size(double.infinity, 40),
                  ),
                  child: const Text("Buat Pesanan"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
