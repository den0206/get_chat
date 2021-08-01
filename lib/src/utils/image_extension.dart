import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageExtension {
  static Future<File?> selectImage() async {
    List<Asset> results = <Asset>[];

    File? selectedFile;
    try {
      results = await MultiImagePicker.pickImages(
        maxImages: 1,
        selectedAssets: results,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      selectedFile = await compressFile(results.first);
    } catch (e) {
      print(e);
      showError(e);
    }

    return selectedFile;
  }

  static Future<File?> compressFile(Asset asset) async {
    final file = await getImageFileFromAssets(asset);

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
    );

    return result;
  }

  static Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }
}
