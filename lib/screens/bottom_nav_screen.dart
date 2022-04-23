
import 'package:cq_app/screens/ask_screen.dart';
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
    AskScreen(),
    AskScreen(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            body: Center(
              child: _fragments[selectedIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 5,
              currentIndex: selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: const Color(0xff6a6a6a),
              backgroundColor: const Color(0xfff3f3f4),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.send), label: "Ask"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.file_copy),
                    label: "Queries"),
                BottomNavigationBarItem(icon: Icon(Icons.question_mark_rounded), label: "FAQ"),
                
              ],
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            )));
  }
}
