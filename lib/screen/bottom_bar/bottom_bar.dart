import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../custom/loader_custom_widget.dart';
import '../../util/advertise/banner_ad.dart';
import '../../util/constants.dart';
import '../../util/preference_utils.dart';
import '../homepage/homepage.dart';
import '../login_screen.dart';
import '../my_profile/myprofile.dart';
import '../notification/notification.dart';
import '../search/searchscreen.dart';
import '../upload_video/uploadvideo.dart';
import 'bottom_bar_provider.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart'
    as facebookLib;

//ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  int _currentIndex;

  BottomBar(this._currentIndex, {Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late BottomBarProvider bottomBarProvider;
  final List<Widget> _children = [
    const MyHomePage(),
    const SearchScreen(),
    Container(color: Colors.black),
    const NotificationScreen(),
    const MyProfileScreen(),
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   bottomBarProvider=Provider.of<BottomBarProvider>(context,listen: false);
  //   bottomBarProvider.bottomBarInit();
  // }

  @override
  Widget build(BuildContext context) {
    bottomBarProvider = Provider.of<BottomBarProvider>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          body: _children[widget._currentIndex],
          bottomNavigationBar: Container(
            // if one ad show then height is 120px
            // height: dynamicAdSize,
            // height: ScreenUtil().setHeight(dynamicAdSize),
            // color: Color(Constants.greytext),
            color: Color(Constants.bgblack),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: onTabTapped,
                  selectedItemColor: Colors.green,
                  unselectedItemColor: Colors.white,
                  selectedLabelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontFamily: Constants.appFont),
                  unselectedLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: Constants.appFont),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Color(Constants.bgblack),
                  currentIndex: widget._currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_home.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset("images/tab_home.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_search.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset("images/tab_search.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "images/tab_add_new.svg",
                      ),
                      activeIcon: SvgPicture.asset("images/tab_add_new.svg"),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("images/tab_notification.svg",
                          color: Color(Constants.whitetext)),
                      activeIcon: SvgPicture.asset(
                          "images/tab_notification.svg",
                          color: Color(Constants.lightbluecolor)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: PreferenceUtils.getString(Constants.image).isEmpty
                          ? CircleAvatar(
                              radius: 17,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child:
                                      Image.asset("images/profilepicDemo.jpg")))
                          : CachedNetworkImage(
                              alignment: Alignment.center,
                              imageUrl:PreferenceUtils.getString(Constants.image),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    radius: 17,
                                    // backgroundColor: const Color(0xFF36446b),
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  const CustomLoader(),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                      radius: 17,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0)),
                                          child: Image.asset(
                                              "images/profilepicDemo.jpg")))),
                      activeIcon: PreferenceUtils.getString(Constants.image)
                              .isEmpty
                          ? CircleAvatar(
                              radius: 17,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child:
                                      Image.asset("images/profilepicDemo.jpg")))
                          : CachedNetworkImage(
                              alignment: Alignment.center,
                              imageUrl:
                                  PreferenceUtils.getString(Constants.image),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    radius: 17,
                                    // backgroundColor: const Color(0xFF36446b),
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  const CustomLoader(),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                      radius: 17,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0)),
                                          child: Image.asset(
                                              "images/profilepicDemo.jpg")))),
                      label: "",
                    ),
                  ],
                ),
                if (bottomBarProvider.adMobAds)
                  /// admobb
                  AnchoredAdaptiveExample(),
                /*facebook*/
                if (bottomBarProvider.facebookAds)
                  Container(
                    alignment: const Alignment(0.5, 1),
                    child: FacebookBannerAd(
                      placementId: Platform.isAndroid
                          ? PreferenceUtils.getString(
                              Constants.facebookPlaceIdForBanner)
                          : PreferenceUtils.getString(
                              Constants.facebookPlaceIdForBanner),
                      bannerSize: facebookLib.BannerSize.STANDARD,
                      listener: (result, value) {
                        bottomBarProvider.handleEventForFacebookAds(
                            result, value);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if (PreferenceUtils.getBool(Constants.isLoggedIn) == false ||
        PreferenceUtils.getBool(Constants.isLoggedIn) == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadVideoScreen()),
        );
      }
      setState(() {
        widget._currentIndex = index;
      });
    }
  }
}
