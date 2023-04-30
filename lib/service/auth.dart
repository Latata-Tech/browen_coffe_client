import 'dart:async';
import 'dart:convert';
import 'package:browenz_coffee/config/constant/api.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../model/user.dart';


class AuthService {
  LocalStorage storage;

  AuthService(this.storage);

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$API_URL/auth'), headers: API_HEADER, body: { "email": email, "password" : password });
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      if(response.statusCode == 200 && resBody['code'] == 200) {
        storage.setItem('accessToken', resBody['data']['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User> getUser() async {
    try {
      final response = await http.get(Uri.parse('$API_URL/user'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${storage.getItem('accessToken')}'
      });
      if(response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw Exception('err');
    } catch (e) {
      return User(0, "", "", 0);
    }
  }

}