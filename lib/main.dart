// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_auth/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserAuthApp(),
    );
  }
}

class UserAuthApp extends StatefulWidget {
  const UserAuthApp({Key? key}) : super(key: key);

  @override
  State<UserAuthApp> createState() => _UserAuthAppState();
}

class _UserAuthAppState extends State<UserAuthApp> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _errorStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ana Sayfa"),
        ),
        body: SizedBox(
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.1,
                  child: TextFormField(
                    controller: _emailController,
                    onChanged: (value) => _emailController.text,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      fillColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.1,
                  child: TextFormField(
                    onChanged: (value) => _passwordController.text,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      fillColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        _userCreate(
                            _emailController.text, _passwordController.text);
                      },
                      child: const Text("Kayıt Ol")),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.pink),
                      onPressed: () {
                        _userLogin(_emailController.text,
                            _passwordController.text, context);
                      },
                      child: const Text("Giriş Yap")),
                ),
                _errorStatus != false
                    ? Center(
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.1,
                          child: const Text(
                            "Email veya Parola Hatalı!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }

  _userCreate(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Future.delayed(const Duration(seconds: 3));
  }

  _userLogin(String email, String password, BuildContext context) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.user!.emailVerified != true) {
        _auth.currentUser!.sendEmailVerification();
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false);
      }
    } catch (e) {
      setState(() {
        _errorStatus = true;
      });
      debugPrint(e.toString());
    }
  }
}
