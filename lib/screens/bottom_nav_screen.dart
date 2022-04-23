import 'package:cq_app/screens/ask_screen.dart';
import 'package:cq_app/screens/tickets_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNavScreen> {
  int selectedIndex = 0;
  final List<Widget> _fragments = <Widget>[
    AskScreen(),
    TicketsScreen(),
    AskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: _fragments[selectedIndex],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff677AF3).withOpacity(0.09),
                      spreadRadius: 5,
                      blurRadius: 25,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BottomNavigationBar(
                    elevation: 0,
                    currentIndex: selectedIndex,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: const Color(0xff6a6a6a),
                    backgroundColor: Color(0xffffffff),
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.send), label: "Ask"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.file_copy), label: "Tickets"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.question_mark_rounded),
                          label: "FAQ"),
                    ],
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            )));
  }
}
