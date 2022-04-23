import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AskState();
  }
}

class _AskState extends State<AskScreen> {
  TextEditingController _queryController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  String listenText = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: (result) {
      _onSpeechResult(result);
      setState(() {
        listenText = "";
      });
    });
    setState(() {
      listenText = "Listening...";
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _queryController.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
                  children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80),
              color: const Color(0xff9ECDFF),
              child: Column(children: [
                const Text(
                  "Ask your query",
                  style: TextStyle(
                      color: Color(0xff324B73),
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "images/male_illus.png",
                  width: 200,
                )
              ]),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text("How can we help?",
                style: TextStyle(
                    color: Color(0xff324B73),
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 12),
              child:  Text("Let us know your query. You can either speak or just type down",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff8b8b8b),
                      
                      fontSize: 16)),
            ),
            InkWell(
              onTap: () {
                _speechToText.isNotListening
                    ? _startListening()
                    : _stopListening();
              },
              child: const CircleAvatar(
                radius: 80,
                backgroundColor: const Color(0xffEAEEFF),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color(0xffCCD6FF),
                  child: Center(
                      child: Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 36,
                  )),
                ),
              ),
            ),
            Text(listenText),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _queryController,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                    fillColor: const Color(0xffEFF3FF),
                    filled: true,
                    label: Text("Query"), border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: const Text("SUBMIT"))
                  ],
                ),
          )),
    );
  }
}
