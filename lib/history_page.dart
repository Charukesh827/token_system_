import 'package:flutter/material.dart';
class FavoritePage extends StatefulWidget{
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff000428),Color(0xff004e92)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            ListTile(
              tileColor: Colors.cyan.shade100,
              leading: Text("Non-veg"),
              trailing: Text("00/00/0000"),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              tileColor: Colors.cyan.shade200,
              leading: Text("Veg"),
              trailing: Text("00/00/0000"),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              tileColor: Colors.cyan.shade300,
              leading: Text("Egg"),
              trailing: Text("30"),
            ),
          ],
        ),
      ),
    );
  }
}