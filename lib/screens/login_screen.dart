import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/textfield_input.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    String res = await AuthMethod().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      // showSnackBar(context, 'Success');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout());
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(flex: 2, child: Container()),
        SvgPicture.asset(
          'assets/ic_instagram.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 64,
        ),
        const SizedBox(
          height: 64,
        ),
        CommonTextField(
          textEditingController: _emailController,
          textInputType: TextInputType.emailAddress,
          hintText: 'Enter your email',
        ),
        const SizedBox(height: 24.0),
        CommonTextField(
          textEditingController: _passwordController,
          textInputType: TextInputType.text,
          hintText: 'Enter your password',
          isPass: true,
        ),
        const SizedBox(height: 24.0),
        GestureDetector(
          onTap: () {
            loginUser();
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
            child: const Text('Log In'),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Flexible(
          flex: 2,
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text('Don\'t have an account?')),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SignupScreen();
                  },
                ));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            )
          ],
        )
      ]),
    )));
  }
}
