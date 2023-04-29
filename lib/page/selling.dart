import 'package:browenz_coffee/model/category.dart';
import 'package:browenz_coffee/model/menu.dart';
import 'package:browenz_coffee/page/order.dart';
import 'package:browenz_coffee/service/category.dart';
import 'package:browenz_coffee/service/menu.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/alert_payment.dart';
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
  late final OrderService orderService;
  late final CategoryService categoryService;
  late Future<List<Menu>> _futureMenu;
  late Future<List<Category>>? _futureCategory;
  Future<List<Menu>>? filteredMenu;
  late int selectedChip;
  List<OrderMenu> menu = [];
  int _selectedNavigation = 0;

  @override
  void initState() {
    super.initState();
    menuService = MenuService(widget.storage);
    orderService = OrderService(widget.storage);
    categoryService = CategoryService(widget.storage);
    _futureMenu = menuService.getMenus();
    _futureCategory = categoryService.getCategories();
    selectedChip = 0;
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

  void removeAllOrderItem() {
    setState(() {
      menu.clear();
    });
  }

  void filterByCategory(int id, int index) {
    setState(() {
      filteredMenu = menuService.getMenus(categoryId: id);
      selectedChip = index;
    });
  }

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedNavigation = index;
    });
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
            ListTile(
              title: const Text('Laporan'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/report');
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _selectedNavigation == 1 ? Order(orderService: orderService) : Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChipCategory(categories: _futureCategory, filterMenu: filterByCategory, selectedChip: selectedChip,),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pesanan'),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: _selectedNavigation,
        onTap: _onNavigationTapped,

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
                future: filteredMenu ?? _futureMenu,
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

                  return const Center(child: CircularProgressIndicator());
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
                  onPressed: () {
                    if(menu.isNotEmpty) {
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertPayment(menu: menu,
                          total: menu.map((value) => value.quantity * value.price).toList().reduce((value, element) => value + element),
                          service: orderService,
                          removeMenu: removeAllOrderItem,
                          discount: menu.map((value) => value.quantity * value.discount).toList().reduce((value, element) => value + element)
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF509D57),
                      fixedSize: const Size(double.infinity, 40),
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
