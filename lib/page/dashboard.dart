import 'package:browenz_coffee/service/auth.dart';
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
  late final AuthService authService;
  late final Future<model_dashboard.Dashboard> dashboardData;
  @override
  void initState() {
    service = DashboardService(storage: widget.storage);
    dashboardData = service.getDashboard();
    authService = AuthService(widget.storage);
    super.initState();
  }

  void logout(ctx) {
    dashboardData.then((value) {
      if(value.orderProcess <= 0) {
        authService.logout().then((value) {
          Navigator.popAndPushNamed(context, '/login');
        });
        return;
      }
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
          content: Text(
            '${value.orderProcess} Pesanan belum selesai di proses.\n Mohon periksa kembali'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent)),
                child: const Text('Tutup', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.account_circle_rounded),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        Future.delayed(
                            const Duration(seconds: 0),
                                () => logout(context)
                        );
                      },
                      child: const Text('Logout')
                  )
                ];
              }
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0XFF303030),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.white,),
                title: const Text('Dashboard', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/dashboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.point_of_sale, color: Colors.white,),
                title: const Text('Penjualan', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/selling');
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.white,),
                title: const Text('Laporan', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/report');
                },
              ),
            ],
          ),
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
                        .height / 15,
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
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Jumlah Penjualan Hari Ini",
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 16,
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
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Jumlah Pesanan selesai",
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 16,
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
                          height: MediaQuery.of(context).size.height / 2.5,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jumlah Pesanan Belum Selesai",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 16,
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
