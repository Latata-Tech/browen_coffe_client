import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Image(image: AssetImage('assets/images/logo.png'))),
              const SizedBox(height: 60,),
              const Text('Email'),
              const SizedBox(height: 20,),
              TextFormField(
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
              const SizedBox(height: 20,),
              const Text('Password'),
              const SizedBox(height: 20,),
              TextFormField(
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
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () {
                    print("di klik");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff196CD2),
                    fixedSize: Size(
                        MediaQuery.of(context).size.width.toDouble(), 83
                    )
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
