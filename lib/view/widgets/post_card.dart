import 'dart:io';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/image_download_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/comment/comment_screen.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/widgets/dismissible_page.dart';
import 'package:coucou_v2/view/widgets/heart_animation_widget.dart';
import 'package:coucou_v2/view/widgets/in_view_video_player_cou_cou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as image;
import 'package:palette_generator/palette_generator.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatefulWidget {
  final PostData postData;
  final bool isInView;

  const PostCard({super.key, required this.postData, this.isInView = false});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  PostData? item;

  int currentIndex = 0;

  bool isHeartAnimating = false;

  double? height = 69.5.h;
  // final _key = GlobalKey();

  final userController = Get.find<UserController>();

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    item = widget.postData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return item == null ? const SizedBox() : _cardWithBgImage();
    return item == null ? const SizedBox() : _card();

    // SizedBox(
    //     height: height,
    //     child: Stack(
    //       children: [
    //         Image.network(
    //           item!.thumbnail ?? "",
    //           fit: BoxFit.cover,
    //           color: Colors.grey.withOpacity(0.3),
    //           colorBlendMode: BlendMode.modulate,
    //           height: height,
    //           width: double.infinity,
    //         ),
    //         _card(),
    //       ],
    //     ),
    //   );
    // });
  }

  Widget _cardWithBgImage() {
    return Stack(
      children: [
        _card(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: _bgImage(),
        ),
        _card(),
      ],
    );
  }

  Widget _bgImage() {
    return ImageUtil.networkImage(
      imageUrl: item!.thumbnail ?? "",
      errorImage:
          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimgmedia.lbb.in%2Fmedia%2F2019%2F08%2F5d662c8ea84656a7661be92a_1566977166741.jpg&f=1&nofb=1&ipt=bbdaaabe584a623a962b0719a4673ac026c44c17a1420e9ec647368d409170fa&ipo=images",
      fit: BoxFit.cover,
      color: Colors.grey.withOpacity(0.3),
      colorBlendMode: BlendMode.modulate,
    );

    // return Image.network(
    //   item!.thumbnail ??
    //       "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimgmedia.lbb.in%2Fmedia%2F2019%2F08%2F5d662c8ea84656a7661be92a_1566977166741.jpg&f=1&nofb=1&ipt=bbdaaabe584a623a962b0719a4673ac026c44c17a1420e9ec647368d409170fa&ipo=images",
    //   fit: BoxFit.cover,
    //   color: Colors.grey.withOpacity(0.3),
    //   colorBlendMode: BlendMode.modulate,
    // );
  }

  Widget _cardWithDominantBg() {
    return FutureBuilder(
      future: _updatePaletteGenerator(),
      builder: (context, snapshot) {
        Color bgColor = Constants.white;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            bgColor = Constants.white;
            break;
          default:
            if (snapshot.hasError) {
              bgColor = Constants.white;
            } else {
              bgColor = snapshot.data!.dominantColor!.color;
            }
        }

        return Container(
          color: bgColor,
          child: _card(),
        );
      },
    );
  }

  Widget _card() {
    return Container(
      color: Constants.postCardBackground,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        // key: _key,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _headerWidget(context),
          ),
          SizedBox(height: 2.w),
          _contentImage(),
          SizedBox(height: 2.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _buttons(context),
          ),
          SizedBox(height: 2.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _descriptionWidget(),
          ),
        ],
      ),
    );
  }

  Widget _descriptionWidget() {
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Text(
    //         item?.caption ?? "",
    //         style: TextStyle(
    //           color: Constants.black,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  context.push(
                    ChallengeDetailsScreen.routeName,
                    extra: {"id": item!.challengeData!.id},
                  );
                },
                child: Text(
                  "#${item!.challengeData!.challengeName}",
                  style: TextStyle(
                    color: Constants.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ReadMoreText(
                item?.caption ?? "",
                trimLines: 2,
                // trimLength: 25,
                colorClickableText: Colors.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'more'.tr,
                trimExpandedText: 'less'.tr,
                lessStyle: TextStyle(
                  color: Constants.primaryGrey,
                  fontSize: 10,
                ),
                moreStyle: TextStyle(
                  color: Constants.primaryGrey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if (userController.userData.value.username != null &&
                  userController.userData.value.username!.isNotEmpty) {
                likePost();
              } else {
                context.push(CompleteDetailsScreen.routeName);
              }
              // likePost();
            },
            child: Row(
              children: [
                HeartAnimationWidget(
                  isAnimating: item!.like!,
                  child: Image.asset(
                    item?.like == true
                        ? "assets/icons/cookie_selected.png"
                        : "assets/icons/cookie_unselected.png",
                    height: 6.w,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  item?.likeCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              if (userController.userData.value.username != null &&
                  userController.userData.value.username!.isNotEmpty) {
                await analytics.logEvent(name: "comment_button_clicked");

                // context.push(CommentScreen.routeName, extra: item);
                final PostData? data =
                    await context.push(CommentScreen.routeName, extra: item);

                if (data != null) {
                  item = data;
                  setState(() {});
                }
              } else {
                context.push(CompleteDetailsScreen.routeName);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/comment.png",
                  height: 6.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  item?.commentCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              if (userController.userData.value.username != null &&
                  userController.userData.value.username!.isNotEmpty) {
                await analytics.logEvent(name: "share_post");

                String imageUrl = item!.imagesMultiple != null &&
                        item!.imagesMultiple!.isNotEmpty
                    ? item!.imagesMultiple![currentIndex]
                    : item!.challengeVideo ?? "";

                shareImageWithText(imageUrl ?? "", item?.deepLinkUrl ?? "");
              } else {
                context.push(CompleteDetailsScreen.routeName);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/icons/share.png",
                  height: 6.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  "share".tr,
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void likePost() async {
    // if (item.like == true) {
    //   item.likeCount = item.likeCount! + 1;
    // } else {
    //   if (item.likeCount != 0) {
    //     item.likeCount = item.likeCount! - 1;
    //   }
    // }

    // setState(() {});

    final userController = Get.find<UserController>();

    var payLoad = {
      "postOwnerId": item?.userSingleData!.id!,
      "postId": item?.id,
      "userId": userController.userData.value.id
    };

    PostRepo().addPostLike(payLoad).then((value) async {
      await analytics.logEvent(name: "like_clicked");

      item = value.data;
      setState(() {});

      // if (item.like == true) {
      //   item.likeCount = item.likeCount! + 1;
      // } else {
      //   if (item.likeCount != 0) {
      //     item.likeCount = item.likeCount! - 1;
      //   }
      // }

      // item.like = isLiked;
      // await analytics.logEvent(name: "like_post_button");
      // consoleLog(tag: "addPostLike", message: value.message!);
    });
  }

  bool findIfVideo() {
    if (item!.challengeVideo == null) {
      if (item!.isVideo == true) {
        return true;
      } else {
        return false;
      }
    }

    if (item!.challengeVideo!.endsWith(".mp4")) {
      return true;
    } else {
      return false;
    }
  }

  Widget _contentImage() {
    // debugPrint("item?.challengeVideo: ${item?.challengeVideo}");
    return GestureDetector(
      onDoubleTap: () {
        if (userController.userData.value.username != null &&
            userController.userData.value.username!.isNotEmpty) {
          isHeartAnimating = true;
          setState(() {});

          likePost();
        } else {
          context.push(CompleteDetailsScreen.routeName);
        }
      },
      child: Container(
        constraints: BoxConstraints(
          // maxWidth: double.infinity,

          maxHeight: 50.h,
        ),
        color: Constants.postCardBackground,
        // height: 50.h,
        child: findIfVideo()
            ? InViewVideoPlayerCouCou(
                data: item!.challengeVideo == null
                    ? item!.videoUrl ?? ""
                    : item!.challengeVideo ?? "",
                postDataList: item!,
                // isViewChanged: true,
                isViewChanged: widget.isInView,
              )
            : ClipRRect(
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(8),
                //   bottomRight: Radius.circular(8),
                // ),
                child: Stack(
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: _multipleImage(),
                      // child: _singleImage(item?.challengeVideo ?? ""),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          final imageList = item!.imagesMultiple != null &&
                                  item!.imagesMultiple!.isNotEmpty
                              ? item!.imagesMultiple
                              : [item!.challengeVideo];

                          context.push(
                            DismissPage.routeName,
                            extra: {
                              "initialIndex": currentIndex,
                              "imageList": imageList,
                              "isVideo": false
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.zoom_out_map_outlined,
                            color: Constants.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: isHeartAnimating ? 1 : 0,
                        child: HeartAnimationWidget(
                          isAnimating: isHeartAnimating,
                          duration: const Duration(milliseconds: 700),
                          onEnd: () {
                            isHeartAnimating = false;
                            setState(() {});
                          },
                          // child: Icon(
                          //   Icons.favorite,
                          //   color: Constants.white,
                          //   size: 100,),
                          child: Container(
                            padding: EdgeInsets.all(30.w),
                            height: 10.w,
                            width: 10.w,
                            child: Image.asset(
                              "assets/icons/cookie_selected.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Image.network(
                //   item?.challengeVideo ?? "",
                // ),
              ),
      ),
    );
  }

  Widget _multipleImage() {
    return CarouselSlider.builder(
      itemCount: item!.imagesMultiple == null || item!.imagesMultiple!.isEmpty
          ? 1
          : item!.imagesMultiple!.length,
      itemBuilder: (context, index, realIndex) {
        final element =
            item!.imagesMultiple != null && item!.imagesMultiple!.isNotEmpty
                ? item!.imagesMultiple![index]
                : item!.challengeVideo ?? "";

        return _singleImage(element);
      },
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        viewportFraction: 1.0,
        disableCenter: true,
        initialPage: 0,
        autoPlay: false,
        enableInfiniteScroll: false,
        height: 50.h,
        onPageChanged: (index, reason) {
          currentIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Widget _singleImage(String image) {
    return ImageUtil.networkImage(
      imageUrl: image,
      // height: 50.h,
      width: double.infinity,
      // fit: BoxFit.fitWidth,
    );
  }

  Widget _headerWidget(BuildContext context) {
    return InkWell(
      onTap: () async {
        await analytics.logEvent(name: "profile_image_clicked");

        context.push(UserProfileScreen.routeName,
            extra: item?.userSingleData?.id);
      },
      child: Row(
        children: [
          DefaultPicProvider.getCircularUserProfilePic(
            profilePic: item?.userSingleData!.imageUrl,
            userName:
                "${item?.userSingleData!.firstname} ${item?.userSingleData!.lastname}",
            size: 50,
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item?.userSingleData!.username ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                item?.postLocation ?? "",
                style: TextStyle(
                  color: Constants.black,
                  fontSize: 12,
                ),
              ),
              Text(
                DateUtil.timeAgo2(item!.createdAt!),
                // DateUtil.timeAgo(item!.createdAt!),
                style: TextStyle(
                  color: Constants.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          findIfVideo()
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    // ImageDownloadUtil.downloadImageToGallery(
                    //   context,
                    //   item!.challengeVideo!,
                    //   item!.id!,
                    // );
                    _getCanvasAsImage();
                  },
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: Constants.black,
                  ),
                ),
        ],
      ),
    );
  }

  Future<ui.Image> _getCanvasAsImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image renderedImage = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);

    ByteData? byteData =
        await renderedImage.toByteData(format: ui.ImageByteFormat.png);

    final imageBytes = byteData!.buffer.asUint8List();

    _addWatermarkToImage(imageBytes);

    return renderedImage;
  }

  Future<void> _addWatermarkToImage(Uint8List inputImage) async {
    var decodeImg = image.decodeImage(inputImage);

    image.drawString(
      decodeImg!,
      "Cou Cou!",
      font: image.arial48,
      color: image.ColorRgba8(0, 0, 0, 1),
      x: 100,
      y: 100,
    );

    var encodeImage = image.encodeJpg(decodeImg, quality: 100);

    final path = await getTempImageFilePath(".png");

    var finalImage = File(path)..writeAsBytesSync(encodeImage);

    await ImageDownloadUtil.saveImageToGallery(
      context: context,
      imageBytes: encodeImage,
      imageName: item!.id!,
    );
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    ByteData bytes = await rootBundle.load(filePath);
    return Uint8List.fromList(bytes.buffer.asUint8List());
  }

  Future<PaletteGenerator> _updatePaletteGenerator() async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(item!.thumbnail ?? ""),
    );
    return paletteGenerator;
  }
}
