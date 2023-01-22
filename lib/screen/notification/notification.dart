import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/custom/no_post_available.dart';
import '/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../userprofile.dart';
import 'notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  late NotificationProvider notificationProvider;

  // void handleClick(String value) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => const FollowRequestScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    notificationProvider = Provider.of<NotificationProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(Constants.bgblack),
          appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text("Notification")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            // actions: <Widget>[],
          ),
          body: ModalProgressHUD(
            inAsyncCall: notificationProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    FutureBuilder<int>(
                      future: notificationProvider.notificationFuture,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return RefreshIndicator(
                              color: Color(Constants.lightbluecolor),
                              backgroundColor: Colors.white,
                              onRefresh:
                                  notificationProvider.callApiForNotification,
                              child: ListView(
                                children: [
                                  if (0 < snapshot.data!.toInt())
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(0)),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: const EdgeInsets.only(
                                                bottom: 0,
                                                left: 28,
                                                right: 15,
                                                top: 15),
                                            child: Text(
                                              "N E W",
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontFamily: Constants.appFont,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(8)),
                                          child:
                                              notificationProvider
                                                      .currentList.isNotEmpty
                                                  ? ListView.separated(
                                                      itemCount:
                                                          notificationProvider
                                                              .currentList
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                                  height: 10.0),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UserProfileScreen(
                                                                  userId: notificationProvider
                                                                      .currentList[
                                                                          index]
                                                                      .user!
                                                                      .id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 0,
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                ///userImage
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    imageUrl: notificationProvider
                                                                            .currentList[
                                                                                index]
                                                                            .user!
                                                                            .imagePath! +
                                                                        notificationProvider
                                                                            .currentList[index]
                                                                            .user!
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF36446b),
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              25),
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Color(Constants.lightbluecolor),
                                                                          width:
                                                                              3.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            const Color(0xFF36446b),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundImage:
                                                                              imageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: notificationProvider.currentList[index].reason ==
                                                                              "Request" ||
                                                                          notificationProvider.currentList[index].reason ==
                                                                              "Follow"
                                                                      ? 4
                                                                      : 5,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .transparent,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        top: 5),
                                                                    child:
                                                                        ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Text(
                                                                            notificationProvider.currentList[index].msg!,
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Color(Constants.whitetext),
                                                                                fontSize: 14,
                                                                                fontFamily: Constants.appFont),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          margin:
                                                                              const EdgeInsets.only(top: 5),
                                                                          child:
                                                                              Text(
                                                                            notificationProvider.currentList[index].time!,
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                                () {
                                                                  if (notificationProvider
                                                                          .currentList[
                                                                              index]
                                                                          .reason ==
                                                                      "Request") {
                                                                    return Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.topCenter,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            InkWell(
                                                                              onTap: () {
                                                                                Constants.checkNetwork().whenComplete(() => notificationProvider.callApiForAcceptRequest(notificationProvider.currentList[index].user!.id));
                                                                              },
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                height: ScreenUtil().setHeight(30),
                                                                                width: ScreenUtil().setWidth(50),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                                  color: Color(Constants.lightbluecolor),
                                                                                ),
                                                                                child: Text(
                                                                                  "Confirm",
                                                                                  style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                Constants.checkNetwork().whenComplete(() => notificationProvider.callApiForDeleteRequest(notificationProvider.currentList[index].user!.id));
                                                                              },
                                                                              child: Container(
                                                                                margin: const EdgeInsets.only(left: 10, right: 5),
                                                                                alignment: Alignment.center,
                                                                                height: ScreenUtil().setHeight(30),
                                                                                width: ScreenUtil().setWidth(50),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                                  color: Color(Constants.greytext),
                                                                                ),
                                                                                child: Text(
                                                                                  "Delete",
                                                                                  style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else if (notificationProvider
                                                                          .currentList[
                                                                              index]
                                                                          .reason ==
                                                                      "Follow") {
                                                                    return Container();
                                                                  } else if (notificationProvider
                                                                          .currentList[
                                                                              index]
                                                                          .reason ==
                                                                      "Follow Back") {
                                                                    return Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.topCenter,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Constants.checkNetwork().whenComplete(() =>
                                                                                notificationProvider.callApiForFollowBack(notificationProvider.currentList[index].user!.id));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            height:
                                                                                ScreenUtil().setHeight(30),
                                                                            width:
                                                                                ScreenUtil().setWidth(80),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                              color: Color(Constants.lightbluecolor),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "Follow",
                                                                              style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 20, right: 5),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              alignment: Alignment.center,
                                                                              imageUrl: (notificationProvider.currentList[index].video?.imagePath ?? "") + (notificationProvider.currentList[index].video?.screenshot ?? ""),
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                width: ScreenUtil().setWidth(50),
                                                                                height: ScreenUtil().setHeight(50),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                  color: Color(Constants.lightbluecolor),
                                                                                  border: Border.all(color: Color(Constants.lightbluecolor), width: 3.0),
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) => const CustomLoader(),
                                                                              errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 12),
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "images/small_play_button.svg",
                                                                              width: 18,
                                                                              height: 18,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                }(),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : NoPostAvailable(
                                                      subject: "Notification",
                                                    ),
                                        ),

                                        ///lastWeek
                                        Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(0)),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: const EdgeInsets.only(
                                                bottom: 0,
                                                left: 28,
                                                right: 15,
                                                top: 15),
                                            child: Text(
                                              "L A S T   W E E K",
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.whitetext),
                                                  fontFamily: Constants.appFont,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(8)),
                                          child:
                                              notificationProvider
                                                      .lastSevenList.isNotEmpty
                                                  ? ListView.separated(
                                                      itemCount:
                                                          notificationProvider
                                                              .lastSevenList
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UserProfileScreen(
                                                                  userId: notificationProvider
                                                                      .lastSevenList[
                                                                          index]
                                                                      .user!
                                                                      .id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom: 0,
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  ///userImage
                                                                  CachedNetworkImage(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    imageUrl: notificationProvider
                                                                            .lastSevenList[
                                                                                index]
                                                                            .user!
                                                                            .imagePath! +
                                                                        notificationProvider
                                                                            .lastSevenList[index]
                                                                            .user!
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF36446b),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(25)),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Color(Constants.lightbluecolor),
                                                                          width:
                                                                              3.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            const Color(0xFF36446b),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundImage:
                                                                              imageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CustomLoader(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "images/no_image.png"),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Text(
                                                                              notificationProvider.lastSevenList[index].msg!,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            margin:
                                                                                const EdgeInsets.only(top: 5),
                                                                            child:
                                                                                Text(
                                                                              () {
                                                                                final DateTime now = DateTime.parse(notificationProvider.lastSevenList[index].createdAt!);
                                                                                final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
                                                                                final String formatted = formatter.format(now);
                                                                                return formatted;
                                                                              }(),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: Color(Constants.greytext), fontSize: 14, fontFamily: Constants.appFont),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  () {
                                                                    if (notificationProvider
                                                                            .lastSevenList[index]
                                                                            .reason ==
                                                                        "Request") {
                                                                      return Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Constants.checkNetwork().whenComplete(() => notificationProvider.callApiForAcceptRequest(notificationProvider.lastSevenList[index].user!.id));
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  height: ScreenUtil().setHeight(30),
                                                                                  width: ScreenUtil().setWidth(55),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                                    color: Color(Constants.lightbluecolor),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Confirm",
                                                                                    style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Constants.checkNetwork().whenComplete(() => notificationProvider.callApiForDeleteRequest(notificationProvider.lastSevenList[index].user!.id));
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(left: 10, right: 5),
                                                                                  alignment: Alignment.center,
                                                                                  height: ScreenUtil().setHeight(30),
                                                                                  width: ScreenUtil().setWidth(55),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                                    color: Color(Constants.greytext),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Delete",
                                                                                    style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 14),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else if (notificationProvider
                                                                            .lastSevenList[index]
                                                                            .reason ==
                                                                        "Follow") {
                                                                      return Container();
                                                                    } else if (notificationProvider
                                                                            .lastSevenList[index]
                                                                            .reason ==
                                                                        "Follow Back") {
                                                                      return Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Constants.checkNetwork().whenComplete(() => notificationProvider.callApiForFollowBack(notificationProvider.lastSevenList[index].user!.id));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: ScreenUtil().setHeight(30),
                                                                              width: ScreenUtil().setWidth(80),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                                color: Color(Constants.lightbluecolor),
                                                                              ),
                                                                              child: Text(
                                                                                "Follow",
                                                                                style: TextStyle(color: Color(Constants.whitetext), fontFamily: Constants.appFont, fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Stack(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 20, right: 5),
                                                                              child: CachedNetworkImage(
                                                                                alignment: Alignment.center,
                                                                                imageUrl: notificationProvider.lastSevenList[index].video!.imagePath! + notificationProvider.lastSevenList[index].video!.screenshot!,
                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                  width: ScreenUtil().setWidth(50),
                                                                                  height: ScreenUtil().setHeight(50),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    color: Color(Constants.lightbluecolor),
                                                                                    border: Border.all(color: Color(Constants.lightbluecolor), width: 3.0),
                                                                                    image: DecorationImage(
                                                                                      image: imageProvider,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                placeholder: (context, url) => const CustomLoader(),
                                                                                errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 12),
                                                                              child: SvgPicture.asset(
                                                                                "images/small_play_button.svg",
                                                                                width: 18,
                                                                                height: 18,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  }(),
                                                                ],
                                                              )),
                                                        );
                                                      },
                                                    )
                                                  : NoPostAvailable(
                                                      subject: "Notification",
                                                    ),
                                        ),
                                      ],
                                    )
                                  else
                                    SizedBox(
                                      height: ScreenUtil().screenHeight,
                                      width: ScreenUtil().screenWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: NoPostAvailable(
                                          subject: "Notification",
                                        ),
                                      ),
                                    ),
                                ],
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
