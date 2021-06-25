import 'package:flutter/material.dart';
import 'Home/MyHomePage.dart';
import 'Users/MyUsersPage.dart';


void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.yellow),
      routes: {
        "/": (context) => MyHomePage(),
        "/users": (context) => MyUsersPage(),
      },
      initialRoute: "/users",
    );
  }
}
