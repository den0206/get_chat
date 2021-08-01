import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.titleColor = Colors.white,
    this.width = 250,
    this.height = 60,
    this.isLoading = false,
    this.background = Colors.blue,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final Color background;
  final double width;
  final double height;
  final bool isLoading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: background,
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: !isLoading ? onPressed : null,
        child: !isLoading
            ? Text(
                title,
                style: TextStyle(color: titleColor),
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    Key? key,
    required this.imageProvider,
    required this.onTap,
    this.width = 120,
    this.height = 120,
  }) : super(key: key);

  final ImageProvider<Object> imageProvider;

  final Function() onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink.image(
          image: imageProvider,
          fit: BoxFit.fill,
          width: 120.0,
          height: 120.0,
          child: InkWell(
            onTap: onTap,
          ),
        ));
  }
}
