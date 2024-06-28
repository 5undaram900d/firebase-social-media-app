
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_media_app/ui/auth/A05_SignupScreen.dart';
import 'package:firebase_social_media_app/ui/auth/A08_LoginWithPhoneNumber.dart';
import 'package:firebase_social_media_app/ui/auth/A12_ForgotPassword.dart';
import 'package:firebase_social_media_app/ui/posts/A07_PostScreen.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:firebase_social_media_app/widgets/A04_RoundButton.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();          /// generate a global_key
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;      /// for gating firebase Authentication instance

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();          /// after work completed dispose controller
    passwordController.dispose();       /// after work completed dispose controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Form(
                key: _formKey,          /// for single form key
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

                      validator: (value){         /// validator use for check textField is empty or not
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

                      validator: (value){         /// validator use for check textField is empty or not
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
                title: 'Login',
                loading: loading,
                onTap: (){
                  if(_formKey.currentState!.validate()){        /// if formKey validate with textField value
                    login();              /// then move to login method
                  }
                },
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                }, child: const Text('Forgot Password?')),
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                  }, child: const Text('Sign up'))
                ],
              ),

              const SizedBox(height: 20,),

              InkWell(        /// use for onTap function
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber()));
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: const Center(
                    child: Text('Login with phone'),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

}
