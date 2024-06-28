
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_media_app/ui/auth/A09_VerifyCodeForPhone.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:firebase_social_media_app/widgets/A04_RoundButton.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Phone no.'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+91 9292929264',
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 80,),
            RoundButton(
              title: 'login',
              loading: loading,

              onTap: (){
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text.toString(),
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (error){
                    Utils().toastMessage(error.toString());
                  },
                  codeSent: (String verificationId, int? token){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeForPhone(verificationId: verificationId,)));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (error){
                    Utils().toastMessage(error.toString());
                  }
                );
              },

            )
          ],
        ),
      ),
    );
  }
}
