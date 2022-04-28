import 'dart:convert';

import 'package:cq_app/data/helpers/login_response.dart';
import 'package:cq_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ElevatedButton(
        child: const Text(
          "Login",
        ),
        onPressed: () {
          checkAlreadySignedIn();
        },
      )),
    );
  }

  void checkAlreadySignedIn() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool _isLoggedIn = sharedPreferences.getBool("isLoggedIn") ?? false;
      //String _idToken = sharedPreferences.getString("idToken") ?? "";
      if (_isLoggedIn) {
        //debugPrint("saved token: ");
        //debugPrint(_idToken);
        signInAsync(await FirebaseAuth.instance.currentUser!.getIdToken());
      } else {
        googleSignIn();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void googleSignIn() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn _googleSignIn = GoogleSignIn();
      // Trigger the authentication flow
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

// Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseCredential = await auth.signInWithCredential(credential);
      String idToken = await firebaseCredential.user!.getIdToken(true);
      // Once signed in, return the UserCredential

      String recreatedToken = "";
      while (idToken.length > 0) {
        int initLength = (idToken.length >= 500 ? 500 : idToken.length);
        //print(idToken.substring(0, initLength));
        int endLength = idToken.length;
        recreatedToken += idToken.substring(0, initLength);
        idToken = idToken.substring(initLength, endLength);
      }
      signInAsync(recreatedToken);
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error occurred")));
    }
  }

  void signInAsync(String recreatedToken) async {
    print("Firebase id token: ");
    print(recreatedToken);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      LoginResponse loginResponse =
          await loginAsync(recreatedToken);
      sharedPreferences.setBool("isLoggedIn", true);
      sharedPreferences.setString("idToken", recreatedToken);
      sharedPreferences.setString("jwtToken", loginResponse.jwt);
    } catch (e) {
      debugPrint(e.toString());
      sharedPreferences.setBool("isLoggedIn", false);
      //sharedPreferences.setString("idToken", "");
      sharedPreferences.setString("jwtToken", "");
      if (e.toString() == "Exception: Not registered") {
        GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
      } else {
        GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
      }
    }
  }

  Future<LoginResponse> loginAsync(String token) async {
    //debugPrint("*********************Google ID token : $token ");
    final response = await http.post(
        Uri.parse('$BASE_URL/auth/login?apiKey=$API_KEY'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, String>{'authtoken': token}));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //debugPrint(response.body);
      debugPrint(response.body);
      return LoginResponse.fromJson(jsonDecode(response.body));
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


