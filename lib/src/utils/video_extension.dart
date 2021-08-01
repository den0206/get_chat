import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class VideoExtension {
  static Future<File?> getGarallyVideo() async {
    final videox = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (videox == null) {
      return null;
    }

    // final File videoFile = File(videox.path);

    final compressVideo = await VideoCompress.compressVideo(
      videox.path,
      quality: VideoQuality.LowQuality,
    );

    if (compressVideo == null) {
      print("Can't Compress");
      return null;
    }

    return compressVideo.file;
  }

  static Future<File?> getThumbnail(File videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
    );

    if (thumbnail == null) {
      return null;
    }

    //// Uint8List To File
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(thumbnail);

    return file;
  }
}
