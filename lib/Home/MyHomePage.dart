import 'package:flutter/material.dart';
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(),
      body: Center(
        child: Text("Home",style: Theme.of(context).textTheme.headline1,),
      ),
    );
  }
}
