import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

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
        Stack(children: [
          _image != null
              ? CircleAvatar(
                  radius: 64.0,
                  backgroundImage: MemoryImage(_image!),
                )
              : const CircleAvatar(
                  radius: 64.0,
                  backgroundImage: NetworkImage(
                    'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
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
          isPass: true,
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
        ),
        const SizedBox(height: 24),
        CommonTextField(
          textEditingController: _bioController,
          textInputType: TextInputType.text,
          hintText: 'Enter your bio',
          isPass: true,
        ),
        const SizedBox(height: 24.0),
        GestureDetector(
          onTap: () {
            AuthMethod().signupUser(
              email: _emailController.text,
              password: _passwordController.text,
              username: _userNameController.text,
              bio: _bioController.text,
              file: _image!,
            );
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
            child: const Text('Sign up'),
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
    )));
  }
}
