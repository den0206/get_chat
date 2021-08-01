import 'package:flutter/material.dart';

class MessageFileSheet extends StatelessWidget {
  const MessageFileSheet({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<MessageFileButton> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15.0,
            color: Colors.grey,
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 21.0,
        crossAxisSpacing: 21.0,
        crossAxisCount: 3,
        children: actions,
      ),
    );
  }
}

class MessageFileButton extends StatelessWidget {
  const MessageFileButton({
    Key? key,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  final IconData icon;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey[200],
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.green,
        ),
        onPressed: onPress,
      ),
    );
  }
}
