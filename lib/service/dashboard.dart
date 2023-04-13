import 'dart:convert';

import 'package:browenz_coffee/config/constant/api.dart';
import 'package:localstorage/localstorage.dart';

import '../model/dashboard.dart';
import 'package:http/http.dart' as http;
class DashboardService {
  LocalStorage storage;
  DashboardService({required this.storage});

  Future<Dashboard> getDashboard() async {
    try {
      final request = await http.get(Uri.parse("$API_URL/dashboard"), headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      if(request.statusCode == 200) {
        print((jsonDecode(request.body) as Map<String, dynamic>)['data']);
        return Dashboard.fromJson((jsonDecode(request.body) as Map<String, dynamic>)['data']);
      }

      throw Exception(request.body);
    } catch (e) {
      print(e);
      return Dashboard(earning: 0, totalOrder: 0, orderDone: 0, orderProcess: 0);
    }
  }
}