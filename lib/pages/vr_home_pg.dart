import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:sop/api/speech_api.dart';
import 'package:sop/main.dart';
import 'package:sop/widgets/substring_highlight.dart';
import 'package:sop/utils.dart';

class HomePage extends StatefulWidget {
  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = 'Press the button and start speaking';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    //startAutoReload();
  }
  Widget build(BuildContext context) =>
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:Alignment.bottomRight,
                colors: [Color.fromRGBO(178, 254, 250, 1), Color.fromRGBO(14, 210, 247, 1)]
            )
        ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 119, 68, 1),
        title: Text("Voice Commands"),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(text);
                var snackbar = SnackBar(content: Text('✓   Copied to Clipboard'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(30).copyWith(bottom: 150),
        child: SubstringHighlight(
          text: text,
          terms: Command.all,
          textStyle: TextStyle(
            fontSize: 32.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textStyleHighlight: TextStyle(
            fontSize: 32.0,
            color: Colors.red,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: const Color.fromRGBO(117, 127, 154, 1),
        child: FloatingActionButton(
          onPressed: toggleRecording,
          backgroundColor: const Color.fromRGBO(44, 119, 68, 1),
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
        ),
      ),
    ),
  );

  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() => this.isListening = isListening);
      if (!isListening) {
        Future.delayed(Duration(seconds: 1), () {
          Utils.scanText(text);
        });
      }

    },
  );
}