import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  String ticketId;
  String complaint;
  String date;
  List<String> tags;
  TicketCard(
      {Key? key,
      required this.ticketId,
      required this.complaint,
      required this.date,
      required this.tags})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Color(0xffF4F6FA)),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Ticket #$ticketId",
              style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey),
            )),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              complaint,
              style: TextStyle(fontSize: 16),
            )),
        const SizedBox(
          height: 12,
        ),
        tags.isNotEmpty?Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.bookmark,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              tags[0],
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            )
          ],
        ):Container(),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text(
              date,
              style: const TextStyle(color: Color(0xff8b8b8b)),
            )),
            const Align(alignment: Alignment.centerRight, child: Icon(Icons.east))
          ],
        )
      ]),
    );
  }
}
