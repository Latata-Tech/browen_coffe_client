import 'dart:convert';

import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/model/category.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  LocalStorage storage;

  CategoryService(this.storage);

  Future<List<Category>> getCategories() async {
    try {
      print('dipanggil');
      final response = await http.get(Uri.parse("$API_URL/categories"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      var resBody = jsonDecode(response.body);
      var result = (resBody['data'] as List<dynamic>).map((value) => Category.fromJson(value)).toList();
      result.sort((a,b) => a.id.compareTo(b.id));
      print(result);
      return result;
    } catch (e) {
      return <Category>[];
    }
  }
}