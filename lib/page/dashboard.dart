import 'package:browenz_coffee/service/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import '../model/dashboard.dart' as model_dashboard;

class Dashboard extends StatefulWidget {
  final LocalStorage storage;
  const Dashboard({Key? key, required this.storage}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final DashboardService service;
  late final Future<model_dashboard.Dashboard> dashboardData;
  @override
  void initState() {
    service = DashboardService(storage: widget.storage);
    dashboardData = service.getDashboard();
    super.initState();
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
      body: FutureBuilder(
        future: dashboardData,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if(snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Penjualan Hari Ini'),
                  Text(
                    NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(snapshot.data!.earning),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 5,
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
                            children: [
                              const Text("Jumlah Penjualan Hari Ini",
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                child: Text(
                                  snapshot.data!.totalOrder.toString(),
                                  style: const TextStyle(
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
                            children: [
                              const Text("Jumlah Pesanan selesai",
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                child: Text(
                                  snapshot.data!.orderDone.toString(),
                                  style: const TextStyle(
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
                            children: [
                              const Text(
                                "Jumlah Pesanan Belum Selesai",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                child: Text(
                                  snapshot.data!.orderProcess.toString(),
                                  style: const TextStyle(
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
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}
