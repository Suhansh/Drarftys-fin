import '../../advertisement_provider/ad_helper.dart';
import '../../util/advertise/inline_adaptive_example.dart';
import '/custom/like_comment_share.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/model/trendingVideoModel.dart';
import '/screen/trending/trending_provider.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom/custom_name_comment_song.dart';
import '../../custom/video_player_item.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  _TrendingScreen createState() => _TrendingScreen();
}

class _TrendingScreen extends State<TrendingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late TrendingProvider trendingProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    trendingProvider = Provider.of<TrendingProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: RefreshIndicator(
          color: Color(Constants.lightbluecolor),
          backgroundColor: Colors.white,
          onRefresh: trendingProvider.callApiForTrendingVideo,
          key: _refreshIndicatorKey,
          child: Container(
            margin: PreferenceUtils.getBool(Constants.adAvailable) == true
                ? const EdgeInsets.only(bottom: 150)
                : const EdgeInsets.only(bottom: 90),
            child: FutureBuilder<List<TrendingData>>(
              future: trendingProvider.getVideoFeatureBuilder,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return (snapshot.data?.length ?? 0) > 0
                        ? PageView.builder(
                            itemCount: trendingProvider.trendingVidList.length,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            onPageChanged: (value) {
                              if (trendingProvider.fullStatus == true ||
                                  trendingProvider.showMore == false) {
                                trendingProvider.setHalfStatus();
                              }
                            },
                            itemBuilder: (context, index) {
                              if (trendingProvider.adMobNative == true) {
                                if (index != 0 && index % 5 == 0) {
                                  return Align(
                                      alignment: Alignment.center,
                                      child: InlineAdaptiveExample());
                                }
                              }
                              return Stack(
                                children: <Widget>[
                                  ///videoPlayer
                                  Consumer<TrendingProvider>(
                                    key: ValueKey<int>(trendingProvider
                                        .trendingVidList[index].id!),
                                    builder: (context, value, child) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.transparent,
                                          child: VideoPlayerItem(
                                            videoId: trendingProvider
                                                .trendingVidList[index].id,
                                            videoUrl: trendingProvider
                                                    .trendingVidList[index]
                                                    .imagePath! +
                                                trendingProvider
                                                    .trendingVidList[index]
                                                    .video!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: CustomNameStatusSongTrending(
                                            trendingData: trendingProvider
                                                .trendingVidList[index],
                                            trendingProviderData:
                                                trendingProvider,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CustomLikeComment(
                                            // singleData: trendingProvider.trendingVidList[index],
                                            // listOfAllVideos: trendingProvider.trendingVidList,
                                            index: index,
                                            shareLink: trendingProvider
                                                    .trendingVidList[index]
                                                    .imagePath! +
                                                trendingProvider
                                                    .trendingVidList[index]
                                                    .video!,
                                            commentCount: trendingProvider
                                                .trendingVidList[index]
                                                .commentCount
                                                .toString(),
                                            isLike: trendingProvider
                                                .trendingVidList[index].isLike,
                                            listOfAll: trendingProvider
                                                .trendingVidList,
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
