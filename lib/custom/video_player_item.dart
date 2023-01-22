import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'loader_custom_widget.dart';
import 'mute_icon.dart';
import 'video_player_provider.dart';

class VideoPlayerItem extends StatefulWidget {
  final String? videoUrl;
  final int? videoId;

  const VideoPlayerItem({Key? key, this.videoUrl, this.videoId}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerProvider videoPlayerProvider;

  @override
  void initState() {
    super.initState();
    videoPlayerProvider=Provider.of<VideoPlayerProvider>(context,listen: false);
    Future.delayed(Duration.zero,(){
      videoPlayerProvider.videoControllerInit(widget.videoUrl, widget.videoId);
    });
  }

  @override
  void deactivate() {
    Provider.of<VideoPlayerProvider>(context, listen: false).videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    if(Provider.of<VideoPlayerProvider>(context, listen: false).videoController != null){
      Provider.of<VideoPlayerProvider>(context, listen: false).videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    videoPlayerProvider = Provider.of<VideoPlayerProvider>(context);
    return InkWell(
      onTap: () {
        videoPlayerProvider.playPauseVideo();
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.black12),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.center,
                child: SizedBox(
                  width: videoPlayerProvider.videoController.value.size.width,
                  height: videoPlayerProvider.videoController.value.size.height,
                  child: VideoPlayer(videoPlayerProvider.videoController),
                ),
              ),
            ),
          ),
          Visibility(
            visible: videoPlayerProvider.showLoading,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black12),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: videoPlayerProvider.videoController.value.size.width,
                      height: videoPlayerProvider.videoController.value.size.height,
                      child: const Center(child: CustomLoader())),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Visibility(
                visible: videoPlayerProvider.visible,
                child: videoPlayerProvider.videoController.value.isPlaying
                    ? const MuteIconWidget(isMute: true)
                    : const MuteIconWidget(isMute: false),
              ),
            ),
          )
        ],
      ),
    );
  }
}
