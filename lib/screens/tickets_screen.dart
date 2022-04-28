import 'dart:convert';

import 'package:cq_app/custom/ticket_card.dart';
import 'package:cq_app/data/models/complaint_model.dart';
import 'package:cq_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

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
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  color: const Color(0xffF6EDD2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/tickets_illus.png",
                          width: 180,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
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
                FutureBuilder<ComplaintResponse>(
                  builder: (context, snapshot) {
                    
                
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.complaintList.length,
                        itemBuilder: (context, index) {
                          Complaint comp = snapshot.data!.complaintList[index];
                          
                          debugPrint(comp.tags.toString());
                          return TicketCard(complaint: comp.complaimt,tags: comp.tags,ticketId: comp.ticketId,date: comp.date);
                        },
                      );
                    }
                
                    return Container();
                  },
                  future: getTickets(),
                ),
                //TicketCard()
              ],
            ),
          )),
    );
  }

  Future<ComplaintResponse> getTickets() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String _jwt = sh.getString("jwtToken") ?? "";

    //debugPrint("*********************Google ID token : $token ");
    final response = await http
        .get(Uri.parse('$BASE_URL/api/getTickets?apiKey=$API_KEY'), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_jwt"
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //debugPrint(response.body);
      debugPrint(response.body);
      return ComplaintResponse.fromJson(jsonDecode(response.body));
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
