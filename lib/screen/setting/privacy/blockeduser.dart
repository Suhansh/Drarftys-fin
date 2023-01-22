import '/screen/setting/privacy/blocked_user_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BlockedUserScreen extends StatefulWidget {
  const BlockedUserScreen({Key? key}) : super(key: key);

  @override
  _BlockedUserScreen createState() => _BlockedUserScreen();
}

class _BlockedUserScreen extends State<BlockedUserScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late BlockedUserProvider blockedUserProvider;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Constants.checkNetwork().whenComplete(() => Provider.of<BlockedUserProvider>(context,listen: false).callApiForBlockUserList());
    }
  }

  @override
  Widget build(BuildContext context) {
    blockedUserProvider = Provider.of<BlockedUserProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                  margin: const EdgeInsets.only(left: 10), child: const Text("Blocked Users")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: RefreshIndicator(
              color: Color(Constants.lightbluecolor),
              backgroundColor: Colors.white,
              onRefresh: blockedUserProvider.callApiForBlockUserList,
              key: _refreshIndicatorKey,
              child: ModalProgressHUD(
                inAsyncCall: blockedUserProvider.showSpinner,
                opacity: 1.0,
                color: Colors.transparent.withOpacity(0.2),
                progressIndicator: const CustomLoader(),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0, right: 10),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 0, right: 10),
                                  height: ScreenUtil().setHeight(50),
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
                                            child: SvgPicture.asset("images/greay_search.svg")),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            color: Colors.transparent,
                                            child: TextField(
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
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                  child: Text(
                                    "You can not see the profile of which user you blocked, and you will be can't receive any kind of updates from these users. If you want to receive all notifications and posts from users just UNBLOCK the user. ",
                                    maxLines: 8,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Color(Constants.greytext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                                  child: Text(
                                    "Blocked Users",
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 16),
                                  ),
                                ),
                                Visibility(
                                  visible: blockedUserProvider.showData,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                                    child: ListView.separated(
                                      itemCount: blockedUserProvider.blockUserList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) => const SizedBox(
                                        height: 10,
                                      ),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            // margin:
                                            //     EdgeInsets.only(bottom: 10),
                                            // width:
                                            //     ScreenUtil().setWidth(50),
                                            // height:
                                            //     ScreenUtil().setHeight(50),
                                            CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: blockedUserProvider.blockUserList[index].imagePath! +
                                                  blockedUserProvider.blockUserList[index].image!,
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF36446b),
                                                  borderRadius:
                                                      const BorderRadius.all(Radius.circular(50)),
                                                  border: Border.all(
                                                    color: Color(Constants.lightbluecolor),
                                                    width: 3.0,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: const Color(0xFF36446b),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: imageProvider,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => const CustomLoader(),
                                              errorWidget: (context, url, error) =>
                                                  Image.asset("images/no_image.png"),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                color: Colors.transparent,
                                                margin: const EdgeInsets.only(
                                                    left: 10, top: 0, bottom: 5),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        blockedUserProvider.blockUserList[index].name!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Color(Constants.whitetext),
                                                            fontSize: 14,
                                                            fontFamily: Constants.appFont),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.only(top: 0),
                                                      child: Text(
                                                        blockedUserProvider.blockUserList[index].userId!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Color(Constants.greytext),
                                                            fontSize: 14,
                                                            fontFamily: Constants.appFont),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin: const EdgeInsets.only(bottom: 15),
                                                  alignment: Alignment.topCenter,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(left: 5, right: 10),
                                                      alignment: Alignment.center,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Constants.checkNetwork().whenComplete(
                                                              () => blockedUserProvider.callApiForUnBlockUser(
                                                                  blockedUserProvider.blockUserList[index].id));
                                                        },
                                                        child: Container(
                                                          margin: const EdgeInsets.only(left: 2),
                                                          child: Text(
                                                            "Unblock",
                                                            style: TextStyle(
                                                                color:
                                                                    Color(Constants.lightbluecolor),
                                                                fontSize: 16,
                                                                fontFamily: Constants.appFont),
                                                          ),
                                                        ),
                                                      ))),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: blockedUserProvider.noData,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: ScreenUtil().setHeight(80),
                                          margin: const EdgeInsets.only(
                                              top: 100.0, left: 15.0, right: 15, bottom: 0),
                                          child: Text(
                                            "No Data Available !",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: Constants.appFont,
                                                fontSize: 20),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
