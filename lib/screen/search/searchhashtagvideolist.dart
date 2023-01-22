import 'package:provider/provider.dart';
import '/custom/customview.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/model/hashtag_video.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../own_post/ownpost.dart';
import 'search_hashtag_video_provider.dart';

class HashTagVideoListScreen extends StatefulWidget {
  final String? hashtag;
  final String? views;

  const HashTagVideoListScreen({Key? key, required this.hashtag, required this.views})
      : super(key: key);

  @override
  _HashTagVideoListScreen createState() => _HashTagVideoListScreen();
}

class _HashTagVideoListScreen extends State<HashTagVideoListScreen> {
  late SearchHashtagVideoProvider searchHashtagVideoProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<SearchHashtagVideoProvider>(context, listen: false).getHashtagVideoFeatureBuilder =
        Provider.of<SearchHashtagVideoProvider>(context, listen: false)
            .callApiForHashTagVideos(widget.hashtag);
  }

  @override
  Widget build(BuildContext context) {
    searchHashtagVideoProvider = Provider.of<SearchHashtagVideoProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: searchHashtagVideoProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: ScreenUtil().setHeight(55),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 20),
                                            alignment: Alignment.centerLeft,
                                            child: SvgPicture.asset("images/back.svg"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            children: <Widget>[
                                              Text(
                                                "#${widget.hashtag}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(Constants.whitetext),
                                                    fontFamily: Constants.appFontBold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                () {
                                                  if (1 < int.parse(widget.views.toString())) {
                                                    return "${widget.views} Views";
                                                  } else {
                                                    return "${widget.views} View";
                                                  }
                                                }(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(Constants.greytext),
                                                    fontFamily: Constants.appFont,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 20),
                                          alignment: Alignment.centerRight,
                                          // child: SvgPicture.asset(
                                          //     "images/white_share.svg"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: FutureBuilder<List<HashtagVideoData>>(
                                  future: searchHashtagVideoProvider.getHashtagVideoFeatureBuilder,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done:
                                        return (snapshot.data?.length ?? 0) > 0
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 50, left: 20, right: 20),
                                                child: StaggeredGridView.countBuilder(
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  itemCount: searchHashtagVideoProvider
                                                      .hashtagVideos.length,
                                                  itemBuilder: (BuildContext context, int index) =>
                                                      InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => OwnPostScreen(
                                                              searchHashtagVideoProvider
                                                                  .hashtagVideos[index].id)));
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            /// screenshots
                                                            CachedNetworkImage(
                                                              imageUrl: searchHashtagVideoProvider
                                                                      .hashtagVideos[index]
                                                                      .imagePath! +
                                                                  searchHashtagVideoProvider
                                                                      .hashtagVideos[index]
                                                                      .screenshot!,
                                                              imageBuilder:
                                                                  (context, imageProvider) =>
                                                                      Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(20.0),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill,
                                                                    alignment: Alignment.topCenter,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) =>
                                                                  const CustomLoader(),
                                                              errorWidget: (context, url, error) =>
                                                                  Image.asset(
                                                                      "images/no_image.png"),
                                                            ),

                                                            /// play button
                                                            Container(
                                                              alignment: Alignment.center,
                                                              child: SvgPicture.asset(
                                                                  "images/play_button.svg"),
                                                            ),

                                                            /// user name and profile pic
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin: const EdgeInsets.only(
                                                                    left: 10, bottom: 30),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.end,
                                                                  children: [
                                                                    /// userprofile
                                                                    Align(
                                                                      alignment:
                                                                          Alignment.bottomCenter,
                                                                      child: CachedNetworkImage(
                                                                        alignment: Alignment.bottomLeft,
                                                                        imageUrl:
                                                                            searchHashtagVideoProvider
                                                                                    .hashtagVideos[
                                                                                        index]
                                                                                    .user!
                                                                                    .imagePath! +
                                                                                searchHashtagVideoProvider
                                                                                    .hashtagVideos[
                                                                                        index]
                                                                                    .user!
                                                                                    .image!,
                                                                        imageBuilder: (context,
                                                                                imageProvider) {
                                                                          return CircleAvatar(
                                                                            radius: 15,
                                                                            backgroundImage:
                                                                                imageProvider,
                                                                          );
                                                                        },
                                                                        placeholder: (context, url) =>
                                                                            const CustomLoader(),
                                                                        errorWidget: (context, url,
                                                                                error) =>
                                                                            Image.asset(
                                                                                "images/no_image.png"),
                                                                      ),
                                                                    ),

                                                                    /// username
                                                                    Container(
                                                                      alignment:
                                                                          Alignment.bottomCenter,
                                                                      margin: const EdgeInsets.only(
                                                                          left: 5, bottom: 5),
                                                                      child: Text(
                                                                        searchHashtagVideoProvider
                                                                            .hashtagVideos[index]
                                                                            .user!
                                                                            .name!,
                                                                        maxLines: 1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                              Constants.whitetext),
                                                                          fontSize: 14,
                                                                          fontFamily:
                                                                              Constants.appFont,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            /// views
                                                            Container(
                                                              margin: const EdgeInsets.only(
                                                                  left: 10, right: 0, bottom: 5),
                                                              alignment: Alignment.bottomLeft,
                                                              child: Text(
                                                                () {
                                                                  if (1 <
                                                                      int.parse(
                                                                          searchHashtagVideoProvider
                                                                              .hashtagVideos[index]
                                                                              .viewCount
                                                                              .toString())) {
                                                                    return "${searchHashtagVideoProvider.hashtagVideos[index].viewCount} Views";
                                                                  } else {
                                                                    return "${searchHashtagVideoProvider.hashtagVideos[index].viewCount} View";
                                                                  }
                                                                }(),
                                                                style: TextStyle(
                                                                    color:
                                                                        Color(Constants.whitetext),
                                                                    fontSize: 16,
                                                                    fontFamily: Constants.appFont),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                  staggeredTileBuilder: (int index) =>
                                                      StaggeredTile.count(
                                                          2, index.isEven ? 2.7 : 2.7),
                                                  mainAxisSpacing: 2.0,
                                                  crossAxisSpacing: 1.0,
                                                  crossAxisCount: 4,
                                                ),
                                              )
                                            : Align(
                                                alignment: Alignment.center,
                                                child: NoPostAvailable(
                                                  subject: 'Posts',
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
                            ],
                          ),
                        ),
                      ),
                      Container(padding: const EdgeInsets.only(bottom: 10), child: const Body()),
                    ],
                  ),
                );
              },
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

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomView(1),
    );
  }
}
