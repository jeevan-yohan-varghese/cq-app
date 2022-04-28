class ComplaintResponse {
  List<Complaint> complaintList;
  ComplaintResponse({
    required this.complaintList,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    List<Complaint> cList = [];
    json['data'].forEach((v) {
      cList.add(Complaint.fromJson(v));
    });
    return ComplaintResponse(complaintList: cList);
  }
}

class Complaint {
  String complaimt;
  List<String> tags;
  String date;
  String ticketId;

  Complaint({
    required this.complaimt,
    required this.tags,
    required this.date,
    required this.ticketId
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];
    json['tags'].forEach((v) {
      tags.add(v);
    });
    return Complaint(
        complaimt: json['complaint'], date: json['date'], tags: tags,ticketId: json['cid']);
  }
}
