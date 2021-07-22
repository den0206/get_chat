import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/simple_builder.dart';

class ImagesCroisel extends StatelessWidget {
  const ImagesCroisel({
    Key? key,
    required this.images,
    this.heightImage = 150,
  }) : super(key: key);

  final List<String> images;
  final double heightImage;

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<int?>(
      initialValue: 0,
      builder: (current, updater) {
        return Column(
          children: [
            Container(
              height: heightImage,
              child: PageView(
                physics: BouncingScrollPhysics(),
                onPageChanged: updater,
                children: images.map(
                  (url) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(url), fit: BoxFit.scaleDown),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            if (images.length > 1)
              Container(
                height: 30,
                margin: EdgeInsets.only(top: 12, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.map((image) {
                    bool isActive = images.indexOf(image) == current;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      height: 8,
                      width: isActive ? 20 : 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : Colors.grey[400],
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}
