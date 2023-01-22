import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:firebase_core_web/firebase_core_web.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class ev extends StatefulWidget {
  @override
  State<ev> createState() => _evState();
}

class _evState extends State<ev> {
  bool isemailverify = false;
  bool cansend = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isemailverify = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isemailverify) {
      sendverification();
      timer = Timer.periodic(
        Duration(seconds: 3),
            (_) => checkemailverify(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future checkemailverify() async {
    await FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {
      isemailverify = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  sendverification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => cansend = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => cansend = true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logoo.PNG"),
                        fit: BoxFit.fill)),
                // color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Email Verification',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height: 05,
                            ),
                            Text(
                              'Check your email and click on the link to activate your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton.icon(
                          onPressed: cansend? sendverification():(){},
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              // If the button is pressed, return green, otherwise blue
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.indigo;
                              }
                              return Colors.indigoAccent;
                            }),
                          ),
                          icon: Icon(Icons.email),
                          label: Text(
                            'Resend Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          )),
                    ),
                  ],
                ))));
  }
}
