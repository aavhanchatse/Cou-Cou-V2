import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalAudioBottomsheet extends StatefulWidget {
  const LocalAudioBottomsheet({Key? key}) : super(key: key);

  @override
  State<LocalAudioBottomsheet> createState() => _LocalAudioBottomsheetState();
}

class _LocalAudioBottomsheetState extends State<LocalAudioBottomsheet> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: FutureBuilder<List<SongModel>>(
        // Default values:
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          // Display error, if any.
          if (item.hasError) {
            return Text(item.error.toString());
          }

          // Waiting content.
          if (item.data == null) {
            return Center(
                child: CircularProgressIndicator(
              color: Constants.primaryColor,
            ));
          }

          // 'Library' is empty.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          // You can use [item.data!] direct or you can create a:
          // List<SongModel> songs = item.data!;
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              final element = item.data![index];

              return ListTile(
                onTap: () async {
                  // Uint8List? something = await _audioQuery.queryArtwork(
                  //   element.id,
                  //   ArtworkType.AUDIO,
                  // );
                  // debugPrint("something: $something");

                  File file = File(element.data);

                  debugPrint("element: $element");
                  context.pop(file);
                },
                title: Text(
                  item.data![index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inika",
                  ),
                ),
                trailing: Icon(
                  Icons.add_circle_outline,
                  color: Constants.black,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  void _downloadAudioFile() async {
    String dir;
    if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    } else {
      dir = (await getExternalStorageDirectories())![0].path;
    }

    final audioFile = File(p.join(dir, 'audiofile.mp3'));

    var response = await http.get(Uri.parse(""));

    await audioFile.writeAsBytes(response.bodyBytes);

    print(audioFile.path);
    Map<String, dynamic> reqMap = {};
    reqMap["responseType"] = "audio";
    reqMap['audioPath'] = audioFile.path;

    Navigator.pop(context, reqMap);

    // var filePath = await AppCacheManager.getCachedFilePath(
    //     selectedAudio.audioFile, selectedAudio.audioFile.hashCode.toString());
  }
}
