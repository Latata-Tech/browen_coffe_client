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

  Future<List<Menu>> getMenus({int? categoryId, String? search}) async {
    try {
      String uri = '$API_URL/menus';
      if(categoryId != null && categoryId != 0) uri = "$uri?category=$categoryId";
      print(search?.isEmpty);
      if((search != '' && search != null) && uri.contains("?")) {
        uri = "$uri&search=$search";
      } else if(search != '' && search != null) {
        print("kesini");
        uri = "$uri?search=$search";
      }
      print(uri);
      final response = await http.get(Uri.parse(uri), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      if(response.statusCode == 200) {
        final resBody = jsonDecode(response.body) as Map<String, dynamic>;
        List<Menu> listMenus = [];
        for (var data in (resBody['data'] as List<dynamic>)) {
          listMenus.add(Menu.fromJson(data));
        }
        return listMenus;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}