import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/bloc/on_click_bloc.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final String hintText;
  final Widget? icon;
  final VoidCallback? onTap;
  const CommonTextField(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      this.onTap,
      this.icon,
      required this.textInputType,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return BlocProvider(
      create: (context) => OnClickBloc(),
      child: BlocBuilder<OnClickBloc, OnClickInitial>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                boxShadow: [BoxShadow(color: Colors.white12)]),
            child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8.0),
              suffixIcon:isPass==true? GestureDetector(onTap: (){
                BlocProvider.of<OnClickBloc>(context).add(OnClickDataEvent(state.onClick==true?false:true));
              },child:state.onClick==false? Icon(Icons.visibility):
              Icon(Icons.visibility_off)):null,
            ),
            keyboardType: textInputType,
            obscureText: isPass==false?false:state.onClick,
            
                ),
          );
        },
      ),
    );
  }
}
