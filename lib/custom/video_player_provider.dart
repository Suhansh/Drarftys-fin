import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../apiservice/Api_Header.dart';
import '../apiservice/Apiservice.dart';

class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerController videoController=VideoPlayerController.network("");
  bool isShowPlaying = false;
  bool visible = false;
  bool showLoading = true;

  void videoControllerInit(videoUrl, videoId) {
    videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) {
        isShowPlaying = false;
        videoController.play();
      });
    videoController.seekTo(Duration.zero);
    videoController.setLooping(true);
    videoController.play();
    callApiForViewVideo(videoId);
    videoController.addListener(() {
      videoController.value.isBuffering ? showLoading = true : showLoading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> callApiForViewVideo(videoId) async {
    await RestClient(ApiHeader().dioData()).viewVideo(videoId).then((response) {
      if (kDebugMode) {
        print(response);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print("error:$obj");
        print(obj.runtimeType);
      }
    });
  }

  void playPauseVideo() {
    visible = true;
    hideBar();
    videoController.value.isPlaying ? videoController.pause() : videoController.play();
    notifyListeners();
  }

  hideBar() async {
    Timer(
      const Duration(seconds: 2),
      () {
        visible = false;
        notifyListeners();
      },
    );
  }
}
