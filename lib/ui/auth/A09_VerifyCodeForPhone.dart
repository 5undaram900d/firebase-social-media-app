

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_media_app/ui/posts/A07_PostScreen.dart';
import 'package:flutter/material.dart';

import '../../utils/A06_Utils.dart';
import '../../widgets/A04_RoundButton.dart';

class VerifyCodeForPhone extends StatefulWidget {

  final String verificationId;

  const VerifyCodeForPhone({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeForPhone> createState() => _VerifyCodeForPhoneState();
}

class _VerifyCodeForPhoneState extends State<VerifyCodeForPhone> {
  bool loading = false;
  final verifyPhoneOTPController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify code'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            TextFormField(
              controller: verifyPhoneOTPController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
            const SizedBox(height: 80,),
            RoundButton(
              title: 'Verify',
              loading: loading,

              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verifyPhoneOTPController.text.toString()
                );
                try{
                  await auth.signInWithCredential(credential);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PostScreen()));
                }catch(error){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                }
              },

            )
          ],
        ),
      ),
    );
  }
}
