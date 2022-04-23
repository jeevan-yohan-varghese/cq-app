import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FaqState();
  }
}

class _FaqState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 60),
            color: const Color(0xffB7C0F6),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                "images/plane_illus.png",
                width: 150,
              ),
              const SizedBox(
                width: 60,
              ),
              const Text(
                "FAQ",
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
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xffF4F6FA)),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text("How to increase my credit score?"),
                      children: [Text("Test test test test test")],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
