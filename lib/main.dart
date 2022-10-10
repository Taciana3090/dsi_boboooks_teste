import 'package:dsi_bobooks/views/mybooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dsi_bobooks/views/login_screen.dart';
import 'package:dsi_bobooks/views/register.dart';
import 'package:dsi_bobooks/views/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

User user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  user = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Bobooks',
      debugShowCheckedModeBanner: false,
      initialRoute: ((user == null || !user.emailVerified)
          ? LoginScreen.id
          : HomeScreen.id),
      // initialRoute: BookPage.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        Register.id: (context) => Register(),
        HomeScreen.id: (context) => HomeScreen(),
        MyBooks.id: (context) => MyBooks(),
      },
    );
  }
}
