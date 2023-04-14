import 'package:browenz_coffee/page/staff_selling.dart';
import 'package:browenz_coffee/service/auth.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../model/user.dart';

class Report extends StatefulWidget {
  final LocalStorage storage;
  const Report({Key? key, required this.storage}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late final AuthService service;
  late final OrderService serviceOrder;

  @override
  void initState() {
    service = AuthService(widget.storage);
    serviceOrder = OrderService(widget.storage);
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
        future: service.getUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              if(snapshot.data!.roleId == 2) {
                return StaffSelling(orderService: serviceOrder);
              } else {
                return Center(child: Text('Owner'),);
              }
            } else if(snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
