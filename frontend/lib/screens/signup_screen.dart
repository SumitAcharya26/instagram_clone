import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/textfield_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  bool isPass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userNameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout());
        },
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
          ),
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            height: 64,
          ),
          const SizedBox(
            height: 50,
          ),
          Stack(children: [
            _image != null
                ? CircleAvatar(
                    radius: 64.0,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64.0,
                    backgroundImage: NetworkImage(
                      'https://icon-library.com/images/default-user-icon/default-user-icon-8.jpg',
                    ),
                  ),
            Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: const Icon(Icons.add_a_photo)))
          ]),
          const SizedBox(height: 24.0),
          CommonTextField(
            textEditingController: _userNameController,
            textInputType: TextInputType.text,
            hintText: 'Enter your username',
          ),
          const SizedBox(height: 24.0),
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
            icon: const Icon(Icons.visibility),
          ),
          const SizedBox(height: 24),
          CommonTextField(
            textEditingController: _bioController,
            textInputType: TextInputType.text,
            hintText: 'Enter your bio',
          ),
          const SizedBox(height: 24.0),
          GestureDetector(
            onTap: () {
              if (_passwordController.text.length < 6) {
                showSnackBar(context, 'Password must be more than 6 character');
              }
              signUpUser();
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)))),
              child: _isLoading == false
                  ? const Text('Sign up')
                  : const CircularProgressIndicator(color: primaryColor),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('Already have an account?')),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              )
            ],
          )
        ]),
      ),
    ));
  }
}
