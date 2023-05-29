import 'package:browenz_coffee/page/owner_selling.dart';
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
          PopupMenuButton(
            icon: const Icon(Icons.account_circle_rounded),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        service.logout().then((value) {
                          Navigator.popAndPushNamed(context, '/login');
                        });
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
        future: service.getUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              if(snapshot.data!.roleId == 2) {
                return StaffSelling(orderService: serviceOrder);
              } else {
                return OwnerSelling(orderService: serviceOrder,);
              }
            } else if(snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
