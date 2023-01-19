import 'package:chat_gbt/main.dart';
import 'package:chat_gbt/modal.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget(
      {super.key, required this.chatMessageType, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: chatMessageType == ChatMessageType.bot
            ? resultAreacolor
            : backgroundcolor,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          chatMessageType == ChatMessageType.bot
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, top: 33, bottom: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Image.asset("asset/4712109.png"),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25, right: 10),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
