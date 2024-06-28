
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_media_app/ui/auth/A03_LoginScreen.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:firebase_social_media_app/widgets/A04_RoundButton.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SignUp')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        helperText: 'Enter email e.g abc@gmail.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20,),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                )
            ),

            const SizedBox(height: 30,),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  signUp();
                }
              },
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value) {
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}

