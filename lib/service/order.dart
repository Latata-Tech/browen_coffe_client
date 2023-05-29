import 'dart:convert';
import 'dart:io';

import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/order.dart';
import 'package:browenz_coffee/model/order_detail.dart';
import 'package:browenz_coffee/model/order_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class OrderService {
  LocalStorage storage;

  OrderService(this.storage);

  Future<List<String>> createOrder(
      List<OrderMenu> order, int discount, int pay, String paymentType) async {
    try {
      final response = await http.post(Uri.parse("$API_URL/orders"),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${storage.getItem('accessToken')}'
          },
          body: jsonEncode(<String, dynamic>{
            'discount': discount,
            'pay': pay,
            'payment_type': paymentType,
            'menus': order
                .map((value) => {
                      'id': value.id,
                      'qty': value.quantity,
                      'variant': value.variant
                    })
                .toList()
          }));
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      return [resBody['status'], resBody['message']];
    } catch (e) {
      print(e);
      return ["failed", "Terjadi kesalahan pada aplikasi."];
    }
  }

  Future<List<Order>> getOrder() async {
    try {
      final response =
          await http.get(Uri.parse("$API_URL/orders/not-process"), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as List<dynamic>);
      final List<Order> result = data.map((value) {
        List<OrderDetail> detail = (value['detail'] as List<dynamic>)
            .map((value) => OrderDetail.fromJson(value))
            .toList();
        return Order.fromJson(value, detail);
      }).toList();
      print(result);
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> orderDone(String id) async {
    try {
      final response = await http.put(Uri.parse('$API_URL/orders/$id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${storage.getItem('accessToken')}'
          },
          body: jsonEncode({'status': 'done'}));
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      return [resBody['status'], resBody['message']];
    } catch (e) {
      print(e);
      return ['failed', 'Terjadi kesalahan pada aplikasi'];
    }
  }

  Future<List<Order>> getOrderToday() async {
    try {
      final response = await http.get(Uri.parse('$API_URL/orders'), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as List<dynamic>);
      final List<Order> result = data.map((value) {
        List<OrderDetail> detail = (value['detail'] as List<dynamic>)
            .map((value) => OrderDetail.fromJson(value))
            .toList();
        return Order.fromJson(value, detail);
      }).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Order>> getOrders(String? date) async {
    try {
      final response =
          await http.get(Uri.parse('$API_URL/orders?date=$date'), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as List<dynamic>);
      final List<Order> result = data.map((value) {
        List<OrderDetail> detail = (value['detail'] as List<dynamic>)
            .map((value) => OrderDetail.fromJson(value))
            .toList();
        return Order.fromJson(value, detail);
      }).toList();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> getTotalOrderToday() async {
    try {
      final response =
          await http.get(Uri.parse('$API_URL/orders/total-today'), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as Map<String, dynamic>);
      return data['total'];
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> getTotalOrders(String? date) async {
    try {
      final response = await http
          .get(Uri.parse('$API_URL/orders/total?date=$date'), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as Map<String, dynamic>);
      return data['total'];
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<String> downloadInvoice(String code) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String myurl = '$API_URL/orders/${code}';
    String filePath = '';
    try {
      final request =
          await httpClient.getUrl(Uri.parse(myurl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '/storage/emulated/0/Download/invoice-${code}.pdf';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ${response.statusCode}';
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
      print(ex);
    }
    return filePath;
  }
}
