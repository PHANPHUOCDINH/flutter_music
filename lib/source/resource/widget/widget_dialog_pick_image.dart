import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../source.dart';

class WidgetDialogPickImage extends StatelessWidget {
  changeImage(bool fromGallery, BuildContext context) async {
    final image = await ImagePicker().getImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 70,
      maxWidth: 720,
    );

    if (image != null) Navigator.pop(context, File(image.path));
  }

  goToAlbum(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.transparent,
            width: double.maxFinite,
            height: double.maxFinite,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: AppSize.screenWidth - 40,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Chọn ảnh",
                      style: AppStyles.DEFAULT_LARGE,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeImage(false, context),
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera,
                                    color: Colors.blue[300],
                                    size: 99,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Camera",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.DEFAULT_MEDIUM,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeImage(true, context),
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.library_books_sharp,
                                    color: Colors.blue[300],
                                    size: 99,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Thư viện",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.DEFAULT_MEDIUM,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
