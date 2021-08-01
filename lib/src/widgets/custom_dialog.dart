import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showError(error) {
  return showDialog(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: error.message != null
            ? Text("${error.message} Error")
            : Text("UnknownError"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
