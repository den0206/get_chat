import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    Key? key,
    required this.chatRooId,
  }) : super(key: key);
  static const routeName = '/Message';
  final String chatRooId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: Center(
          child: Text(chatRooId),
        ));
  }
}
