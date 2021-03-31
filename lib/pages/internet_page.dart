import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternetPage extends StatelessWidget {
  String url = 'https://randomuser.me/api/';

  Future<List<User>> testInternet() async {
    String encoded = Uri.encodeFull(url);
    Uri uri = Uri.https('jsonplaceholder.typicode.com', 'users');
    print("uri fertig");
    var response = await http.get(uri, headers: {"Accept": "application/json"});

    var json = jsonDecode(response.body);
    List<User> users = [];
    for (var u in json) {
      User user = User(u['name'], u['email'], u['username']);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: testInternet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      users[index].name,
                      style: TextStyle(color: Colors.white),
                    ),
                    leading:  Text(
                      users[index].email,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              itemExtent:120,
            );
          } else {
            return Container(
              child: Text(
                "NothingToSee",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        });
  }
}

class User {
  final String name, email, userName;
  User(this.name, this.email, this.userName);
}
