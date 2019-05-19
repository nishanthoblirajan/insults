import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insults/insults.dart';
import 'dart:convert' as convert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insults',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = 'Click Refresh';
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Insults'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        var url = 'https://evilinsult.com/generate_insult.php?lang=en&type=json';
        var response = await http.get(url);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if(response.statusCode==200){
          var jsonResponse = convert.jsonDecode(response.body);
          String insult =    jsonResponse['insult'];
          setState(() {
            text=insult;
          });
        }

      },
      child: Icon(Icons.refresh),),
      body: Text(text),
    );
  }
}

