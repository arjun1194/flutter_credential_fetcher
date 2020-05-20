import 'package:demo_webview/credential_fetcher.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
        home: MyHome()));




class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CredentialFetcher(
        url: "https://www.instagram.com/accounts/login/",
        callback: (s) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyClass(text: s,),),);
        },
        loader: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class MyClass extends StatelessWidget {
  final String text;

  const MyClass({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text),);
  }
}







