import 'dart:io';
import 'package:flutter/foundation.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;
  final ValueSetter<String?> onVideoSave;
  final double maxLength;
  final String? sound;

  const TrimmerView(
      {Key? key,
      required this.file,
      required this.onVideoSave,
      required this.maxLength,
      this.sound})
      : super(key: key);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;
    late String videoDirectory;
    if (Platform.isAndroid) {
      final Directory? appDirectory = await (getExternalStorageDirectory());
      videoDirectory = '${appDirectory!.path}/TrimVideos';
    } else {
      final Directory? appDirectory =
          await (getApplicationDocumentsDirectory());
      videoDirectory = '${appDirectory!.path}/TrimVideos';
    }

    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _trimmer
        .saveTrimmedVideo(
            applyVideoEncoding: true,
            startValue: _startValue,
            endValue: _endValue,
//            maxLength: widget.maxLength,
            customVideoFormat: '.mp4',
            videoFolderName: "TrimVideos",
            videoFileName: currentTime,
            storageDir: StorageDir.externalStorageDirectory,
            ffmpegCommand:
                "-i ${PreferenceUtils.getString(Constants.waterMarkPath)}  -filter_complex 'overlay=20:20'")
        .then((value) {
      setState(() {
        _progressVisibility = true;
        _value = value;
      });
    });
    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress) {
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.black,
              body: Builder(
                builder: (context) => Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Visibility(
                            visible: _progressVisibility,
                            child: LinearProgressIndicator(
                              backgroundColor: Color(Constants.bgblack),
                              color: Color(Constants.lightbluecolor),
                            ),
                          ),
                          Expanded(
                            child: VideoViewer(trimmer: _trimmer),
                          ),
                          Center(
                            child: TrimEditor(
                              trimmer: _trimmer,
                              viewerHeight: 50.0,
                              viewerWidth: MediaQuery.of(context).size.width,
                              maxVideoLength:
                                  Duration(seconds: widget.maxLength.toInt()),
                              onChangeStart: (value) {
                                _startValue = value;
                              },
                              onChangeEnd: (value) {
                                _endValue = value;
                              },
                              onChangePlaybackState: (value) {
                                if (assetsAudioPlayer
                                        .currentPosition.value.inMilliseconds
                                        .toDouble() >=
                                    _endValue) {
                                  assetsAudioPlayer.playOrPause();
                                }
                                if (!value) {
                                  assetsAudioPlayer.pause();
                                  assetsAudioPlayer
                                      .seek(const Duration(seconds: 0));
                                } else {
                                  assetsAudioPlayer.play();
                                }
                                setState(() {
                                  _isPlaying = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    primary: const Color(0xff15161a),
                                  ),
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff485563),
                                            Color(0xff485563)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isPlaying ? "Pause" : "Play",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'RockWellStd',
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (widget.sound != "" &&
                                        widget.sound != null) {
                                      if (assetsAudioPlayer.current.value ==
                                          null) {
                                        AssetsAudioPlayer.allPlayers()
                                            .forEach((key, value) {
                                          value.pause();
                                        });
                                        await assetsAudioPlayer.open(
                                            Audio.network(widget.sound!),
                                            autoStart: true);
                                      } else {
                                        AssetsAudioPlayer.allPlayers()
                                            .forEach((key, value) {
                                          value.pause();
                                        });
                                        assetsAudioPlayer.pause();
                                      }
                                    }
                                    bool playbackState =
                                        await _trimmer.videPlaybackControl(
                                      startValue: _startValue,
                                      endValue: _endValue,
                                    );
                                    setState(() {
                                      _isPlaying = playbackState;
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    primary: const Color(0xff15161a),
                                  ),
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff485563),
                                            Color(0xff485563)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'RockWellStd',
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: _progressVisibility
                                      ? null
                                      : () async {
                                          _saveVideo().then((outputPath) {
                                            if (kDebugMode) {
                                              print('OUTPUT PATH: $outputPath');
                                            }
                                            widget.onVideoSave(outputPath);
                                          });
                                        },
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              )),
        ));
  }
}
