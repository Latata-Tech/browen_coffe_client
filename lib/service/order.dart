import 'dart:convert';

import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/order_menu.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
class OrderService {
  LocalStorage storage;

  OrderService(this.storage);

  Future<List<String>> createOrder(List<OrderMenu> order, int discount, int pay, String paymentType) async {
    try {
      final response = await http.post(Uri.parse("$API_URL/orders"), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      }, body: jsonEncode(<String, dynamic>{
        'discount': discount,
        'pay': pay,
        'payment_type': paymentType,
        'menus': order.map((value) => {'id': value.id, 'qty': value.quantity, 'variant': value.variant}).toList()
      }));
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      return [resBody['status'], resBody['message']];
    } catch (e) {
      return ["failed", "Terjadi kesalahan pada aplikasi."];
    }
  }
}