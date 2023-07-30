import 'dart:convert';
import 'dart:io';

import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/order.dart';
import 'package:browenz_coffee/model/order_detail.dart';
import 'package:browenz_coffee/model/order_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OrderService {
  LocalStorage storage;

  OrderService(this.storage);

  Future<List<String>> updateOrder(
      List<OrderDetail> order, int pay, String code) async {
    try {
      final response = await http.put(Uri.parse("$API_URL/orders/$code/update"),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${storage.getItem('accessToken')}'
          },
          body: jsonEncode(<String, dynamic>{
            'pay': pay,
            'order_detail': order
                .map((value) => {
              'id': value.id,
              'qty': value.qty,
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

  Future<Order?> getOrderDetail(String code) async {
    try {
      final response = await http
          .get(Uri.parse('$API_URL/orders/$code/detail'), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (resBody['data'] as Map<String, dynamic>);
      print(data);
      List<OrderDetail> detail = (data['detail'] as List<dynamic>).map((value) => OrderDetail.fromJson(value)).toList();
      return Order.fromJson(data, detail);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> downloadInvoice(String code) async {
    String? message;
    try {
      // Download image
      final http.Response response =
          await http.get(Uri.parse('$API_URL/orders/$code'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/invoice-$code.pdf';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }
    return message;
  }
}
