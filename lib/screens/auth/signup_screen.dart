import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/HColor.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/my_snackbar.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
    bool _passwordVisible = true;

  void signup() {
    authService.signUp(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        firstName: firstNameController.text,
        lastName: "masyarakat");
  }

  @override
  Widget build(BuildContext context) {
    var mediaW = MediaQuery.of(context).size.width;
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 90, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.adobe_rounded, size: mediaW / 5)),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _signupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'farhanzaidann',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'farhan@gmail.com',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Password',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '********',
                          hintStyle: GoogleFonts.poppins(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primary,
                              ),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_signupKey.currentState!.validate()) {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                firstNameController.text.isEmpty) {
                              showSnackBar(context, 'Form harus diisi');
                            } else if (passwordController.text.length < 6) {
                              showSnackBar(
                                  context, 'Password harus lebih dari 6');
                            } else {
                              Future.delayed(const Duration(seconds: 1));
                              signup();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            }
                          }
                        },
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Login!',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
