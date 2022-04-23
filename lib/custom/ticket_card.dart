import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffF4F6FA)),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Ticket #1011",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "I have an issue with my credit card.",
              style: TextStyle(fontSize: 16),
            )),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.bookmark,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              "finance, card, credit",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text(
              "12.Apr.2022",
              style: TextStyle(color: Color(0xff8b8b8b)),
            )),
            Align(alignment: Alignment.centerRight, child: Icon(Icons.east))
          ],
        )
      ]),
    );
  }
}
