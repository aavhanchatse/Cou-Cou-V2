import 'dart:async';
import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderDialog extends StatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  _AudioRecorderDialogState createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends State<AudioRecorderDialog> {
  bool _isDoneButtonShow = false;
  Stopwatch stopwatch = Stopwatch();

  late AudioRecorder record;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startRecording();
  }

  void startRecording() async {
    record = AudioRecorder();
    setState(() {});

    Future.delayed(const Duration(milliseconds: 500), () async {
      stopwatch.start();
      debugPrint("${await record.hasPermission()}");
      if (await record.hasPermission()) {
        String dir;
        if (Platform.isIOS) {
          dir = (await getApplicationDocumentsDirectory()).path;
        } else {
          dir = (await getExternalStorageDirectories())![0].path;
        }
        final currentTimeMillisecond =
            DateTime.now().millisecondsSinceEpoch.toString();

        String path =
            '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_audio.wav';

        await record.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: path,
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _isDoneButtonShow = true;
          });
        });
      }
    });
  }

  void stopRecording() async {
    final path = await record.stop();
    debugPrint("path: $path");
    context.pop(path);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    record.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 24),
                  const Text('Listening ...',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  Stack(
                    fit: StackFit.loose,
                    children: <Widget>[
                      SpinKitRipple(
                        size: 95,
                        color: Constants.primaryColor,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: CircleAvatar(
                            backgroundColor: Constants.primaryColor,
                            radius: 30,
                            child: const Icon(Icons.mic,
                                color: Colors.black, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[TimerText(stopwatch: stopwatch)],
                  ),
                  const SizedBox(height: 38),
                  Opacity(
                    opacity: _isDoneButtonShow ? 1.0 : 0.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      onPressed: () async {
                        if (_isDoneButtonShow) {
                          print('pressed');
                          stopRecording();
                          // final recording = await AudioRecorder.stop();
                          // final path = recording.path;
                          // Map<String, dynamic> map = <String, dynamic>{};
                          // map['path'] = path;
                          // map['milliseconds'] =
                          //     recording.duration.inMilliseconds;
                          // Navigator.of(context).pop(map);
                        }
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6)
                ],
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                // await AudioRecorder.stop();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color(0x8Affffff),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: const Icon(Icons.close, size: 30),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({super.key, required this.stopwatch});
  final Stopwatch stopwatch;

  @override
  TimerTextState createState() => TimerTextState(stopwatch: stopwatch);
}

class TimerTextState extends State<TimerText> {
  late Timer timer;
  Stopwatch stopwatch;

  TimerTextState({required this.stopwatch}) {
    timer = Timer.periodic(const Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle timerTextStyle = TextStyle(fontSize: 26.0);
    String formattedTime =
        DateUtil.formatTimeText(stopwatch.elapsedMilliseconds);
    return Text(formattedTime, style: timerTextStyle);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
