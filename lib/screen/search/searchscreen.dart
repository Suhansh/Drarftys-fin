import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../advertisement_provider/ad_helper.dart';
import '../../util/advertise/inline_adaptive_example.dart';
import '/custom/loader_custom_widget.dart';
import '/screen/search/searchhashtagvideolist.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screen/search/searchhistory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late SearchProvider searchProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          body: ModalProgressHUD(
            inAsyncCall: searchProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, right: 10),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            ///search
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              height: ScreenUtil().setHeight(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Color(Constants.conbg),
                                // color: Colors.white,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchHistoryScreen()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                              "images/greay_search.svg")),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Text(
                                            "Search Hashtags, Profile",
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.greytext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            maxLines: 1,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ///banners
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(200),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: ScreenUtil().setHeight(200),
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, index1) {
                                        searchProvider.current = index;
                                        searchProvider.notify();
                                      },
                                    ),
                                    items: searchProvider.imgList.map((it) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: <Widget>[
                                                Material(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  elevation: 2.0,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  type:
                                                      MaterialType.transparency,
                                                  child: CachedNetworkImage(
                                                    imageUrl: it,
                                                    fit: BoxFit.fill,
                                                    height: ScreenUtil()
                                                        .setHeight(200),
                                                    width: ScreenUtil()
                                                        .setWidth(500),
                                                    placeholder: (context,
                                                            url) =>
                                                        const CustomLoader(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            "images/no_image.png"),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: List.generate(
                                                      searchProvider
                                                          .imgList.length,
                                                      (index) => Container(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        width: 9.0,
                                                        height: 9.0,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: searchProvider
                                                                      .current ==
                                                                  index
                                                              ? Color(Constants
                                                                  .lightbluecolor)
                                                              : const Color(
                                                                  0xFFffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            //defaultHashtags
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: searchProvider.mainHashtags.length,
                              itemBuilder: (context, index) {
                                if (searchProvider.adMobNative == true) {
                                  if (index != 0 && index % 3 == 0) {
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),

                                        /// admobb
                                        child: InlineAdaptiveExample());
                                  }
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HashTagVideoListScreen(
                                                  hashtag: searchProvider
                                                      .mainHashtags[index]
                                                      .title,
                                                  views: searchProvider
                                                      .mainHashtags[index].views
                                                      .toString(),
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // hashtags row
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        height: ScreenUtil().setHeight(57),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                child: SvgPicture.asset(
                                                    "images/hash_tag.svg"),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: searchProvider
                                                          .mainHashtags[index]
                                                          .trending ==
                                                      1
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "\#${searchProvider.mainHashtags[index].title}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: (TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .whitetext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .appFont,
                                                                  fontSize:
                                                                      16)),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Trending",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: (TextStyle(
                                                                  color: Color(
                                                                      Constants
                                                                          .hinttext),
                                                                  fontFamily:
                                                                      Constants
                                                                          .appFont,
                                                                  fontSize:
                                                                      16)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 10,
                                                        top: 15,
                                                      ),
                                                      child: Text(
                                                        "\# ${searchProvider.mainHashtags[index].title}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: (TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily:
                                                                Constants
                                                                    .appFont,
                                                            fontSize: 16)),
                                                      ),
                                                    ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      () {
                                                        if (1 <
                                                            int.parse(searchProvider
                                                                .mainHashtags[
                                                                    index]
                                                                .views
                                                                .toString())) {
                                                          return "${searchProvider.mainHashtags[index].views} Views";
                                                        } else {
                                                          return "${searchProvider.mainHashtags[index].views} View";
                                                        }
                                                      }(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                          color: Color(Constants
                                                              .lightbluecolor),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFont),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      child: SvgPicture.asset(
                                                        "images/right_arrow.svg",
                                                        width: ScreenUtil()
                                                            .setWidth(20),
                                                        height: ScreenUtil()
                                                            .setHeight(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //hashtag videos
                                      if (0 <
                                          searchProvider.mainHashtags[index]
                                              .videos.length)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          height: ScreenUtil().setHeight(170),
                                          child: ListView.builder(
                                            itemCount: searchProvider
                                                .mainHashtags[index]
                                                .videos
                                                .length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int subIndex) {
                                              return Padding(
                                                padding: EdgeInsets.all(
                                                    ScreenUtil().setWidth(5)),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: searchProvider
                                                              .mainHashtags[
                                                                  index]
                                                              .videos[subIndex]
                                                              .imagePath +
                                                          searchProvider
                                                              .mainHashtags[
                                                                  index]
                                                              .videos[subIndex]
                                                              .screenshot,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: ScreenUtil()
                                                            .setWidth(100),
                                                        height: ScreenUtil()
                                                            .setHeight(150),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill,
                                                            alignment: Alignment
                                                                .topCenter,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          const CustomLoader(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              "images/no_image.png"),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SvgPicture.asset(
                                                        "images/play_button.svg",
                                                        width: ScreenUtil()
                                                            .setWidth(50),
                                                        height: ScreenUtil()
                                                            .setHeight(50),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      else
                                        Container(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
