import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_workout/Service/google_auth.dart';
import 'package:home_workout/constants/button/buttons.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/utils/utils.dart';
import 'package:home_workout/view/auth_ui/RefCodePage.dart';
import 'package:home_workout/view/auth_ui/log_in_with_number.dart';
import 'package:home_workout/view/auth_ui/sign_in.dart';
import 'package:home_workout/view/steps/step_one.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final repeatpasswordController = TextEditingController();

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
        automaticallyImplyLeading: false,
        title: Text(
          'Create Your Account',
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<Auth_Provider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Input Valid Username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColor.blueColor,
                                )),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColor.blueColor,
                                )),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColor.blueColor,
                                )),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: repeatpasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Repeat Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColor.blueColor,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('have an account?'),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInPage()),
                                );
                              },
                              child: const Text(
                                ' Sign In',
                                style: TextStyle(color: AppColor.blueColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        CustomizeButton(
                          color: AppColor.blueColor,
                          height: 45,
                          width: 200,
                        onPressed: () async {
  print(emailController.text);
  print(passwordController.text);
  print(repeatpasswordController.text);

  if (emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      repeatpasswordController.text.isEmpty) {
    showMessage(context, "All fields are required");
  } else if (passwordController.text !=
      repeatpasswordController.text) {
    showMessage(context, "Passwords do not match");
  } else {
    // Continue with registration logic
    await model.registerUser(
        emailController.text.trim(),
        passwordController.text.trim());

    if (model.state == ViewState.Success) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => RefCodePage()),
          (route) => false);
    } else {
      showMessage(context, model.message);
    }
  }
},

                          text: 'Create Account',
                          textcolor: AppColor.whiteColor,
                          fontfamily: 'Quicksand',
                          fontweightt: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xff2355a7)),
                              minimumSize: Size(240, 45)),
                          onPressed: () async {
                            final userCredential =
                                await AuthService().signInWithGoogle();
                            if (userCredential != null) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => step_one()));
                            }
                          },
                          icon: const ImageIcon(
                            AssetImage(
                              'assets/Google2.png',
                            ), // Replace with your image asset path
                            color:
                                AppColor.blueColor, // Customize the icon color
                            size: 24, // Customize the icon size
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: AppColor.blueColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                // ignore: inference_failure_on_instance_creation
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginWithPhoneNumber(),
                                ),
                              );
                            },
                            icon: const ImageIcon(
                              AssetImage(
                                'assets/Phone1.png',
                              ), // Replace with your image asset path
                              color: AppColor
                                  .blueColor, // Customize the icon color
                              size: 24, // Customize the icon size
                            ),
                            label: const Text(
                              'Continue with phone number',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: AppColor.blueColor,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColor.blueColor,
                              ),
                              minimumSize: const Size(250, 47),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      _auth
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return step_one();
            },
          ),
        );
      }).onError((error, stackTrace) {
        Utils.toastMessage(error.toString());
      });
    }
  }
}
