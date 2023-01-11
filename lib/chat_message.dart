import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender)
            .text
            .white
            .subtitle1(context)
            .bold
            .make()
            .box
            .color(sender == "user" ? Vx.green600 : Vx.red600)
            .p16
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(child: text.trim().text.white.subtitle1(context).make().px8())
      ],
    ).py8();
  }
}
