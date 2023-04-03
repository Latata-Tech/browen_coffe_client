import 'dart:convert';
import 'dart:async';
import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/menu.dart';
import 'package:http/http.dart' as http;

Future<List<Menu>> getMenus() async {
  try {
    final response = await http.get(Uri.parse('$API_URL/menus'), headers: API_HEADER);
    if(response.statusCode == 200) {
      print(response.body);
      return [];
    }
    return [];
  } catch (e) {
    print(e);
    return [];
  }
}