import '/custom/loader_custom_widget.dart';
import '/screen/chat/chat_history_screen.dart';
import '/screen/followandinvite.dart';
import '/screen/following/following.dart';
import '/screen/initialize_screen.dart';
import '/screen/nearby/nearby.dart';
import '../setting/setting.dart';
import '/screen/trending/trending.dart';
import '/util/constants.dart';
import '/util/inndicator.dart';
import '/util/preference_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../login_screen.dart';
import 'homepage_provider.dart';

//ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  late HomepageProvider homepageProvider;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    homepageProvider = Provider.of<HomepageProvider>(context);
    dynamic screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.only(bottom: 00),
                height: screenHeight,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.black,
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 20, top: 0),
                              child: InkWell(
                                onTap: () {
                                  if (kDebugMode) {
                                    print(homepageProvider.showMenu);
                                  }
                                  homepageProvider.changeShowMenuStatus();
                                },
                                child: homepageProvider.showMenu == false
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child:
                                            SvgPicture.asset("images/menu.svg"),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset(
                                            "images/menu_close.svg"),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 10, top: 0),
                              child: TabBar(
                                controller: _controller,
                                labelPadding: EdgeInsets.zero,
                                tabs: [
                                  /// Trending
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: const Tab(
                                      text: 'Trending',
                                    ),
                                  ),

                                  /// Follow
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: const Tab(
                                      text: 'Follow',
                                    ),
                                  ),

                                  /// Nearby
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 70,
                                    ),
                                    child: const Tab(
                                      text: 'Nearby',
                                    ),
                                  ),
                                ],
                                labelColor: Color(Constants.lightbluecolor),
                                unselectedLabelColor: Colors.white,
                                labelStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat'),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: const EdgeInsets.all(0.0),
                                indicatorColor: Color(Constants.lightbluecolor),
                                indicatorWeight: 5.0,
                                indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.full,
                                  indicatorHeight: 8.0,
                                  indicatorColor:Color(Constants.lightbluecolor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TabBarView(
                          controller: _controller,
                          children: const <Widget>[
                            TrendingScreen(),
                            FollowingScreen(),
                            NearByScreen(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: homepageProvider.showMenu,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                // height: ScreenUtil().setHeight(170),
                color: Color(Constants.bgblack),
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///view profile
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        onTap: () {
                          homepageProvider.changeShowMenuStatus();
                          if (PreferenceUtils.getBool(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InitializeScreen(4)));
                          } else {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    ));
                          }
                        },
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: PreferenceUtils.getString(Constants.image)
                                  .isEmpty
                              ? CircleAvatar(
                                  radius: 17,
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0)),
                                      child: Image.asset(
                                          "images/profilepicDemo.jpg")))
                              : CachedNetworkImage(
                                  alignment: Alignment.center,
                                  imageUrl: PreferenceUtils.getString(
                                      Constants.image),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 17,
                                    backgroundColor: const Color(0xFF36446b),
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CustomLoader(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("images/no_image.png"),
                                ),
                        ),
                        title: Text(
                          "View Profile",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),

                    ///settings
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        onTap: () {
                          homepageProvider.changeShowMenuStatus();

                          if (PreferenceUtils.getBool(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
                          } else {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    ));
                          }
                        },
                        leading: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15),
                            child: SvgPicture.asset("images/settings.svg")),
                        title: Text(
                          "Settings",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),

                    ///discover people
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        onTap: () {
                          homepageProvider.changeShowMenuStatus();

                          if (PreferenceUtils.getBool(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const FollowAndInviteScreen()));
                          } else {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    ));
                          }
                        },
                        leading: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15),
                            child: SvgPicture.asset("images/follow.svg")),
                        title: Text(
                          "Discover People",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),

                    ///saved post
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        onTap: () {
                          homepageProvider.changeShowMenuStatus();

                          if (PreferenceUtils.getBool(Constants.isLoggedIn) ==
                              true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ChatHistoryScreen()));
                          } else {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    ));
                          }
                        },
                        leading: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15),
                            child: SvgPicture.asset(
                              "images/chat_icon.svg",
                              width: 23,
                              height: 23,
                              color: Colors.white,
                            )),
                        title: Text(
                          "Chats",
                          style: TextStyle(
                              color: Color(Constants.whitetext),
                              fontSize: 16,
                              fontFamily: Constants.appFontBold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
