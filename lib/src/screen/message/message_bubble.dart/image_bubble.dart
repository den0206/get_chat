import 'package:flutter/material.dart';

import 'package:getx_chat/src/model/message.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Image.network(
        message.imageUrl!,
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            margin: EdgeInsets.only(bottom: 10, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            width: 200.0,
            height: 200.0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                value: loadingProgress.expectedTotalBytes != null &&
                        loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) {
          return ErrorImageWidget();
        },
      ),
    );
  }
}

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Image.asset(
        'assets/images/logo.png',
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }
}
