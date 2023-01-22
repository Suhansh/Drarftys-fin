import '/screen/my_profile/followers_list_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/screen/userprofile.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/util/inndicator.dart';
import '../initialize_screen.dart';

class FollowersListScreen extends StatefulWidget {
  final int index;
  final String followers;
  final String following;

  const FollowersListScreen(
      {Key? key,
      required this.index,
      required this.followers,
      required this.following})
      : super(key: key);

  @override
  _FollowersListScreen createState() => _FollowersListScreen();
}

class _FollowersListScreen extends State<FollowersListScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  late FollowersListProvider followersListProvider;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller!.animateTo(
        Provider.of<FollowersListProvider>(context, listen: false)
                .initialIndex ??
            0);
    Provider.of<FollowersListProvider>(context, listen: false).initialIndex =
        widget.index;
    Provider.of<FollowersListProvider>(context, listen: false).followers =
        widget.followers;
    Provider.of<FollowersListProvider>(context, listen: false).following =
        widget.following;
    Provider.of<FollowersListProvider>(context, listen: false)
            .followerPageTitle =
        Provider.of<FollowersListProvider>(context, listen: false)
                    .initialIndex ==
                0
            ? "Followers"
            : "Following";
    Constants.checkNetwork().whenComplete(() =>
        Provider.of<FollowersListProvider>(context, listen: false)
            .callApiForOwnFollowers());
  }

  @override
  Widget build(BuildContext context) {
    followersListProvider = Provider.of<FollowersListProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Text(followersListProvider.followerPageTitle),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          body: ModalProgressHUD(
            inAsyncCall: followersListProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          height: ScreenUtil().setHeight(50),
                          color: Colors.transparent,
                          child: Container(
                            height: ScreenUtil().setHeight(35),
                            color: Colors.transparent,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(1),
                              child: TabBar(
                                controller: controller,
                                onTap: (int value) {
                                  followersListProvider.searchController
                                      .clear();
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  controller!.index == 0
                                      ? followersListProvider
                                          .followerPageTitle = "Followers"
                                      : followersListProvider
                                          .followerPageTitle = "Following";
                                  followersListProvider.ownFollowersList =
                                      followersListProvider
                                          .tempOwnFollowersList;
                                  followersListProvider.ownFollowingList =
                                      followersListProvider
                                          .tempOwnFollowingList;
                                  setState(() {});
                                },
                                tabs: [
                                  Tab(
                                      text:
                                          'Followers(${followersListProvider.followers})'),
                                  Tab(
                                      text:
                                          'Following(${followersListProvider.following})'),
                                ],
                                labelColor: Color(Constants.lightbluecolor),
                                unselectedLabelColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Constants.appFontBold),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: const EdgeInsets.all(0.0),
                                indicatorColor: Color(Constants.lightbluecolor),
                                indicatorWeight: 5.0,
                                indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.full,
                                  indicatorHeight: 8.0,
                                  indicatorColor:
                                      Color(Constants.lightbluecolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(55),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: const Color(0xFF1d1d1d),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: SvgPicture.asset(
                                        "images/greay_search.svg")),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.transparent,
                                  child: TextField(
                                    controller:
                                        followersListProvider.searchController,
                                    onChanged: searchFollowerFollowing,
                                    autofocus: false,
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 14,
                                        fontFamily: Constants.appFont),
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Search Profile",
                                      hintStyle: TextStyle(
                                          color: Color(Constants.hinttext),
                                          fontSize: 14,
                                          fontFamily: Constants.appFont),
                                      border: InputBorder.none,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, right: 20, bottom: 0, left: 20),
                            child: TabBarView(
                                controller: controller,
                                physics: const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  /*followers*/
                                  ListView.separated(
                                    itemCount: followersListProvider
                                        .ownFollowersList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                        userId:
                                                            followersListProvider
                                                                .ownFollowersList[
                                                                    index]
                                                                .id,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: followersListProvider
                                                      .ownFollowersList[index]
                                                      .imagePath! +
                                                  followersListProvider
                                                      .ownFollowersList[index]
                                                      .image!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF36446b),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50)),
                                                  border: Border.all(
                                                    color: Color(Constants
                                                        .lightbluecolor),
                                                    width: 3.0,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      const Color(0xFF36446b),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CustomLoader(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                color: Colors.transparent,
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 0,
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        followersListProvider
                                                            .ownFollowersList[
                                                                index]
                                                            .name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Text(
                                                        "${followersListProvider.ownFollowersList[index].followersCount} Followers",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  if (followersListProvider
                                                          .ownFollowersList[
                                                              index]
                                                          .isFollowing ==
                                                      0) {
                                                    followersListProvider
                                                        .callApiForFollowBack(
                                                            followersListProvider
                                                                .ownFollowersList[
                                                                    index]
                                                                .id);
                                                  } else {
                                                    followersListProvider
                                                        .callApiForRemoveFromFollowers(
                                                            followersListProvider
                                                                .ownFollowersList[
                                                                    index]
                                                                .id);
                                                  }
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 5, right: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Color(
                                                                    Constants
                                                                        .lightbluecolor),
                                                                width: 2.5),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 2),
                                                          child: Text(
                                                            () {
                                                              if (followersListProvider
                                                                      .ownFollowersList[
                                                                          index]
                                                                      .isFollowing ==
                                                                  0) {
                                                                return "Follow Back";
                                                              } else {
                                                                return "Remove";
                                                              }
                                                            }(),
                                                            style: TextStyle(
                                                              color: Color(Constants
                                                                  .lightbluecolor),
                                                              fontSize: 14,
                                                              fontFamily: Constants
                                                                  .appFontBold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  /*following*/
                                  ListView.separated(
                                    itemCount: followersListProvider
                                        .ownFollowingList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 10,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                        userId:
                                                            followersListProvider
                                                                .ownFollowingList[
                                                                    index]
                                                                .id,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: followersListProvider
                                                      .ownFollowingList[index]
                                                      .imagePath! +
                                                  followersListProvider
                                                      .ownFollowingList[index]
                                                      .image!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF36446b),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(30)),
                                                  border: Border.all(
                                                    color: Color(Constants
                                                        .lightbluecolor),
                                                    width: 3.0,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      const Color(0xFF36446b),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CustomLoader(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "images/no_image.png"),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.transparent,
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 0,
                                                    bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        followersListProvider
                                                            .ownFollowingList[
                                                                index]
                                                            .name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .whitetext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Text(
                                                        "${followersListProvider.ownFollowingList[index].followersCount} Followers",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                Constants
                                                                    .appFont),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Constants.checkNetwork().whenComplete(() =>
                                                          followersListProvider
                                                              .callApiForUnFollowRequest(
                                                                  followersListProvider
                                                                      .ownFollowingList[
                                                                          index]
                                                                      .id));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 0,
                                                              bottom: 10),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            color: Color(Constants
                                                                .lightbluecolor),
                                                            width: 2.5),
                                                      ),
                                                      child: Text(
                                                        "Following",
                                                        style: TextStyle(
                                                          color: Color(Constants
                                                              .lightbluecolor),
                                                          fontSize: 14,
                                                          fontFamily: Constants
                                                              .appFontBold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          followersListProvider
                                                              .openFollowingMoreMenu(
                                                                  followersListProvider
                                                                      .ownFollowingList[
                                                                          index]
                                                                      .id,
                                                                  context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: 13,
                                                            left: 13,
                                                            right: 10,
                                                          ),
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/more_menu.svg",
                                                            width: ScreenUtil()
                                                                .setWidth(20),
                                                            height: ScreenUtil()
                                                                .setHeight(20),
                                                            color: Color(
                                                                Constants
                                                                    .greytext),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ]),
                          ),
                        ),
                      ],
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
    return await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InitializeScreen(4),
        ));
  }

  void searchFollowerFollowing(String searchingValue) {
    switch (controller!.index) {
      case 0:
        followersListProvider.ownFollowersList.clear();
        for (var userDetail in followersListProvider.tempOwnFollowersList) {
          if (userDetail.name!
              .toLowerCase()
              .contains(searchingValue.toLowerCase())) {
            setState(() {
              followersListProvider.ownFollowersList.add(userDetail);
            });
          }
        }
        break;
      case 1:
        followersListProvider.ownFollowingList.clear();
        for (var userDetail in followersListProvider.tempOwnFollowingList) {
          if (userDetail.name!
              .toLowerCase()
              .contains(searchingValue.toLowerCase())) {
            setState(() {
              followersListProvider.ownFollowingList.add(userDetail);
            });
          }
        }
        break;
      default:
        break;
    }
  }
}
