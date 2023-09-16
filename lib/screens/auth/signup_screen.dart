import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/HColor.dart' as c;
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final AuthService authService = AuthService();
  bool _passwordVisible = true;

  void signup() {
    authService.signUp(
        context: context,
        firstName: firstNameController.text,
        username: usernameController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberController.text,
        level: "masyarakat",
        nik: nikController.text);
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
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back, color: c.black,)),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
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
                        'Nama',
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
                          hintText: 'Farhan Zaidan',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                        controller: usernameController,
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
                        'Nomor HP',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '081234567890',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'NIK',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: nikController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '123456',
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
                                color: c.primary,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_signupKey.currentState!.validate()) {
                            if (usernameController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                firstNameController.text.isEmpty ||
                                phoneNumberController.text.isEmpty ||
                                nikController.text.isEmpty) {
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
