import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insults/insults.dart';
import 'dart:convert' as convert;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share/share.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
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

enum TtsState { playing, stopped }

class _MyHomePageState extends State<MyHomePage> {
  String insultText = 'Click Refresh';
  String insultNumber = '#';
  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  String language;
  String voice;
  Future _speak() async {
    if (insultText != null) {
      if (insultText.isNotEmpty) {
        var result = await flutterTts.speak(insultText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  @override
  void initState() {

    initTts();
    super.initState();
  }
  initTts() {
    flutterTts = FlutterTts();

    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        _getLanguages();
        _getVoices();
      });
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }
  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getVoices() async {
    voices = await flutterTts.getVoices;
    if (voices != null) setState(() => voices);
  }
  
  _share(){
    Share.share(insultText);
    
  }
  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Insults'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var url =
              'https://evilinsult.com/generate_insult.php?lang=en&type=json';
          var response = await http.get(url);
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          if (response.statusCode == 200) {
            var jsonResponse = convert.jsonDecode(response.body);
            String insult = jsonResponse['insult'];
            String number = jsonResponse['number'];
            insult = insult.replaceAll("&quot;","'");
            setState(() {
              insultText = insult;
              insultNumber = '#$number';
            });
          }
        },
        child: Icon(Icons.refresh),
      ),
      body: Center(
          child: Card(
              child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text(insultText),
            subtitle: Text(insultNumber),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Speak It Out'),
                  onPressed: () {
                    _speak();
                  },
                ),
                FlatButton(
                  child: const Text('Copy'),
                  onPressed: () {
                    ClipboardManager.copyToClipBoard(insultText).then((result) {
                      final snackBar = SnackBar(
                        content: Text('Copied to Clipboard'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {},
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  },
                ),
                FlatButton(
                  child: const Text('Share'),
                  onPressed: () {
                    _share();
                  },
                ),
              ],
            ),
          ),
        ],
      ))),
    );
  }
}
