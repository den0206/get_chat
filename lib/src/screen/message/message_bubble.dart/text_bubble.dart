import 'package:flutter/material.dart';
import 'package:getx_chat/src/model/message.dart';

class TextBubble extends StatelessWidget {
  const TextBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        color: message.isCurrent ? Colors.green : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(message.isCurrent ? 12 : 0),
          bottomRight: Radius.circular(message.isCurrent ? 0 : 12),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          color: message.isCurrent ? Colors.white : Colors.grey[800],
        ),
      ),
    );
  }
}
