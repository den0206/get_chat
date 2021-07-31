import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetX<NetworkManager>(
      builder: (manager) {
        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            FadeInOutWidget(
              visible:
                  manager.status.value == InternetConnectionStatus.disconnected,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Text(
                      "No Internet",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class FadeinWidget extends StatefulWidget {
  FadeinWidget({
    Key? key,
    required this.child,
    this.duration,
  }) : super(key: key);

  final Widget child;
  final Duration? duration;

  @override
  _FadeinWidgetState createState() => _FadeinWidgetState();
}

class _FadeinWidgetState extends State<FadeinWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration == null
          ? Duration(milliseconds: 1000)
          : widget.duration,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();

    animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }
}

class FadeInOutWidget extends StatefulWidget {
  FadeInOutWidget({
    Key? key,
    required this.child,
    required this.visible,
  }) : super(key: key);

  final Widget child;
  final bool visible;

  @override
  _FadeInOutWidgetState createState() => _FadeInOutWidgetState();
}

class _FadeInOutWidgetState extends State<FadeInOutWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0,
      duration: Duration(milliseconds: 500),
      child: widget.visible ? widget.child : Container(),
    );
  }
}
