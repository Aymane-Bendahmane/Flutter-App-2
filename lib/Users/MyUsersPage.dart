import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyUsersPage extends StatefulWidget {
  @override
  _MyUsersPageState createState() => _MyUsersPageState();
}

class _MyUsersPageState extends State<MyUsersPage> {
  dynamic data;
  TextEditingController queryTextEditingController =
  new TextEditingController();
  String query;
  bool notvisiblity = true;
  int currentPage=0;
  int totalPages=0;
  int pageSize=20;
  ScrollController scrollController = new ScrollController();

  void _search(String query) {
    String url =
        "https://api.github.com/search/users?q=${query}&per_page=${pageSize}&page=${currentPage}";
    http.get(Uri.parse(url)).then((response) {
      setState(() {
        this.data = json.decode(response.body);
        if(data['total_count'] % pageSize == 0 ){
          totalPages = data['total_count'] / pageSize;
        }else{
          totalPages = data['total_count'] ~/ pageSize;
          totalPages = totalPages.floor() +1 ;
        }
      });
    }).catchError((onError) => print(onError));
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent ){
        setState(() {
          if(currentPage < totalPages -1)
          ++currentPage;
          _search(query);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building .....................");

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Users : $query => $currentPage / $totalPages"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: this.notvisiblity,
                      onChanged: (value) {
                        setState(() {
                          this.query = value;
                        });
                      },
                      controller: queryTextEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(notvisiblity == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                notvisiblity = !notvisiblity;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.yellow),
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.yellow,
                    onPressed: () {
                      setState(() {
                        query = queryTextEditingController.text;
                        _search(query);
                      });
                    })
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                  itemCount: (data == null) ? 0 : data['items'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    data['items'][index]['avatar_url']),
                                radius: 40,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("${data['items'][index]['login']}"),
                              CircleAvatar(
                                child: Text("${data['items'][index]['score']}"),
                              ),
                            ],
                          ),
                        ]));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
