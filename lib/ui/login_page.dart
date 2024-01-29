import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/constants/icon_constants.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_gallery_ui/widgets/auth_field.dart';
import 'package:flutter_gallery_ui/widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser() async {
    print("press the login button");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 350,
              height: 400,
              decoration: const BoxDecoration(
                color: Color.fromARGB(0, 52, 9, 207),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  // Added row 1 - Text saying hello
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome Back !",
                          style: TextStyle(
                            fontSize: 30,
                            color: PaletteLightMode.darkBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  // Text span
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      text: const TextSpan(
                        text: "Email",
                        style: TextStyle(
                          fontSize: 15,
                          color: PaletteLightMode.darkBlackColor,
                        ),
                      ),
                    ),
                  ),
                  // Username field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AuthField(
                      controller: _emailController,
                      hintText: 'Enter Your Email',
                      fontSize: 14,
                      frontIcon: IconConstants.emailIcon,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Text span
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      text: const TextSpan(
                        text: "Password",
                        style: TextStyle(
                          fontSize: 15,
                          color: PaletteLightMode.darkBlackColor,
                        ),
                      ),
                    ),
                  ),
                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AuthField(
                      controller: _passwordController,
                      inputObcureText: true,
                      hintText: 'Enter Your Password',
                      fontSize: 14,
                      frontIcon: IconConstants.lockIcon,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Added row 2 - Sign In Container
                  Align(
                    alignment: Alignment.center,
                    child: Button(
                      buttonWidth: double.infinity,
                      buttonHeight: 40,
                      onPressed: () {
                        logInUser();
                      },
                      lable: "Sign In",
                      backgroundColor: PaletteLightMode.darkBlackColor,
                      textColor: PaletteLightMode.whiteColor,
                      fontsize: 16,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
