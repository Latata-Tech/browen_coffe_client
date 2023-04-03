import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:browenz_coffee/config/constant/api.dart';
import 'package:browenz_coffee/service/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';


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

}