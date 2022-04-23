import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
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
      listenText = "Listening ...";
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      listenText = "";
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _queryController.text = _lastWords;
    });
  }

  var parser = EmojiParser();
var coffee = Emoji('coffee', '☕');
var heart  = Emoji('heart', '❤️');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
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
                      height: 40,
                    ),
                    Image.asset(
                      "images/male_illus.png",
                      width: 250,
                    )
                  ]),
                ),
                const SizedBox(
                  height: 24,
                ),
                 Text("How can we help?${parser.get(':wave:').code}",
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  child: Text(
                      "Let us know your query. You can either speak or just type down",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff8b8b8b), fontSize: 16)),
                ),
                const SizedBox(height: 16,),
                InkWell(
                  onTap: () {
                    _speechToText.isNotListening
                        ? _startListening()
                        : _stopListening();
                  },
                  child: CircleAvatar(
                    radius: _speechToText.isListening ? 80 : 70,
                    backgroundColor: const Color(0xffEAEEFF),
                    child: const CircleAvatar(
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
                
                Visibility(
                  visible: _speechToText.isListening,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: Text(listenText,style: TextStyle(color: Color(0xff8B8B8B)),),
                  )),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0,top:20.0),
                  child: TextFormField(
                    controller: _queryController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffEFF3FF),
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.send),
                        ),
                        hintText: "Your query here...",
                        border: InputBorder.none),
                  ),
                ),
                
              ],
            ),
          )),
    );
  }
}
