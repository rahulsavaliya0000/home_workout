import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_workout/constants/button/buttons.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/utils/utils.dart';
import 'package:home_workout/view/auth_ui/create_account.dart';
import 'package:home_workout/view/home_screen/home_screen.dart';
import 'package:home_workout/view/home_screen/home_two.dart';
import 'package:home_workout/view/steps/step_one.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void login() {
    _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((value) {
      Utils.toastMessage(value.user!.email.toString());
      Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation
        MaterialPageRoute(builder: (context) => step_one()),
      );
    }).onError((e, stackTrace) {
      debugPrint(e.toString());
      Utils.toastMessage(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Sign In',
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:  Consumer<Auth_Provider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.blueColor,
                          )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.blueColor,
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage()));
                        },
                        child: const Text('Create Account',
                            style: TextStyle(color: AppColor.blueColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomizeButton(
                    color: AppColor.blueColor,
                    height: 45,
                    width: 200,
                    onPressed:() async {
                                    print(_emailController.text);
                                    print(_passwordController.text);
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      showMessage(
                                          context, "All field are required");
                                    } else {
                                      await model.loginUser(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim());

                                      if (model.state == ViewState.Success) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                     Home_screen()),
                                            (route) => false);
                                      } else {
                                        showMessage(context, model.message);
                                      }
                                    }
                                    //Validate User Inputs
                                  },
                    text: 'Sign In',
                    textcolor: AppColor.whiteColor,
                    fontfamily: 'Quicksand',
                    fontweightt: FontWeight.w500,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
