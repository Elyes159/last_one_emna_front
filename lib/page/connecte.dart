import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/page/oublier.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/mdp.dart';
import 'package:untitled2/page/sign.dart';

class CustomAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: ClipRRect(
            child: AppBar(
              backgroundColor: Color.fromARGB(255, 252, 253, 253),
            ),
          ),
        ),
        body: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign-in";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/icons/tdiscount.jpeg',
              height: 50,
              width: 350,
              scale: 0.3,
            ),
          ),
          Center(
            child: SignForm(),
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                height: 2,
                width: 100,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text(
                "Inscrivez-vous avec",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 2,
                width: 100,
                color: Colors.black,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Action pour Facebook
                },
                icon: Icon(Icons.facebook),
                color: const Color.fromARGB(255, 5, 5, 5),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.apple),
                color: const Color.fromARGB(255, 6, 6, 6),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.tiktok),
                color: const Color.fromARGB(255, 6, 6, 6),
                iconSize: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Want to create an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: const Color(0xFF006583),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  static const String _isLoggedInKey = 'isLoggedIn';

  AuthProvider({bool? isLoggedIn}) {
    if (isLoggedIn != null) {
      _isLoggedIn = isLoggedIn;
    }
  }

  bool get isLoggedIn => _isLoggedIn ?? false;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    notifyListeners();
  }

  void setLoggedIn(bool isLoggedIn) async {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  void login() {
    setLoggedIn(true);
  }

  void logout() {
    setLoggedIn(false);
  }
}

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<int?> senddatatoserver() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final resp = await http.post(
        Uri.parse("http://192.168.1.15:3003/user/login"),
        headers: headers,
        body: jsonEncode({
          "email": _emailcontroller.text,
          "password": _passwordcontroller.text
        }),
      );
      if (resp.statusCode == 200) {
        Provider.of<AuthProvider>(context, listen: false).login();
        print('Données envoyées avec succès');
        print("eeeeeee : ${resp.body}");
        print(Provider.of<AuthProvider>(context, listen: false).isLoggedIn);

        final token = jsonDecode(resp.body)['mytoken'] as String;
        saveTokenToSharedPreferences(token);
      } else {
        print('Erreur: ${resp.statusCode}');
      }
      print(resp.statusCode);
      return resp.statusCode;
    } catch (e) {
      print('Erreur: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  buildEmailFormField(_emailcontroller),
                  SizedBox(height: 20),
                  buildPasswordFormField(_passwordcontroller),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: DefaultButton(
                      text: "Continue",
                      color: Color.fromRGBO(254, 214, 1, 1),
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (email!.isEmpty || password!.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content:
                                      Text("Please enter email and password."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            senddatatoserver().then((code) {
                              if (code == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              } else {
                                print('Erreur: $code');
                              }
                            });
                          }
                        }
                      },
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage  ()),
                        );
                      },
                      child: Text("oublier mot de passe"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailFormField(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your email";
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(value)) {
          return "Please enter valid email";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField(TextEditingController controller) {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      controller: controller,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback press;

  const DefaultButton({
    Key? key,
    required this.text,
    this.color,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
