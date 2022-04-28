class LoginResponse {
  // String userName;
  // String userEmail;
  // String photoUrl;
  String jwt;
  LoginResponse({
    // required this.userName,
    // required this.userEmail,
    // required this.photoUrl,
    required this.jwt,
  });

  factory LoginResponse.fromJson(Map<String,dynamic>map){
    return LoginResponse(jwt: map['authToken']);
  }
}
