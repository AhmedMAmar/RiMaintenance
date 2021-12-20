import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rimaintenance/home.dart';
import 'package:rimaintenance/sign/sign_in/background.dart';
import 'package:rimaintenance/sign/sign_up/signup_page.dart';
import 'package:rimaintenance/sign/composants/deja_membre.dart';
import 'package:rimaintenance/sign/composants/rounded_button.dart';
import 'package:rimaintenance/sign/composants/rounded_input_field.dart';
import 'package:rimaintenance/sign/composants/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                await _firebaseAuth
                    .signInWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        })));
              },
            ),
            SizedBox(height: size.height * 0.03),
            DejaMembre(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
