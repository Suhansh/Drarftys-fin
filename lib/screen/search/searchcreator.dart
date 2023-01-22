import 'package:provider/provider.dart';
import '/screen/search/search_creator_provider.dart';
import '/custom/customview.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/screen/search/searchhashtagvideolist.dart';
import '/screen/userprofile.dart';
import '/util/constants.dart';
import '/util/inndicator.dart';
import '../bottom_bar/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SearchCreatorScreen extends StatefulWidget {
  final String searched;

  const SearchCreatorScreen({Key? key, required this.searched}) : super(key: key);

  @override
  _SearchCreatorScreen createState() => _SearchCreatorScreen();
}

class _SearchCreatorScreen extends State<SearchCreatorScreen> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late SearchCreatorProvider searchCreatorProvider;
  TabController? controller;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    controller = TabController(length: 2, vsync: this);
    searchController.text = widget.searched;
    Provider.of<SearchCreatorProvider>(context, listen: false).getSearchFeatureBuilder =
        Provider.of<SearchCreatorProvider>(context, listen: false).getSearchItems(widget.searched);
    // getSearchFeatureBuilder = getSearchItems(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    searchCreatorProvider = Provider.of<SearchCreatorProvider>(context);
    dynamic screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: ModalProgressHUD(
              inAsyncCall: searchCreatorProvider.showSpinner,
              opacity: 1.0,
              color: Colors.transparent.withOpacity(0.2),
              progressIndicator: const CustomLoader(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          height: screenHeight,
                          margin: const EdgeInsets.only(bottom: 00),
                          color: Color(Constants.bgblack),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xFF1d1d1d),
                                  // color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset("images/greay_search.svg")),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                          color: Colors.transparent,
                                          child: TextFormField(
                                            controller: searchController,
                                            autofocus: false,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9a-zA-Z]")),
                                            ],
                                            style: TextStyle(
                                                color: Color(Constants.whitetext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            decoration: InputDecoration.collapsed(
                                              hintText: "Search Hashtags, Profile",
                                              hintStyle: TextStyle(
                                                  color: Color(Constants.hinttext),
                                                  fontSize: 14,
                                                  fontFamily: Constants.appFont),
                                              border: InputBorder.none,
                                            ),
                                            maxLines: 1,
                                            onFieldSubmitted: (String value) {
                                              if (value.isNotEmpty) {
                                                searchCreatorProvider.getSearchItems(value);
                                              } else {
                                                Constants.toastMessage(
                                                    "Please enter any character");
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              //tabs
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: TabBar(
                                    controller: controller,
                                    tabs: const [
                                      Tab(text: 'Creators'),
                                      Tab(text: 'Hashtags'),
                                    ],
                                    labelColor: Color(Constants.lightbluecolor),
                                    unselectedLabelColor: Colors.white,
                                    labelStyle:
                                        TextStyle(fontSize: 14, fontFamily: Constants.appFontBold),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding: const EdgeInsets.all(0.0),
                                    indicatorColor: Color(Constants.lightbluecolor),
                                    indicatorWeight: 5.0,
                                    indicator: MD2Indicator(
                                      indicatorSize: MD2IndicatorSize.full,
                                      indicatorHeight: 8.0,
                                      indicatorColor: Color(Constants.lightbluecolor),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FutureBuilder<int>(
                                  future: searchCreatorProvider.getSearchFeatureBuilder,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done:
                                        return 0 < snapshot.data!.toInt()
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10, right: 5, bottom: 90, left: 5),
                                                child: TabBarView(
                                                    controller: controller,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    children: <Widget>[
                                                      //Creator tab
                                                      searchCreatorProvider.creator.isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount: searchCreatorProvider
                                                                  .creator.length,
                                                              physics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              itemBuilder: (BuildContext context,
                                                                  int index) {
                                                                return Container(
                                                                  margin: const EdgeInsets.only(
                                                                      top: 20, left: 20),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      if (searchCreatorProvider
                                                                              .creator[index]
                                                                              .isYou ==
                                                                          1) {
                                                                        Navigator.of(context).push(
                                                                            MaterialPageRoute(
                                                                                builder:
                                                                                    (context) =>
                                                                                        BottomBar(
                                                                                            4)));
                                                                      } else {
                                                                        Navigator.of(context).push(
                                                                            MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    UserProfileScreen(
                                                                                      userId: searchCreatorProvider
                                                                                          .creator[
                                                                                              index]
                                                                                          .id,
                                                                                    )));
                                                                      }
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Container(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: (searchCreatorProvider
                                                                                          .creator[
                                                                                              index]
                                                                                          .imagePath ??
                                                                                      "") +
                                                                                  (searchCreatorProvider
                                                                                          .creator[
                                                                                              index]
                                                                                          .image ??
                                                                                      ""),
                                                                              imageBuilder: (context,
                                                                                      imageProvider) =>
                                                                                  CircleAvatar(
                                                                                radius: 25,
                                                                                backgroundColor:
                                                                                    const Color(
                                                                                        0xFF36446b),
                                                                                child: CircleAvatar(
                                                                                  radius: 25,
                                                                                  backgroundImage:
                                                                                      imageProvider,
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
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 5,
                                                                          child: Container(
                                                                            color:
                                                                                Colors.transparent,
                                                                            margin: const EdgeInsets
                                                                                    .only(
                                                                                top: 5, left: 5),
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child: ListView(
                                                                              shrinkWrap: true,
                                                                              physics:
                                                                                  const NeverScrollableScrollPhysics(),
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  searchCreatorProvider
                                                                                          .creator[
                                                                                              index]
                                                                                          .name ??
                                                                                      "",
                                                                                  maxLines: 1,
                                                                                  overflow:
                                                                                      TextOverflow
                                                                                          .visible,
                                                                                  style: TextStyle(
                                                                                      color: Color(
                                                                                          Constants
                                                                                              .whitetext),
                                                                                      fontFamily:
                                                                                          Constants
                                                                                              .appFont,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Text(
                                                                                  "${searchCreatorProvider.creator[index].followersCount} Followers",
                                                                                  maxLines: 1,
                                                                                  overflow:
                                                                                      TextOverflow
                                                                                          .visible,
                                                                                  style: TextStyle(
                                                                                      color: Color(
                                                                                          Constants
                                                                                              .greytext),
                                                                                      fontFamily:
                                                                                          Constants
                                                                                              .appFont,
                                                                                      fontSize: 14),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : NoPostAvailable(
                                                              subject: "User",
                                                            ),
                                                      //HashTag tab
                                                      searchCreatorProvider.hashtag.isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount: searchCreatorProvider
                                                                  .hashtag.length,
                                                              physics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              itemBuilder: (BuildContext context,
                                                                  int index) {
                                                                return Container(
                                                                  margin: const EdgeInsets.only(
                                                                      top: 20, left: 20),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context).push(
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  HashTagVideoListScreen(
                                                                                    hashtag:
                                                                                        searchCreatorProvider
                                                                                            .hashtag[
                                                                                                index]
                                                                                            .tag,
                                                                                    views: searchCreatorProvider
                                                                                        .hashtag[
                                                                                            index]
                                                                                        .use,
                                                                                  )));
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Container(
                                                                            margin: const EdgeInsets
                                                                                .only(left: 0),
                                                                            child: SvgPicture.asset(
                                                                                "images/hash_tag.svg"),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 6,
                                                                          child: Container(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            margin: const EdgeInsets
                                                                                    .only(
                                                                                left: 10, top: 5),
                                                                            child: ListView(
                                                                              shrinkWrap: true,
                                                                              physics:
                                                                                  const NeverScrollableScrollPhysics(),
                                                                              children: [
                                                                                Container(
                                                                                  alignment:
                                                                                      Alignment
                                                                                          .topLeft,
                                                                                  child: Text(
                                                                                    "\# ${searchCreatorProvider.hashtag[index].tag}",
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
                                                                                  alignment:
                                                                                      Alignment
                                                                                          .topLeft,
                                                                                  child: Text(
                                                                                    () {
                                                                                      if (1 <
                                                                                          int.parse(searchCreatorProvider
                                                                                              .hashtag[
                                                                                                  index]
                                                                                              .use
                                                                                              .toString())) {
                                                                                        return "${searchCreatorProvider.hashtag[index].use} Videos";
                                                                                      } else {
                                                                                        return "${searchCreatorProvider.hashtag[index].use} Video";
                                                                                      }
                                                                                    }(),
                                                                                    maxLines: 1,
                                                                                    overflow:
                                                                                        TextOverflow
                                                                                            .visible,
                                                                                    style: (TextStyle(
                                                                                        color: Color(
                                                                                            Constants
                                                                                                .greytext),
                                                                                        fontFamily:
                                                                                            Constants
                                                                                                .appFont,
                                                                                        fontSize:
                                                                                            16)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Container(
                                                                            margin: const EdgeInsets
                                                                                .only(right: 20),
                                                                            alignment: Alignment
                                                                                .centerRight,
                                                                            child: InkWell(
                                                                              onTap: () {
                                                                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchHistoryScreen()));
                                                                              },
                                                                              child: Container(
                                                                                margin:
                                                                                    const EdgeInsets
                                                                                            .only(
                                                                                        left: 5,
                                                                                        right: 5),
                                                                                child: SvgPicture
                                                                                    .asset(
                                                                                  "images/right_arrow.svg",
                                                                                  width:
                                                                                      ScreenUtil()
                                                                                          .setWidth(
                                                                                              20),
                                                                                  height:
                                                                                      ScreenUtil()
                                                                                          .setHeight(
                                                                                              20),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : NoPostAvailable(subject: "Hashtag"),
                                                    ]),
                                              )
                                            : NoPostAvailable(
                                                subject: "User",
                                              );
                                      case ConnectionState.none:
                                        return Container();
                                      case ConnectionState.waiting:
                                        return Container();
                                      case ConnectionState.active:
                                        return Container();
                                      default:
                                        return Container();
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
                  );
                },
              ),
            )),
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
