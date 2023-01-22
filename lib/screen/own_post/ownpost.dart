import 'dart:async';
import '../../custom/no_post_available.dart';
import '/screen/own_post/own_post_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/mute_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '/screen/usedSoundList.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marquee/marquee.dart';
import 'package:video_player/video_player.dart';

class OwnPostScreen extends StatefulWidget {
  final int? id;

  const OwnPostScreen(this.id, {Key? key}) : super(key: key);

  @override
  _OwnPostScreen createState() => _OwnPostScreen();
}

class _OwnPostScreen extends State<OwnPostScreen>
    with SingleTickerProviderStateMixin {
  // final textCommentController = TextEditingController();
  late AnimationController _iconAnimationController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late OwnPostProvider ownPostProvider;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.75,
    );
    Provider.of<OwnPostProvider>(context, listen: false).ownPostInit(widget.id);
  }

  @override
  void dispose() {
    Provider.of<OwnPostProvider>(context, listen: false).controller.dispose();
    super.dispose();
  }

  _hideBar() {
    Timer(
      const Duration(seconds: 2),
      () {
        ownPostProvider.visible = false;
        ownPostProvider.notify();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OwnPostProvider>(context).ownPostProviderScaffoldKey =
        _scaffoldKey;
    ownPostProvider = Provider.of<OwnPostProvider>(context);
    if (30 >= ownPostProvider.status.length) {
      ownPostProvider.showMore = false;
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(Constants.bgblack),
        appBar: AppBar(
          title: const Text("Posts"),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 0),
          child: ModalProgressHUD(
            inAsyncCall: ownPostProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: InkWell(
              onTap: () {
                ownPostProvider.visible = true;
                _hideBar();
                ownPostProvider.controller.value.isPlaying
                    ? ownPostProvider.controller.pause()
                    : ownPostProvider.controller.play();
                ownPostProvider.notify();
              },
              child: Stack(
                children: <Widget>[
                  FutureBuilder<bool>(
                    future: ownPostProvider.getVideoFeatureBuilder,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return (snapshot.data!)
                              ? ChangeNotifierProvider.value(
                                  value: ownPostProvider,
                                  child: Consumer<OwnPostProvider>(
                                    key: ValueKey<int>(ownPostProvider
                                        .controller
                                        .value
                                        .duration
                                        .inMilliseconds),
                                    builder: (context, value, child) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black12),
                                        child: SizedBox.expand(
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              width: ownPostProvider
                                                  .controller.value.size.width,
                                              height: ownPostProvider
                                                  .controller.value.size.height,
                                              child: VideoPlayer(
                                                  ownPostProvider.controller),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: NoPostAvailable(
                                    subject: "Post",
                                  ),
                                );
                        case ConnectionState.none:
                          return const CustomLoader();
                        case ConnectionState.waiting:
                          return const CustomLoader();
                        case ConnectionState.active:
                          return const CustomLoader();
                        default:
                          return const CustomLoader();
                      }
                    },
                  ),

                  ///mute icon
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Visibility(
                          visible: ownPostProvider.visible,
                          child: ownPostProvider.controller.value.isPlaying
                              ? const MuteIconWidget(isMute: true)
                              : const MuteIconWidget(isMute: false)),
                    ),
                  ),

                  /// Middle expanded
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, bottom: 20),
                                  child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0, right: 5, bottom: 5),
                                              width: ScreenUtil().setWidth(36),
                                              height:
                                                  ScreenUtil().setHeight(36),
                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl:
                                                    ownPostProvider.userImage,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CustomLoader(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "images/no_image.png"),
                                              ),
                                            ),
                                            Text(
                                              ownPostProvider.username!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: ownPostProvider.halfStatus,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 0, bottom: 5),
                                            child: Text(
                                              ownPostProvider.status,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontSize: 14,
                                                  fontFamily:
                                                      Constants.appFont),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: ownPostProvider.fullStatus,
                                          child: InkWell(
                                            onTap: () {
                                              ownPostProvider.showMoreStatus();
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 0,
                                                  bottom: 5),
                                              child: Text(
                                                ownPostProvider.status,
                                                maxLines: 20,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.whitetext),
                                                    fontSize: 14,
                                                    fontFamily:
                                                        Constants.appFont),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: ownPostProvider.showMore,
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 20, bottom: 5),
                                            child: InkWell(
                                              onTap: () {
                                                ownPostProvider
                                                    .showMoreStatus();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "...more",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(Constants
                                                            .whitetext),
                                                        fontSize: 16,
                                                        fontFamily:
                                                            Constants.appFont),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 0),
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      "images/down_arrow.svg",
                                                      width: 8,
                                                      height: 8,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        ownPostProvider.originalSound != null
                                            ? InkWell(
                                                onTap: () {
                                                  ownPostProvider.controller
                                                      .pause();
                                                  String passSongId = '0';
                                                  bool isSongIdAvailable = true;
                                                  if (ownPostProvider.songId !=
                                                          '' &&
                                                      ownPostProvider.songId !=
                                                          null &&
                                                      ownPostProvider.songId !=
                                                          'null') {
                                                    passSongId =
                                                        ownPostProvider.songId;
                                                    isSongIdAvailable = true;
                                                  } else if (ownPostProvider
                                                              .audioId !=
                                                          '' &&
                                                      ownPostProvider.audioId !=
                                                          null &&
                                                      ownPostProvider.audioId !=
                                                          'null') {
                                                    passSongId =
                                                        ownPostProvider.audioId;
                                                    isSongIdAvailable = false;
                                                  }
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UsedSoundScreen(
                                                              songId:
                                                                  passSongId,
                                                              isSongIdAvailable:
                                                                  isSongIdAvailable,
                                                            )),
                                                  );
                                                },
                                                child: Row(children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10, right: 2),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: SvgPicture.asset(
                                                      "images/sound_waves.svg",
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 20,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 2),
                                                      child: Marquee(
                                                        text: ownPostProvider
                                                            .originalSound!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              )
                                            : Container(),
                                      ]))),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              width: 100.0,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          ownPostProvider.shareVideo();
                                        },
                                        child: _getSocialAction(
                                          icon: "images/share.svg",
                                          title: 'Share',
                                        )),
                                    InkWell(
                                        onTap: () {
                                          ownPostProvider.controller.pause();
                                          Constants.checkNetwork().whenComplete(
                                              () => ownPostProvider
                                                  .callApiForGetComment(
                                                      ownPostProvider.videoId));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: _getSocialAction(
                                              icon: "images/comments.svg",
                                              title:
                                                  ownPostProvider.commentCount),
                                        )),
                                    InkWell(
                                      onTap: () {
                                        ownPostProvider.likeVideos(context);
                                        if (ownPostProvider.isLike == true) {
                                          _iconAnimationController
                                              .forward()
                                              .then((value) {
                                            _iconAnimationController.reverse();
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: _getSocialActionLike(
                                            icon: ownPostProvider.isLike == true
                                                ? "images/red_heart.svg"
                                                : "images/white_heart.svg",
                                            title: ownPostProvider.likeCount),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                  ),

                  ///loading
                  Visibility(
                    visible: ownPostProvider.showLoading,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black12),
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                          child: SizedBox(
                              width:
                                  ownPostProvider.controller.value.size.width,
                              height:
                                  ownPostProvider.controller.value.size.height,
                              child: const Center(child: CustomLoader())),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSocialAction({required String title, required String icon}) {
    return Container(
        margin: const EdgeInsets.only(top: 15.0),
        width: 60.0,
        height: 60.0,
        child: Column(children: [
          SvgPicture.asset(icon),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          )
        ]));
  }

  Widget _getSocialActionLike({required String title, required String icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(
        children: [
          ScaleTransition(
            scale: _iconAnimationController,
            child: SvgPicture.asset(
              icon,
              height: 27,
              width: 27,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          )
        ],
      ),
    );
  }
}
