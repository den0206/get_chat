import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_chat/src/screen/message/message_bubble.dart/image_bubble.dart';
import 'package:video_player/video_player.dart';

import 'package:getx_chat/src/model/message.dart';

class VideoBubbleController extends GetxController {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  final String videoUrl;
  final RxBool isPlayng = false.obs;

  bool get loaded {
    return videoPlayerController.value.isInitialized;
  }

  VideoBubbleController(
    this.videoUrl,
  );

  @override
  void onInit() async {
    super.onInit();

    videoPlayerController = VideoPlayerController.network(videoUrl);

    await videoPlayerController.initialize();

    await videoPlayerController.setVolume(0.3);
    await videoPlayerController.setLooping(false);
    await videoPlayerController.pause();

    videoPlayerController.addListener(
      () {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          if (!chewieController.isFullScreen) isPlayng.value = false;
          update();
        }
      },
    );

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      aspectRatio: videoPlayerController.value.size.aspectRatio,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
      ],
      placeholder: Container(
        color: Colors.black87,
        child: Container(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )),
        ),
      ),
    );
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.onClose();
  }

  void playVideo() async {
    if (!videoPlayerController.value.isInitialized) {
      return;
    }

    chewieController.togglePause();
    isPlayng.value = !isPlayng.value;

    update();
  }
}

class VideoBubble extends StatelessWidget {
  const VideoBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoBubbleController>(
      init: VideoBubbleController(message.videoUrl!),
      global: false,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.playVideo();
          },
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 250,
                maxWidth: 300,
              ),
              // width: 300,
              // height: 200,
              child: !controller.isPlayng.value

                  /// thumbnail
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          message.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return ErrorImageWidget();
                          },
                        ),
                        Icon(
                          Icons.play_circle_fill,
                          color: Colors.black,
                          size: 80,
                        )
                      ],
                    )
                  : Chewie(
                      controller: controller.chewieController,
                    ),
            ),
          ),
        );
      },
    );
  }
}
