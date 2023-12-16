import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class DismissPage extends StatefulWidget {
  static const routeName = '/dismiss';

  final int? initialIndex;
  final List<dynamic>? imageList;
  final bool isVideo;

  const DismissPage(
      {Key? key, this.initialIndex, this.imageList, this.isVideo = false})
      : super(key: key);

  @override
  State<DismissPage> createState() => _DismissiblePageState();
}

class _DismissiblePageState extends State<DismissPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DismissiblePage(
        backgroundColor: Colors.transparent,
        onDismissed: () {
          // context.pop();
          Navigator.pop(context);
          // Navigator.of(context, rootNavigator: true).pop();
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              SizedBox.expand(
                child: CarouselSlider.builder(
                  itemCount: widget.imageList!.length,
                  itemBuilder: (_, index, __) {
                    return Center(
                        child:
                            // widget.isVideo
                            //     ? SizedBox(
                            //         width: double.infinity,
                            //         height: double.infinity,
                            //         child: CouCouVideoPlayer(
                            //           data: widget.imageList![index],
                            //         ),
                            //       )
                            //     :
                            SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: InteractiveViewer(
                        panEnabled: false,
                        // Set it to false
                        boundaryMargin: const EdgeInsets.all(100),
                        minScale: 0.5,
                        maxScale: 2,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageList![index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ));
                  },
                  options: CarouselOptions(
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 1.0,
                    disableCenter: true,
                    initialPage: widget.initialIndex ?? 0,
                    enableInfiniteScroll: widget.imageList!.length != 1,
                  ),
                ),
              ),
              Positioned(
                top: 9.h,
                left: 4.w,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    shape: const CircleBorder(),
                    elevation: 0,
                    color: Colors.white.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.arrow_back,
                        size: 3.t,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
