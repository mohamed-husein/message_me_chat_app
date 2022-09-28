import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, 
    required this.color,required this.text, this.onPressed,
  });

final Color color;
final String text;
final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed:onPressed,
          minWidth: 200,
          height: 50,
          child:  Text(text,style: const TextStyle(color: Colors.white ,fontSize: 18),),
        ),
      ),
    );
  }
}