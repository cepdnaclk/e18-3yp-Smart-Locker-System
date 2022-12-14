import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:slocker/Screens/loading.dart';
import 'package:slocker/Screens/pass_reset.dart';
import 'package:slocker/Screens/signup_screen.dart';
import 'package:slocker/Screens/verifyemail.dart';
import 'package:slocker/net/auth.dart';
import 'package:slocker/reusable.dart';

import '../constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  AuthClass auth = AuthClass();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      home: Form(
        key: _key,
        child: Scaffold(
          //key: formKey,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "User Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 4.h,
                        color: mSecondTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Image.asset("assets/images/lockericon.png",
                        fit: BoxFit.fitWidth,
                        width: 35.h,
                        height: 35.h,
                        color: Color(0xFF6892c9)
                        //color: mSecondTextColor,
                        ),
                    SizedBox(
                      height: 2.h,
                    ),
                    reusableTextField(
                        "Enter the e-mail",
                        Icons.person_sharp,
                        false,
                        _emailTextController,
                        validateEmail,
                        "email-field"),
                    SizedBox(
                      height: 2.h,
                    ),
                    reusableTextField(
                        "Enter the password",
                        Icons.lock_sharp,
                        true,
                        _passwordTextController,
                        validatePasswordSignIn,
                        "password-field"),
                    firebaseUIButton(context, "SIGN IN", () async {
                      if (_key.currentState!.validate()) {
                        try {
                          auth
                              .storetokenanddata(await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text,
                          ))
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: 'SIGNED IN',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: mSecondColor,
                                textColor: Colors.black);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => verifyemail()));
                          });
                          errorMessage = '';
                        } on FirebaseAuthException catch (error) {
                          errorMessage = error.message!;
                          Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: mSecondColor,
                              textColor: Colors.black);
                        }
                        setState(() {});
                      }
                    }),
                    signUpOption(),
                    SizedBox(
                      height: 1.h,
                    ),
                    SignUpOption2()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => passwordReset()));
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(
                color: mPrimaryTextColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Row SignUpOption2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account ",
            style: TextStyle(color: mPrimaryTextColor)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            "SIGN UP",
            style: TextStyle(
                color: mPrimaryTextColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';

  return null;
}

String? validatePasswordSignIn(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }

  return null;
}
