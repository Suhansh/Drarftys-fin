import 'package:acoustic/advertisement_provider/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../custom/custom_name_comment_song.dart';
import '../../custom/video_player_item.dart';
import '../../util/advertise/inline_adaptive_example.dart';
import '/custom/like_comment_share.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import 'package:flutter/material.dart';
import '/util/preference_utils.dart';
import '/util/constants.dart';
import '../../model/trendingVideoModel.dart';
import 'following_provider.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FollowingProvider followingProvider;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FollowingProvider>(this.context).followingProviderScaffoldKey =
        _scaffoldKey;
    followingProvider = Provider.of<FollowingProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          color: Color(Constants.lightbluecolor),
          backgroundColor: Colors.white,
          onRefresh: followingProvider.callApiForFollowingVideo,
          key: _refreshIndicatorKey,
          child: Container(
            margin: PreferenceUtils.getBool(Constants.adAvailable) == true
                ? const EdgeInsets.only(bottom: 140)
                : const EdgeInsets.only(bottom: 90),
            child: FutureBuilder<List<TrendingData>>(
              future: followingProvider.getVideoFeatureBuilder,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return (snapshot.data?.length ?? 0) > 0
                        ? PageView.builder(
                            controller:
                                followingProvider.followingPageController,
                            itemCount:
                                followingProvider.followingVidList.length,
                            scrollDirection: Axis.vertical,
                            onPageChanged: (value) {
                              if (followingProvider.fullStatus == true ||
                                  followingProvider.showMore == false) {
                                followingProvider.setHalfStatus();
                              }
                            },
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // String likeCount =
                              //     followingProvider.followingVidList[index].likeCount.toString();
                              if (followingProvider.followingVidList[index]
                                          .description !=
                                      null &&
                                  followingProvider.followingVidList[index]
                                          .description !=
                                      '') {
                              } else {
                                followingProvider.followingVidList[index]
                                    .description = 'The Status is Empty';
                              }
                              if (followingProvider.adMobNative == true) {
                                if (index != 0 && index % 5 == 0) {
                                  InlineAdaptiveExample();
                                }
                              }
                              return Stack(
                                children: <Widget>[
                                  Consumer(
                                    key: ValueKey<int>(followingProvider
                                        .followingVidList[index].id!),
                                    builder: (context, value, child) => Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        color: Colors.transparent,
                                        child: VideoPlayerItem(
                                          videoUrl: followingProvider
                                                  .followingVidList[index]
                                                  .imagePath! +
                                              followingProvider
                                                  .followingVidList[index]
                                                  .video!,
                                          videoId: followingProvider
                                              .followingVidList[index].id,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Middle expanded
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: CustomNameStatusSongFollowing(
                                            followingData: followingProvider
                                                .followingVidList[index],
                                            followingProviderData:
                                                followingProvider,
                                          ),
                                          // child: Container(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 15.0, bottom: 20),
                                          //   child: ListView(
                                          //     shrinkWrap: true,
                                          //     physics: const NeverScrollableScrollPhysics(),
                                          //     children: <Widget>[
                                          //       Row(
                                          //         mainAxisAlignment: MainAxisAlignment.start,
                                          //         children: [
                                          //           InkWell(
                                          //             onTap: () {
                                          //               if (PreferenceUtils.getBool(
                                          //                       Constants.isLoggedIn) ==
                                          //                   true) {
                                          //                 if (followingProvider.followingVidList[index].isYou ==
                                          //                     true) {
                                          //                   Navigator.of(context).push(
                                          //                       MaterialPageRoute(
                                          //                           builder: (context) =>
                                          //                               InitializeScreen(4)));
                                          //                 } else {
                                          //                   Navigator.push(
                                          //                     context,
                                          //                     MaterialPageRoute(
                                          //                       builder: (context) =>
                                          //                           UserProfileScreen(
                                          //                         userId:
                                          //                             followingProvider.followingVidList[index]
                                          //                                 .user!
                                          //                                 .id,
                                          //                       ),
                                          //                     ),
                                          //                   );
                                          //                 }
                                          //               } else {
                                          //                 Future.delayed(
                                          //                     const Duration(seconds: 0),
                                          //                     () =>
                                          //                         Navigator.of(context).push(
                                          //                           MaterialPageRoute(
                                          //                               builder: (context) =>
                                          //                                   LoginScreen()),
                                          //                         ));
                                          //               }
                                          //             },
                                          //             child: Row(
                                          //               children: [
                                          //                 Container(
                                          //                   margin: const EdgeInsets.only(
                                          //                       left: 0, right: 5, bottom: 5),
                                          //                   width: ScreenUtil().setWidth(36),
                                          //                   height:
                                          //                       ScreenUtil().setHeight(36),
                                          //                   child: CachedNetworkImage(
                                          //                     alignment: Alignment.center,
                                          //                     imageUrl:
                                          //                         followingProvider.followingVidList[index]
                                          //                                 .user!
                                          //                                 .imagePath! +
                                          //                             followingProvider.followingVidList[index]
                                          //                                 .user!
                                          //                                 .image!,
                                          //                     imageBuilder:
                                          //                         (context, imageProvider) =>
                                          //                             CircleAvatar(
                                          //                       radius: 15,
                                          //                       backgroundColor:
                                          //                           Colors.transparent,
                                          //                       child: CircleAvatar(
                                          //                         radius: 15,
                                          //                         backgroundImage:
                                          //                             imageProvider,
                                          //                       ),
                                          //                     ),
                                          //                     placeholder: (context, url) =>
                                          //                         CustomLoader(),
                                          //                     errorWidget: (context, url,
                                          //                             error) =>
                                          //                         Image.asset(
                                          //                             "images/no_image.png"),
                                          //                   ),
                                          //                 ),
                                          //                 Container(
                                          //                     margin: const EdgeInsets.only(
                                          //                         bottom: 5),
                                          //                     child: Text(
                                          //                       followingProvider.followingVidList[index]
                                          //                           .user!
                                          //                           .name!,
                                          //                       maxLines: 1,
                                          //                       overflow:
                                          //                           TextOverflow.ellipsis,
                                          //                       style: const TextStyle(
                                          //                           color: Colors.white,
                                          //                           fontSize: 14,
                                          //                           fontWeight:
                                          //                               FontWeight.bold),
                                          //                     )),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //           followingProvider.followingVidList[index].isYou == false
                                          //               ? Container(
                                          //                   margin: const EdgeInsets.only(
                                          //                       left: 2, right: 2, bottom: 5),
                                          //                   child: SvgPicture.asset(
                                          //                     "images/white_dot.svg",
                                          //                     width: 5,
                                          //                     height: 5,
                                          //                   ),
                                          //                 )
                                          //               : Container(),
                                          //           followingProvider.followingVidList[index].isYou == false
                                          //               ? followingProvider.followingVidList[index]
                                          //                           .user!
                                          //                           .isFollowing ==
                                          //                       0
                                          //                   ? InkWell(
                                          //                       onTap: () {
                                          //                         if (PreferenceUtils.getBool(
                                          //                                 Constants
                                          //                                     .isLoggedIn) ==
                                          //                             true) {
                                          //                           followingProvider.callApiForFollowRequest(
                                          //                               followingProvider.followingVidList[
                                          //                                       index]
                                          //                                   .user!
                                          //                                   .id,
                                          //                               followingProvider.followingVidList[
                                          //                                       index]
                                          //                                   .id);
                                          //                         } else {
                                          //                           Navigator.of(context)
                                          //                               .push(
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) =>
                                          //                                     LoginScreen()),
                                          //                           );
                                          //                           // Constants
                                          //                           //     .toastMessage(
                                          //                           //         'Please Login First To Follow');
                                          //                         }
                                          //                       },
                                          //                       child: Row(
                                          //                         children: [
                                          //                           Container(
                                          //                             margin: const EdgeInsets
                                          //                                     .only(
                                          //                                 left: 5,
                                          //                                 right: 2,
                                          //                                 bottom: 5),
                                          //                             child: SvgPicture.asset(
                                          //                               "images/follow.svg",
                                          //                               width: 15,
                                          //                               height: 15,
                                          //                             ),
                                          //                           ),
                                          //                           Container(
                                          //                               margin:
                                          //                                   const EdgeInsets
                                          //                                           .only(
                                          //                                       bottom: 5),
                                          //                               child: const Text(
                                          //                                 'Follow',
                                          //                                 maxLines: 1,
                                          //                                 overflow:
                                          //                                     TextOverflow
                                          //                                         .ellipsis,
                                          //                                 style: TextStyle(
                                          //                                     color: Colors
                                          //                                         .white,
                                          //                                     fontSize: 14,
                                          //                                     fontWeight:
                                          //                                         FontWeight
                                          //                                             .bold),
                                          //                               )),
                                          //                         ],
                                          //                       ),
                                          //                     )
                                          //                   : InkWell(
                                          //                       onTap: () {
                                          //                         if (PreferenceUtils.getBool(
                                          //                                 Constants
                                          //                                     .isLoggedIn) ==
                                          //                             true) {
                                          //                           followingProvider.callApiForUnFollowRequest(
                                          //                               followingProvider.followingVidList[
                                          //                                       index]
                                          //                                   .user!
                                          //                                   .id,
                                          //                               followingProvider.followingVidList[
                                          //                                       index]
                                          //                                   .id);
                                          //                         } else {
                                          //                           Navigator.of(context)
                                          //                               .push(
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) =>
                                          //                                     LoginScreen()),
                                          //                           );
                                          //                           // Constants
                                          //                           //     .toastMessage(
                                          //                           //         'Please Login First To unfollow');
                                          //                         }
                                          //                       },
                                          //                       child: Row(
                                          //                         children: [
                                          //                           Container(
                                          //                             margin: const EdgeInsets
                                          //                                     .only(
                                          //                                 left: 5,
                                          //                                 right: 2,
                                          //                                 bottom: 5),
                                          //                             child: SvgPicture.asset(
                                          //                               "images/follow.svg",
                                          //                               width: 15,
                                          //                               height: 15,
                                          //                             ),
                                          //                           ),
                                          //                           Container(
                                          //                               margin:
                                          //                                   const EdgeInsets
                                          //                                           .only(
                                          //                                       bottom: 5),
                                          //                               child: const Text(
                                          //                                 'Unfollow',
                                          //                                 maxLines: 1,
                                          //                                 overflow:
                                          //                                     TextOverflow
                                          //                                         .ellipsis,
                                          //                                 style: TextStyle(
                                          //                                     color: Colors
                                          //                                         .white,
                                          //                                     fontSize: 14,
                                          //                                     fontWeight:
                                          //                                         FontWeight
                                          //                                             .bold),
                                          //                               )),
                                          //                         ],
                                          //                       ),
                                          //                     )
                                          //               : Container(),
                                          //         ],
                                          //       ),
                                          //       Visibility(
                                          //         visible: followingProvider.halfStatus &&
                                          //             followingProvider.followingVidList[index]
                                          //                 .description!
                                          //                 .isNotEmpty,
                                          //         child: Container(
                                          //           margin: const EdgeInsets.only(
                                          //               left: 10, right: 0, bottom: 5),
                                          //           child: Text(
                                          //             followingProvider.followingVidList[index].description ??
                                          //                 "",
                                          //             maxLines: 1,
                                          //             overflow: TextOverflow.ellipsis,
                                          //             style: TextStyle(
                                          //                 color: Color(Constants.whitetext),
                                          //                 fontSize: 14,
                                          //                 fontFamily: Constants.appFont),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Visibility(
                                          //         visible: followingProvider.fullStatus &&
                                          //             followingProvider.followingVidList[index]
                                          //                 .description!
                                          //                 .isNotEmpty,
                                          //         child: InkWell(
                                          //           onTap: () {
                                          //             setState(() {
                                          //               followingProvider.halfStatus = !followingProvider.halfStatus;
                                          //               followingProvider.fullStatus = !followingProvider.fullStatus;
                                          //               followingProvider.showMore = !followingProvider.showMore;
                                          //             });
                                          //           },
                                          //           child: Container(
                                          //             margin: const EdgeInsets.only(
                                          //                 left: 10, right: 0, bottom: 5),
                                          //             child: Text(
                                          //               followingProvider.followingVidList[index].description ??
                                          //                   "",
                                          //               maxLines: 20,
                                          //               overflow: TextOverflow.ellipsis,
                                          //               style: TextStyle(
                                          //                   color: Color(Constants.whitetext),
                                          //                   fontSize: 14,
                                          //                   fontFamily: Constants.appFont),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Visibility(
                                          //         visible: followingProvider.showMore &&
                                          //             followingProvider.followingVidList[index]
                                          //                 .description!
                                          //                 .isNotEmpty,
                                          //         child: Container(
                                          //           alignment: Alignment.topRight,
                                          //           margin: const EdgeInsets.only(
                                          //               left: 10, right: 20, bottom: 5),
                                          //           child: InkWell(
                                          //             onTap: () {
                                          //               setState(() {
                                          //                 followingProvider.halfStatus = !followingProvider.halfStatus;
                                          //                 followingProvider.fullStatus = !followingProvider.fullStatus;
                                          //                 followingProvider.showMore = !followingProvider.showMore;
                                          //               });
                                          //             },
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment.end,
                                          //               children: [
                                          //                 Text(
                                          //                   "...more",
                                          //                   textAlign: TextAlign.center,
                                          //                   maxLines: 1,
                                          //                   overflow: TextOverflow.ellipsis,
                                          //                   style: TextStyle(
                                          //                       color: Color(
                                          //                           Constants.whitetext),
                                          //                       fontSize: 16,
                                          //                       fontFamily:
                                          //                           Constants.appFont),
                                          //                 ),
                                          //                 Container(
                                          //                   margin: const EdgeInsets.only(
                                          //                       left: 5, right: 5, top: 0),
                                          //                   alignment: Alignment.center,
                                          //                   child: SvgPicture.asset(
                                          //                     "images/down_arrow.svg",
                                          //                     width: 8,
                                          //                     height: 8,
                                          //                   ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       followingProvider.followingVidList[index].originalAudio != null
                                          //           ? InkWell(
                                          //               onTap: () {
                                          //                 String? passSongId = '0';
                                          //                 bool isSongIdAvailable = true;
                                          //                 if (PreferenceUtils.getBool(
                                          //                         Constants.isLoggedIn) ==
                                          //                     true) {
                                          //                   if (followingProvider.followingVidList[index]
                                          //                               .songId !=
                                          //                           '' &&
                                          //                       followingProvider.followingVidList[index]
                                          //                               .songId !=
                                          //                           null) {
                                          //                     passSongId =
                                          //                         followingProvider.followingVidList[index]
                                          //                             .songId;
                                          //                     isSongIdAvailable = true;
                                          //                   } else if (followingProvider.followingVidList[index]
                                          //                               .audioId !=
                                          //                           '' &&
                                          //                       followingProvider.followingVidList[index]
                                          //                               .audioId !=
                                          //                           null) {
                                          //                     passSongId =
                                          //                         followingProvider.followingVidList[index]
                                          //                             .audioId;
                                          //                     isSongIdAvailable = false;
                                          //                   }
                                          //                   Navigator.push(
                                          //                     context,
                                          //                     MaterialPageRoute(
                                          //                         builder: (context) =>
                                          //                             UsedSoundScreen(
                                          //                               songId: passSongId,
                                          //                               isSongIdAvailable:
                                          //                                   isSongIdAvailable,
                                          //                             )),
                                          //                   );
                                          //                 } else {
                                          //                   Navigator.of(context).push(
                                          //                     MaterialPageRoute(
                                          //                         builder: (context) =>
                                          //                             LoginScreen()),
                                          //                   );
                                          //                   // Constants.toastMessage(
                                          //                   //     'Please login to enter Music Gallery');
                                          //                 }
                                          //               },
                                          //               child: Row(children: [
                                          //                 Container(
                                          //                   margin: const EdgeInsets.only(
                                          //                       left: 5, right: 2),
                                          //                   child: SvgPicture.asset(
                                          //                     "images/sound_waves.svg",
                                          //                     width: 15,
                                          //                     height: 15,
                                          //                   ),
                                          //                 ),
                                          //                 Expanded(
                                          //                   child: Container(
                                          //                     height: 20,
                                          //                     margin: const EdgeInsets.only(
                                          //                         left: 5, right: 2),
                                          //                     child: Marquee(
                                          //                       text: followingProvider.followingVidList[index]
                                          //                               .originalAudio ??
                                          //                           "UnKnown audio found ",
                                          //                       style: const TextStyle(
                                          //                           color: Colors.white,
                                          //                           fontSize: 14,
                                          //                           fontWeight:
                                          //                               FontWeight.bold),
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //               ]),
                                          //             )
                                          //           : Container(),
                                          //     ],
                                          //   ),
                                          // ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CustomLikeComment(
                                            index: index,
                                            shareLink: followingProvider
                                                    .followingVidList[index]
                                                    .imagePath! +
                                                followingProvider
                                                    .followingVidList[index]
                                                    .video!,
                                            commentCount: followingProvider
                                                .followingVidList[index]
                                                .commentCount
                                                .toString(),
                                            isLike: followingProvider
                                                .followingVidList[index].isLike,
                                            listOfAll: followingProvider
                                                .followingVidList,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
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
          ),
        ),
      ),
    );
  }
}
