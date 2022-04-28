class NewComplaintResponse {
  bool success;
  String msg;
  String ticket_id;
  NewComplaintResponse({
    required this.success,
    required this.msg,
    required this.ticket_id,
  });

  factory NewComplaintResponse.fromJson(Map<String,dynamic>map){
    return NewComplaintResponse(success: map['success'], msg: map['msg'], ticket_id: map['ticket_id']);
  }
}
