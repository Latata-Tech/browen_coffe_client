import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Penjualan Hari Ini'),
            const Text(
              '1,000,000.00',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33),
                        color: const Color(0XFFD1E3F8)),
                    height: 217,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Jumlah Penjualan Hari Ini",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "10",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 60),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33),
                        color: const Color(0XFFD9D9D9)),
                    height: 217,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Jumlah Pesanan selesai",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "8",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 60),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33),
                        color: const Color(0XFFDAEEDC),
                    ),
                    height: 217,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Jumlah Pesanan Belum Selesai",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "2",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 60),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
