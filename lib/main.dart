import 'package:flutter/material.dart';
import 'package:perpusapimobile/auth/login_screen.dart';
import 'package:perpusapimobile/auth/register_screen.dart';
import 'package:perpusapimobile/book/book_list_page.dart';
import 'package:perpusapimobile/navbar/bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              return BottomNavBar();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
