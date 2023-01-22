import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../advertisement_provider/ad_helper.dart';
import '../../util/advertise/inline_adaptive_example.dart';
import '/custom/custom_name_comment_song.dart';
import '../../custom/video_player_item.dart';
import '/custom/like_comment_share.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/screen/nearby/nearBy_provider.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../model/trendingVideoModel.dart';

class NearByScreen extends StatefulWidget {
  const NearByScreen({Key? key}) : super(key: key);

  @override
  _NearByScreen createState() => _NearByScreen();
}

class _NearByScreen extends State<NearByScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late NearByProvider nearByProvider;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<NearByProvider>(this.context).nearByProviderScaffoldKey =
        _scaffoldKey;
    nearByProvider = Provider.of<NearByProvider>(context);
    dynamic screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          // key: _scaffoldKey,
          body: Container(
            margin: PreferenceUtils.getBool(Constants.adAvailable) == true
                ? const EdgeInsets.only(bottom: 140)
                : const EdgeInsets.only(bottom: 90),
            child: nearByProvider.showGridView == true

                /// for grid view
                ? LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return Stack(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                    child: FutureBuilder<List<TrendingData>>(
                                  future: nearByProvider.getVideoFeatureBuilder,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done:
                                        return (snapshot.data?.length ?? 0) > 0
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 20,
                                                    right: 20),
                                                child: StaggeredGridView
                                                    .countBuilder(
                                                  staggeredTileBuilder:
                                                      (int index) =>
                                                          StaggeredTile.count(
                                                              2,
                                                              index.isEven
                                                                  ? 2.5
                                                                  : 2.5),
                                                  mainAxisSpacing: 2.0,
                                                  crossAxisSpacing: 1.0,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  crossAxisCount: 4,
                                                  itemCount: nearByProvider
                                                      .nearByVidList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    bool isSaved = false;
                                                    nearByProvider
                                                                .nearByVidList[
                                                                    index]
                                                                .isLike ==
                                                            false
                                                        ? isSaved = false
                                                        : isSaved = true;
                                                    return InkWell(
                                                      onTap: () {
                                                        nearByProvider
                                                                .showGridView =
                                                            false;
                                                        nearByProvider
                                                                .nearByController =
                                                            PageController(
                                                                initialPage:
                                                                    index,
                                                                keepPage: true);
                                                        nearByProvider.notify();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: nearByProvider
                                                                      .nearByVidList[
                                                                          index]
                                                                      .imagePath! +
                                                                  nearByProvider
                                                                      .nearByVidList[
                                                                          index]
                                                                      .screenshot!,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CustomLoader(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                "images/no_image.png",
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: SvgPicture
                                                                  .asset(
                                                                "images/play_button.svg",
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 0,
                                                                      bottom:
                                                                          5),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Text(
                                                                        () {
                                                                          if (1 <
                                                                              int.parse(nearByProvider.nearByVidList[index].viewCount!)) {
                                                                            return "${nearByProvider.nearByVidList[index].viewCount} Views";
                                                                          } else {
                                                                            return "${nearByProvider.nearByVidList[index].viewCount} View";
                                                                          }
                                                                        }(),
                                                                        style: TextStyle(
                                                                            color: Color(Constants
                                                                                .whitetext),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                Constants.appFont),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.bottomRight,
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (nearByProvider.savedItem.isNotEmpty) {
                                                                                if (isSaved) {
                                                                                  nearByProvider.savedItem.remove(nearByProvider.nearByVidList[index].id);
                                                                                } else {
                                                                                  nearByProvider.savedItem.add(nearByProvider.nearByVidList[index].id);
                                                                                }
                                                                              } else {
                                                                                nearByProvider.savedItem.add(nearByProvider.nearByVidList[index].id);
                                                                              }
                                                                            },
                                                                            child: isSaved
                                                                                ? SvgPicture.asset(
                                                                                    "images/red_heart.svg",
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    "images/white_heart.svg",
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Align(
                                                alignment: Alignment.center,
                                                child: NoPostAvailable(
                                                  subject: 'Post',
                                                ),
                                              );
                                      case ConnectionState.none:
                                        return const CustomLoader();
                                      case ConnectionState.waiting:
                                        return const CustomLoader();
                                      case ConnectionState.active:
                                        return const CustomLoader();
                                      default:
                                        return Container();
                                    }
                                  },
                                )),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )

                /// for page view
                : SizedBox(
                    height: screenHeight / 1.20,
                    child: LayoutBuilder(builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return FutureBuilder<List<TrendingData>>(
                        future: nearByProvider.getVideoFeatureBuilder,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              return (snapshot.data?.length ?? 0) > 0
                                  ? PageView.builder(
                                      controller:
                                          nearByProvider.nearByController,
                                      itemCount:
                                          nearByProvider.nearByVidList.length,
                                      scrollDirection: Axis.vertical,
                                      onPageChanged: (value) {
                                        if (nearByProvider.fullStatus == true ||
                                            nearByProvider.showMore == false) {
                                          nearByProvider.setHalfStatus();
                                        }
                                      },
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        if (nearByProvider.nearByVidList[index]
                                                    .description !=
                                                null &&
                                            nearByProvider.nearByVidList[index]
                                                    .description !=
                                                '') {
                                        } else {
                                          nearByProvider.nearByVidList[index]
                                                  .description =
                                              'The Status is Empty';
                                        }
                                        if (nearByProvider.adMobNative ==
                                            true) {
                                          if (index != 0 && index % 5 == 0) {
                                            /// admobb
                                            InlineAdaptiveExample();
                                          }
                                        }
                                        return Stack(
                                          children: <Widget>[
                                            Consumer(
                                              key: ValueKey<int>(nearByProvider
                                                  .nearByVidList[index].id!),
                                              builder:
                                                  (context, value, child) =>
                                                      Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  color: Colors.transparent,
                                                  child: VideoPlayerItem(
                                                    videoUrl: nearByProvider
                                                            .nearByVidList[
                                                                index]
                                                            .imagePath! +
                                                        nearByProvider
                                                            .nearByVidList[
                                                                index]
                                                            .video!,
                                                    videoId: nearByProvider
                                                        .nearByVidList[index]
                                                        .id,
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
                                                    child:
                                                        CustomNameStatusSongNearBy(
                                                      nearByData: nearByProvider
                                                          .nearByVidList[index],
                                                      nearByProvider:
                                                          nearByProvider,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CustomLikeComment(
                                                      index: index,
                                                      shareLink: nearByProvider
                                                              .nearByVidList[
                                                                  index]
                                                              .imagePath! +
                                                          nearByProvider
                                                              .nearByVidList[
                                                                  index]
                                                              .video!,
                                                      commentCount:
                                                          nearByProvider
                                                              .nearByVidList[
                                                                  index]
                                                              .commentCount
                                                              .toString(),
                                                      isLike: nearByProvider
                                                          .nearByVidList[index]
                                                          .isLike,
                                                      listOfAll: nearByProvider
                                                          .nearByVidList,
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
                                        subject: 'Post',
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
                      );
                    }),
                  ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
