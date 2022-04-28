import 'dart:convert';

import 'package:cq_app/data/helpers/new_complaint_response.dart';
import 'package:cq_app/screens/login_screen.dart';
import 'package:cq_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
class AskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AskState();
  }
}

class _AskState extends State<AskScreen> {
  var _isLoggedIn = false;
  TextEditingController _queryController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  String listenText = "";
  String jwt="";

  @override
  void initState() {
    super.initState();
    _initSpeech();
    SharedPreferences.getInstance().then((value) => {
          setState(() {
            _isLoggedIn = value.getBool("isLoggedIn") ?? false;
            if(_isLoggedIn){
              jwt=value.getString("jwtToken")??"";
            }
            debugPrint("##############################${_isLoggedIn}");
          })
        });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    try {
      await _speechToText.listen(onResult: (result) {
        _onSpeechResult(result);
        setState(() {
          listenText = "";
        });
      });
      setState(() {
        listenText = "Listening ...";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Microphone permission required")));
    }
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
  var heart = Emoji('heart', '❤️');
  

  

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: !_isLoggedIn?LoginScreen(): SingleChildScrollView(
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
                const SizedBox(
                  height: 16,
                ),
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        listenText,
                        style: TextStyle(color: Color(0xff8B8B8B)),
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: _queryController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffEFF3FF),
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            newComplaint(_queryController.text, jwt).then((res) => {
                              if(res.success){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ticket created")))
                              }
                            });
                          },
                          icon: Icon(Icons.send),
                        ),
                        hintText: "Your query here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.transparent))),
                  ),
                ),
              ],
            ),
          )),
    );
  }


  Future<NewComplaintResponse> newComplaint(String query,String jwt) async {
    //debugPrint("*********************Google ID token : $token ");
    final response = await http.post(
        Uri.parse('$BASE_URL/api/newComplaint?apiKey=$API_KEY'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":"Bearer $jwt"
        },
        body: jsonEncode(<String, String>{'query': query}));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //debugPrint(response.body);
      debugPrint(response.body);
      return NewComplaintResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      debugPrint("**************************************Error 404");
      throw Exception("Not found");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(response.body);
      throw Exception('Failed to fetch');
    }
  }
}

