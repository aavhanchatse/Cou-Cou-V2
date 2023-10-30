import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CropImagePage extends StatefulWidget {
  static const routeName = '/cropImage';

  final Uint8List imageBytes;
  const CropImagePage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final _controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        leading: IconButton(
          onPressed: () {
            // Get.back();
            context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
        title: const Text(
          'Crop Image',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => _controller.crop(),
            tooltip: 'Crop',
            icon: const Icon(Icons.done, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8),
              child: Crop(
                  image: widget.imageBytes,
                  controller: _controller,
                  aspectRatio: 1,
                  onCropped: (cropped) async {
                    ProgressDialog.showProgressDialog(context);
                    // final image = await bytesToImage(cropped);
                    Navigator.of(context).pop();

                    Navigator.of(context).pop(cropped);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}
