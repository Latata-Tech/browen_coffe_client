import 'package:browenz_coffee/page/dashboard.dart';
import 'package:browenz_coffee/service/auth.dart';
import 'package:browenz_coffee/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  final LocalStorage storage;
  const Login({Key? key, required this.storage}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late final AuthService authService;
  @override
  void initState() {
    super.initState();
    authService = AuthService(widget.storage);
  }
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image(image: const AssetImage('assets/images/logo.png'), height: MediaQuery.of(context).size.height / 5,)),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                const Text('Email'),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'Masukan email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Masukan alamat email yang valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                const Text('Password'),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                      hintText: 'Masukan password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  obscureText: true,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Masukan alamat email yang valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                ElevatedButton(
                    onPressed: () {
                      authService.signIn(email.text, password.text).then((value) {
                        if(value) Navigator.popAndPushNamed(context, '/dashboard');
                        else {
                          final snackBar = alert("Email atau Password yang dimasukan salah!", Colors.redAccent);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff196CD2),
                      fixedSize: Size(
                          MediaQuery.of(context).size.width.toDouble(), MediaQuery.of(context).size.height / 10
                      )
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
