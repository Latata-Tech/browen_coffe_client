import 'dart:convert';
import 'dart:async';
import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/menu.dart';
import 'package:browenz_coffee/service/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class MenuService {
  LocalStorage storage;

  MenuService(this.storage);

  Future<List<Menu>> getMenus() async {
    try {
      print(storage.getItem('accessToken'));
      final response = await http.get(Uri.parse('$API_URL/menus'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      print(response.body);
      if(response.statusCode == 200) {
        final resBody = jsonDecode(response.body) as Map<String, dynamic>;
        print(resBody);
        return (resBody['data'] as List<Map<String, dynamic>>)
            .map((data) => Menu.fromMap(data))
            .toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}