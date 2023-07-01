import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import '../../api/apis.dart';
import '../../main.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  String _phoneNumber = '';
  String _verificationId = '';
  String _otp = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  Future<void> _sendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval of verification code completed.
          // Sign in the user with the credential.
          await FirebaseAuth.instance.signInWithCredential(credential);
          log('Verification Completed');
        },
        verificationFailed: (FirebaseAuthException exception) {
          // Verification failed.
          log('Verification Failed: ${exception.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verification ID and show the OTP input field.
          setState(() {
            _verificationId = verificationId;
          });
          log('Code Sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout.
          log('Code Auto-Retrieval Timeout');
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log('Failed to Verify Phone Number: $e');
    }
  }

  Future<void> _loginWithOtp() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      log('OTP Login Success');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      log('Failed to Sign In with OTP: $e');
    }
  }

  void _showPhoneNumberPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Phone Number Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                onChanged: (value) {
                  _phoneNumber = "+91$value";
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
                onChanged: (value) {
                  _otp = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: _sendOtp,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Send OTP'),
            ),
            ElevatedButton(
              onPressed: _loginWithOtp,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Cypher'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 0),
            child: Image.asset('images/icon.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: _showPhoneNumberPopup,
              icon: const Icon(Icons.phone,color: Colors.black,),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                      text: 'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
