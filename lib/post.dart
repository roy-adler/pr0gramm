import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final String userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;
    map["body"] = body;

    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  String postBody = "POST /api/user/login HTTP/1.1" +
      "Host: pr0gramm.com" +
      "Content-Type: application/x-www-form-urlencoded" +
      "User-Agent: PostmanRuntime/7.15.2" +
      "Accept: */*" +
      "Cache-Control: no-cache" +
      "Postman-Token: 99bf0556-9d35-44d8-9975-931f574000aa,e333966b-f89a-42f7-9206-cb6115e1f88a" +
      "Host: pr0gramm.com" +
      "Cookie: __cfduid=d791c5f2339a971ba3283120eefe85abe1565024459" +
      "Accept-Encoding: gzip, deflate" +
      "Content-Length: 51" +
      "Connection: keep-alive" +
      "cache-control: no-cache" +
      "name=royadler95%40googlemail.com&password=a55ed20e2";
  return http.post(url, body: postBody).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);
  static final CREATE_POST_URL = 'https://jsonplaceholder.typicode.com/posts';
  TextEditingController titleControler = new TextEditingController();
  TextEditingController bodyControler = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "WEB SERVICE",
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Create Post'),
          ),
          body: new Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: titleControler,
                  decoration: InputDecoration(
                      hintText: "title....", labelText: 'Post Title'),
                ),
                new TextField(
                  controller: bodyControler,
                  decoration: InputDecoration(
                      hintText: "body....", labelText: 'Post Body'),
                ),
                new RaisedButton(
                  onPressed: () async {
                    Post newPost = new Post(
                        userId: "123",
                        id: 0,
                        title: titleControler.text,
                        body: bodyControler.text);

                    Post p = await createPost(
                      "https://pr0gramm.com/api/user/login",
                    );
                    print(p.body);
                  },
                  child: const Text("Create"),
                )
              ],
            ),
          )),
    );
  }
}

void main() => runApp(MyApp());
