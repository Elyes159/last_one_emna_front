import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/connecte.dart';
import 'package:untitled2/page/home.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Assurez-vous que Flutter est initialisé
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic('nouveauProduit');
  // Initialisez Firebase

  // Initialisez SharedPreferences
  await SharedPreferences.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print(token);

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OneSignal.initialize("3f648ad4-8faa-4241-bc3b-b57ab550e279");
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(isLoggedIn: isLoggedIn),
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isLoggedIn ? Home() : SignInScreen();
          },
        ),
      ),
    );
  }
}
