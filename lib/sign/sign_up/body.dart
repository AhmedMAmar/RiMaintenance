import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rimaintenance/sign/composants/deja_membre.dart';
import 'package:rimaintenance/sign/sign_in/login_page.dart';
import 'package:rimaintenance/sign/sign_up/background.dart';
import 'package:rimaintenance/sign/sign_up/or_devider.dart';
import 'package:rimaintenance/sign/sign_up/socials.dart';
import 'package:rimaintenance/sign/composants/rounded_button.dart';
import 'package:rimaintenance/sign/composants/rounded_input_field.dart';
import 'package:rimaintenance/sign/composants/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

import '../../home.dart';

class Body extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
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
              text: "SIGNUP",
              press: () async {
                await _firebaseAuth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        })));
              },
            ),
            SizedBox(height: size.height * 0.03),
            DejaMembre(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
