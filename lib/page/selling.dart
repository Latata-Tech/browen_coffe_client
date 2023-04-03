import 'package:flutter/material.dart';

class Selling extends StatefulWidget {
  const Selling({Key? key}) : super(key: key);

  @override
  State<Selling> createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  List<Widget> data = <Widget>[
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu(),
    CardMenu()
  ];

  List<String> categories = <String>['Semua', 'Coffee', 'Tea'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => print("Profil"), icon: const Icon(Icons.account_circle_rounded))
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
              child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return data[index];
                  }),
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
                        color: index == 0 ? Colors.white : Colors.black
                      ),
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
        margin: EdgeInsets.only(left: 20),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0XFFD9D9D9)
        ),
        child: Column(
          children: [
            const Text('Pesanan'),
            const Divider()
          ],
        ),
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  const CardMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: const [Text('ini gambar'), Text('Ini nama menu')],
        ),
      ),
    );
  }
}