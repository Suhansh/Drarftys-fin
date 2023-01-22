import '/screen/my_profile/my_profile_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import '/util/inndicator.dart';
import '/screen/own_post/ownpost.dart';
import '../setting/setting.dart';
import '../edit_profile/edit_profile.dart';
import '../upload_video/uploadvideo.dart';
import 'followerslist.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreen createState() => _MyProfileScreen();
}

class _MyProfileScreen extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late MyProfileProvider myProfileProvider;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    Provider.of<MyProfileProvider>(context, listen: false)
        .callApiForGetProfile(isShowLoader: true);
  }

  @override
  Widget build(BuildContext context) {
    myProfileProvider = Provider.of<MyProfileProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: myProfileProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: RefreshIndicator(
              color: Color(Constants.lightbluecolor),
              backgroundColor: Colors.white,
              onRefresh: () {
                return myProfileProvider.callApiForGetProfile(
                    isShowLoader: true);
              },
              key: _refreshIndicatorKey,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: Color(Constants.bgblack),
                    title: Text(
                      myProfileProvider.username!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(this.context).push(MaterialPageRoute(
                                  builder: (context) => UploadVideoScreen()));
                            },
                            child: SvgPicture.asset("images/pluse.svg")),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(this.context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()));
                            },
                            child: SvgPicture.asset("images/edit_profile.svg")),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0, right: 10),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(this.context).push(MaterialPageRoute(
                                  builder: (context) => SettingsScreen(
                                        userId: myProfileProvider.userId,
                                      )));
                            },
                            child: SvgPicture.asset("images/settings.svg")),
                      ),
                    ],
                    elevation: 0.0,
                    expandedHeight: 260,
                    floating: true,
                    stretch: true,
                    snap: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      background: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(120),
                              margin: const EdgeInsets.only(bottom: 10),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 10, left: 10),
                                      child: myProfileProvider.showSpinner
                                          ? const CustomLoader()
                                          : CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: myProfileProvider.image,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                radius: 45,
                                                backgroundColor:
                                                    const Color(0xFF36446b),
                                                child: CircleAvatar(
                                                  radius: 45,
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
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                          right: 20, top: 10, left: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 30),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              myProfileProvider.name!,
                                              maxLines: 5,
                                              style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 16,
                                                fontFamily: Constants.appFont,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 0, top: 20, left: 0),
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(this.context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FollowersListScreen(
                                                            index: 0,
                                                            followers:
                                                                myProfileProvider
                                                                    .followers,
                                                            following:
                                                                myProfileProvider
                                                                    .following,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          myProfileProvider
                                                              .followers,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontFamily: Constants
                                                                  .appFontBold,
                                                              fontSize: 16),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          "Followers",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(this.context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FollowersListScreen(
                                                                    index: 1,
                                                                    followers:
                                                                        myProfileProvider
                                                                            .followers,
                                                                    following:
                                                                        myProfileProvider
                                                                            .following,
                                                                  )));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          myProfileProvider
                                                              .following,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  Constants
                                                                      .whitetext),
                                                              fontFamily: Constants
                                                                  .appFontBold,
                                                              fontSize: 16),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          "Following",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        myProfileProvider
                                                            .totalPost,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontFamily: Constants
                                                                .appFontBold,
                                                            fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        "Posts",
                                                        textAlign:
                                                            TextAlign.center,
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
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                myProfileProvider.bio!,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontSize: 16,
                                  fontFamily: Constants.appFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          color: Color(Constants.bgblack),
                          // color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(1),
                            child: TabBar(
                              controller: _controller,
                              tabs: const [
                                Tab(text: 'Posts'),
                                Tab(text: 'Saved'),
                                Tab(text: 'Liked'),
                              ],
                              labelColor: Color(Constants.lightbluecolor),
                              unselectedLabelColor: Colors.white,
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: Constants.appFontBold),
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
                        preferredSize: const Size(
                            double.infinity, kBottomNavigationBarHeight + 30)),
                  ),
                ],
                body: Container(
                  margin: const EdgeInsets.only(
                      top: 10, right: 5, bottom: 0, left: 5),
                  child: FutureBuilder<int>(
                    future: myProfileProvider.profileFuture,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return 0 < (snapshot.data?.toInt() ?? 0)
                              ? TabBarView(
                                  controller: _controller,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: <Widget>[
                                      /// posts
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child:
                                            myProfileProvider
                                                    .postList.isNotEmpty
                                                ? StaggeredGridView
                                                    .countBuilder(
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    itemCount: myProfileProvider
                                                        .postList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (myProfileProvider
                                                              .postList[index]
                                                              .isLike ==
                                                          true) {
                                                        myProfileProvider
                                                            .postList[index]
                                                            .showred = true;
                                                        myProfileProvider
                                                            .postList[index]
                                                            .showwhite = false;
                                                      } else {
                                                        myProfileProvider
                                                            .postList[index]
                                                            .showred = false;
                                                        myProfileProvider
                                                            .postList[index]
                                                            .showwhite = true;
                                                      }
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(
                                                                  this.context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OwnPostScreen(myProfileProvider
                                                                          .postList[
                                                                              index]
                                                                          .id)))
                                                              .then((value) {
                                                            myProfileProvider
                                                                .callApiForGetProfile(
                                                                    isShowLoader:
                                                                        false);
                                                            _controller!
                                                                .animateTo(0);
                                                          });
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
                                                                imageUrl: myProfileProvider
                                                                        .postList[
                                                                            index]
                                                                        .imagePath! +
                                                                    myProfileProvider
                                                                        .postList[
                                                                            index]
                                                                        .screenshot!,
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                        "images/no_image.png"),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 10,
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      myProfileProvider.openPostBottomSheet(
                                                                          myProfileProvider
                                                                              .postList[
                                                                                  index]
                                                                              .id,
                                                                          myProfileProvider.postList[index].imagePath! +
                                                                              myProfileProvider.postList[index].video!,
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "images/more_menu.svg",
                                                                        width: ScreenUtil()
                                                                            .setWidth(20),
                                                                        height:
                                                                            ScreenUtil().setHeight(20),
                                                                      ),
                                                                    )),
                                                              ),
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "images/play_button.svg",
                                                                  width: 50,
                                                                  height: 50,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            0,
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
                                                                            Alignment.bottomLeft,
                                                                        padding:
                                                                            const EdgeInsets.all(4),
                                                                        child:
                                                                            Text(
                                                                          () {
                                                                            if (1 <
                                                                                int.parse(myProfileProvider.postList[index].viewCount.toString())) {
                                                                              return "${myProfileProvider.postList[index].viewCount.toString()} Views";
                                                                            } else {
                                                                              return "${myProfileProvider.postList[index].viewCount.toString()} View";
                                                                            }
                                                                          }(),
                                                                          style: TextStyle(
                                                                              color: Color(Constants.whitetext),
                                                                              fontSize: 14,
                                                                              fontFamily: Constants.appFont),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.bottomRight,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            children: [
                                                                              Visibility(
                                                                                visible: myProfileProvider.postList[index].showwhite,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(4),
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      myProfileProvider.callApiForLikedVideo(myProfileProvider.postList[index].id, context);
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      "images/white_heart.svg",
                                                                                      width: 15,
                                                                                      height: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                visible: myProfileProvider.postList[index].showred,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(4),
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      myProfileProvider.callApiForLikedVideo(myProfileProvider.postList[index].id, context);
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      "images/red_heart.svg",
                                                                                      width: 15,
                                                                                      height: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                    staggeredTileBuilder:
                                                        (int index) =>
                                                            StaggeredTile.count(
                                                                1,
                                                                index.isEven
                                                                    ? 1.5
                                                                    : 1.5),
                                                    mainAxisSpacing: 1.0,
                                                    crossAxisSpacing: 1.0,
                                                  )
                                                : NoPostAvailable(
                                                    subject: "Post"),
                                      ),

                                      /// saved
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child:
                                            myProfileProvider
                                                    .savedList.isNotEmpty
                                                ? StaggeredGridView
                                                    .countBuilder(
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    itemCount: myProfileProvider
                                                        .savedList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (myProfileProvider
                                                              .savedList[index]
                                                              .video!
                                                              .isLike ==
                                                          true) {
                                                        myProfileProvider
                                                            .savedList[index]
                                                            .video!
                                                            .showred = true;
                                                        myProfileProvider
                                                            .savedList[index]
                                                            .video!
                                                            .showwhite = false;
                                                      } else {
                                                        myProfileProvider
                                                            .savedList[index]
                                                            .video!
                                                            .showred = false;
                                                        myProfileProvider
                                                            .savedList[index]
                                                            .video!
                                                            .showwhite = true;
                                                      }

                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(
                                                                  this.context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) => OwnPostScreen(myProfileProvider
                                                                          .savedList[
                                                                              index]
                                                                          .video
                                                                          ?.id ??
                                                                      0)))
                                                              .then((value) {
                                                            myProfileProvider
                                                                .callApiForGetProfile(
                                                                    isShowLoader:
                                                                        false);
                                                            _controller!
                                                                .animateTo(1);
                                                          });
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
                                                                  imageUrl: myProfileProvider
                                                                          .savedList[
                                                                              index]
                                                                          .video!
                                                                          .imagePath! +
                                                                      myProfileProvider
                                                                          .savedList[
                                                                              index]
                                                                          .video!
                                                                          .screenshot!,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        alignment:
                                                                            Alignment.topCenter,
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
                                                                          "images/no_image.png"),
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 10,
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        myProfileProvider.openSavedBottomSheet(
                                                                            myProfileProvider.savedList[index].video!.id,
                                                                            myProfileProvider.savedList[index].video!.user!.id,
                                                                            myProfileProvider.savedList[index].video!.imagePath! + myProfileProvider.savedList[index].video!.video!,
                                                                            (myProfileProvider.savedList[index].video?.id.toString() ?? ""),
                                                                            context);
                                                                      },
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              5.0,
                                                                        ),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "images/more_menu.svg",
                                                                          width:
                                                                              ScreenUtil().setWidth(20),
                                                                          height:
                                                                              ScreenUtil().setHeight(20),
                                                                        ),
                                                                      )),
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/play_button.svg",
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 0,
                                                                      bottom:
                                                                          5),
                                                                  alignment:
                                                                      Alignment
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
                                                                              Alignment.bottomLeft,
                                                                          child:
                                                                              Text(
                                                                            () {
                                                                              if (1 < int.parse(myProfileProvider.savedList[index].video!.viewCount.toString())) {
                                                                                return "${myProfileProvider.savedList[index].video!.viewCount.toString()} Views";
                                                                              } else {
                                                                                return "${myProfileProvider.savedList[index].video!.viewCount.toString()} View";
                                                                              }
                                                                            }(),
                                                                            style: TextStyle(
                                                                                color: Color(Constants.whitetext),
                                                                                fontSize: 14,
                                                                                fontFamily: Constants.appFont),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                ListView(
                                                                              shrinkWrap: true,
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              children: [
                                                                                Visibility(
                                                                                  visible: myProfileProvider.savedList[index].video!.showwhite,
                                                                                  child: InkWell(
                                                                                      onTap: () {
                                                                                        Constants.checkNetwork().whenComplete(() => myProfileProvider.callApiForLikedVideo(myProfileProvider.savedList[index].video!.id, context));
                                                                                      },
                                                                                      child: SvgPicture.asset(
                                                                                        "images/white_heart.svg",
                                                                                        width: 15,
                                                                                        height: 15,
                                                                                      )),
                                                                                ),
                                                                                Visibility(
                                                                                  visible: myProfileProvider.savedList[index].video!.showred,
                                                                                  child: InkWell(
                                                                                      onTap: () {
                                                                                        Constants.checkNetwork().whenComplete(() => myProfileProvider.callApiForLikedVideo(myProfileProvider.savedList[index].video!.id, context));
                                                                                      },
                                                                                      child: SvgPicture.asset(
                                                                                        "images/red_heart.svg",
                                                                                        width: 15,
                                                                                        height: 15,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      );
                                                    },
                                                    staggeredTileBuilder:
                                                        (int index) =>
                                                            StaggeredTile.count(
                                                                1,
                                                                index.isEven
                                                                    ? 1.5
                                                                    : 1.5),
                                                    mainAxisSpacing: 1.0,
                                                    crossAxisSpacing: 1.0,
                                                  )
                                                : NoPostAvailable(
                                                    subject: "Saved Post"),
                                      ),

                                      /// liked
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                            top: 0),
                                        child:
                                            myProfileProvider
                                                    .likedList.isNotEmpty
                                                ? StaggeredGridView
                                                    .countBuilder(
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    itemCount: myProfileProvider
                                                        .likedList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (myProfileProvider
                                                              .likedList[index]
                                                              .video!
                                                              .isLike ==
                                                          true) {
                                                        myProfileProvider
                                                            .likedList[index]
                                                            .video!
                                                            .showred = true;
                                                        myProfileProvider
                                                            .likedList[index]
                                                            .video!
                                                            .showwhite = false;
                                                      } else {
                                                        myProfileProvider
                                                            .likedList[index]
                                                            .video!
                                                            .showred = false;
                                                        myProfileProvider
                                                            .likedList[index]
                                                            .video!
                                                            .showwhite = true;
                                                      }
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(
                                                                  this.context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OwnPostScreen(myProfileProvider
                                                                          .likedList[
                                                                              index]
                                                                          .video!
                                                                          .id)))
                                                              .then((value) {
                                                            myProfileProvider
                                                                .callApiForGetProfile(
                                                                    isShowLoader:
                                                                        false);
                                                            _controller!
                                                                .animateTo(2);
                                                          });
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
                                                                  imageUrl: myProfileProvider
                                                                          .likedList[
                                                                              index]
                                                                          .video!
                                                                          .imagePath! +
                                                                      myProfileProvider
                                                                          .likedList[
                                                                              index]
                                                                          .video!
                                                                          .screenshot!,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        alignment:
                                                                            Alignment.topCenter,
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
                                                                          "images/no_image.png"),
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/play_button.svg",
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 0,
                                                                      bottom:
                                                                          5),
                                                                  alignment:
                                                                      Alignment
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
                                                                              Alignment.bottomLeft,
                                                                          child:
                                                                              Text(
                                                                            () {
                                                                              if (1 < int.parse(myProfileProvider.likedList[index].video!.viewCount.toString())) {
                                                                                return "${myProfileProvider.likedList[index].video!.viewCount.toString()} Views";
                                                                              } else {
                                                                                return "${myProfileProvider.likedList[index].video!.viewCount.toString()} View";
                                                                              }
                                                                            }(),
                                                                            style: TextStyle(
                                                                                color: Color(Constants.whitetext),
                                                                                fontSize: 14,
                                                                                fontFamily: Constants.appFont),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                ListView(
                                                                              shrinkWrap: true,
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              children: [
                                                                                Visibility(
                                                                                  visible: true,
                                                                                  child: InkWell(
                                                                                      onTap: () {
                                                                                        Constants.checkNetwork().whenComplete(() => myProfileProvider.callApiForLikedVideo(myProfileProvider.savedList[index].video!.id, context));
                                                                                      },
                                                                                      child: SvgPicture.asset(
                                                                                        "images/red_heart.svg",
                                                                                        width: 15,
                                                                                        height: 15,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      );
                                                    },
                                                    staggeredTileBuilder:
                                                        (int index) =>
                                                            StaggeredTile.count(
                                                                1,
                                                                index.isEven
                                                                    ? 1.5
                                                                    : 1.5),
                                                    mainAxisSpacing: 1.0,
                                                    crossAxisSpacing: 1.0,
                                                  )
                                                : NoPostAvailable(
                                                    subject: "Liked Post"),
                                      ),
                                    ])
                              : Align(
                                  alignment: Alignment.center,
                                  child: NoPostAvailable(
                                    subject: "Post",
                                  ),
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
              ),
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
