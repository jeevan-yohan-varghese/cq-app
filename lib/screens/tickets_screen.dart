import 'package:cq_app/custom/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QueriesState();
  }
}

class _QueriesState extends State<TicketsScreen> {
  TextEditingController _queryController = TextEditingController();

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
                  padding: const EdgeInsets.only(top: 40,bottom: 40),
                  color: const Color(0xffF6EDD2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Image.asset(
                      "images/tickets_illus.png",
                      width: 180,
                    ),
                    const SizedBox(width: 20,),
                    const Text(
                      "My Queries",
                      style: TextStyle(
                          color: Color(0xff324B73),
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    
                    
                  ]),
                ),
                const SizedBox(
                  height: 24,
                ),
                TicketCard()
                
              ],
            ),
          )),
    );
  }
}
