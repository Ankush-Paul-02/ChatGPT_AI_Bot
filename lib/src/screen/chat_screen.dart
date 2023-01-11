import 'dart:async';
import 'package:ai_chat_bot/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import '../../three-dots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGpt;
  bool _isTyping = false;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    chatGpt = ChatGPT.instance;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user");
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    _controller.clear();

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);
    _streamSubscription = chatGpt!
        .builder("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",
            orgId: "")
        .onCompleteStream(request: request)
        .listen((event) {
      Vx.log(event!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: event!.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _controller,
          onSubmitted: (value) => _sendMessage(),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration.collapsed(
            hintText: "Send a message",
            hintStyle: TextStyle(color: Colors.white),
          ),
        )),
        IconButton(
            onPressed: () => _sendMessage(),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ))
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff101d25),
        appBar: AppBar(
          backgroundColor: const Color(0xff232d36),
          title: const Center(
              child: Text(
            "CHAT GPT BOT",
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  }),
            ),
            if (_isTyping) const ThreeDots(),
            const Divider(
              height: 1,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff090e12),
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}
