import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:list_all_videos/list_all_videos.dart';
import 'package:list_all_videos/model/video_model.dart';
import 'package:list_all_videos/thumbnail/ThumbnailTile.dart';

class VideoListScreen extends StatefulWidget {
  static const routeName = '/video_list_screen';

  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        centerTitle: true,
        title: InkWell(
          onTap: () {},
          child: Text(
            "Cou Cou!",
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Inika",
              fontSize: 24,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ListAllVideos().getAllVideosPath(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3.w,
                    crossAxisSpacing: 3.w,
                  ),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.w),
                  itemBuilder: (BuildContext context, int index) {
                    VideoDetails currentVideo = snapshot.data![index];

                    return InkWell(
                      onTap: () async {
                        debugPrint(
                            "currentVideo.videoPath: ${currentVideo.videoPath}");

                        File videoFile = File(currentVideo.videoPath);

                        debugPrint("videoPath: ${videoFile.path}");

                        await currentVideo.thumbnailController.initThumbnail();

                        debugPrint(
                            "thumbnail paht: ${currentVideo.thumbnailController.thumbnailPath}");

                        File thumbnailFile = File(
                            currentVideo.thumbnailController.thumbnailPath);

                        final bytes = await thumbnailFile.readAsBytes();

                        debugPrint("bytes: $bytes");

                        postController.selectVideo2(context, videoFile,
                            currentVideo.thumbnailController.thumbnailPath);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ThumbnailTile(
                          thumbnailController: currentVideo.thumbnailController,
                          // height: 80,
                          // width: 100,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
