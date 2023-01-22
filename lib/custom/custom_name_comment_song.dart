import '/screen/nearby/nearBy_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'loader_custom_widget.dart';
import '../model/trendingVideoModel.dart';
import '../util/constants.dart';
import '../util/preference_utils.dart';
import '../screen/following/following_provider.dart';
import '../screen/initialize_screen.dart';
import '../screen/login_screen.dart';
import '../screen/usedSoundList.dart';
import '../screen/userprofile.dart';
import '../screen/trending/trending_provider.dart';

///for trending page
//ignore: must_be_immutable
class CustomNameStatusSongTrending extends StatelessWidget {
  CustomNameStatusSongTrending({
    Key? key,
    required this.trendingData,
    required this.trendingProviderData,
  }) : super(key: key);

  final TrendingData trendingData;
  TrendingProvider trendingProviderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, bottom: 20),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///user profile pic and name
              InkWell(
                onTap: () {
                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                    if (trendingData.isYou == true) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => InitializeScreen(4)));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            userId: trendingData.user!.id,
                          ),
                        ),
                      );
                    }
                  } else {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0, right: 5, bottom: 5),
                      width: 36.w,
                      height: 36.h,
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        imageUrl: trendingData.user!.imagePath! + trendingData.user!.image!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) => const CustomLoader(),
                        errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          trendingData.user!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),

              ///option threeDots
              Visibility(
                visible: trendingData.isYou == false,
                child: Container(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                  child: SvgPicture.asset(
                    "images/white_dot.svg",
                    width: 5,
                    height: 5,
                  ),
                ),
              ),
              trendingData.isYou == false
                  ? trendingData.user!.isFollowing == 0

                      /// follow portion
                      ? InkWell(
                          onTap: () {
                            if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                              trendingProviderData.callApiForFollowRequest(
                                  trendingData.user!.id, trendingData.id);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                              // Constants.toastMessage(
                              //     'Please Login First To Follow');
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                                child: SvgPicture.asset(
                                  "images/follow.svg",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  'Follow',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      /// unfollow portion
                      : InkWell(
                          onTap: () {
                            if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                              trendingProviderData.callApiForUnFollowRequest(
                                  trendingData.user!.id, trendingData.id);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                                child: SvgPicture.asset(
                                  "images/follow.svg",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trendingData.user!.isRequested == 0 ? 'Unfollow' : 'Requested',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        )
                  : Container(),
            ],
          ),

          ///halfStatus
          Visibility(
            visible: trendingProviderData.halfStatus && trendingData.description!.length > 5,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
              child: Text(
                trendingData.description ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
              ),
            ),
          ),

          ///fullStatus
          Visibility(
            visible: trendingProviderData.fullStatus && trendingData.description!.isNotEmpty,
            child: InkWell(
              onTap: () {
                trendingProviderData.changeFullStatus();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
                child: Text(
                  trendingData.description ?? "",
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(Constants.whitetext),
                      fontSize: 14,
                      fontFamily: Constants.appFont),
                ),
              ),
            ),
          ),

          ///showMore
          Visibility(
            visible: trendingProviderData.showMore && trendingData.description!.length > 5,
            child: Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(left: 10, right: 20, bottom: 5),
              child: InkWell(
                onTap: () {
                  trendingProviderData.changeFullStatus();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "...more",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(Constants.whitetext),
                          fontSize: 16,
                          fontFamily: Constants.appFont),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "images/down_arrow.svg",
                        width: 8,
                        height: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///audio
          trendingData.originalAudio != null
              ? InkWell(
                  onTap: () {
                    String? passSongId = '';
                    bool isSongIdAvailable = true;
                    if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                      if (trendingData.songId != '' && trendingData.songId != null) {
                        passSongId = trendingData.songId;
                        isSongIdAvailable = true;
                      } else if (trendingData.audioId != '' && trendingData.audioId != null) {
                        passSongId = trendingData.audioId;
                        isSongIdAvailable = false;
                      }
                      if (trendingData.originalAudio != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsedSoundScreen(
                                    songId: passSongId,
                                    isSongIdAvailable: isSongIdAvailable,
                                  )),
                        );
                        if (kDebugMode) {
                          print("open sound");
                        }
                      }
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 2),
                      child: SvgPicture.asset(
                        "images/sound_waves.svg",
                        width: 15,
                        height: 15,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 20,
                        margin: const EdgeInsets.only(left: 5, right: 2),
                        child: Marquee(
                          text: trendingData.originalAudio ?? " ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        // child:Text('
                      ),
                    ),
                  ]),
                )
              : Container(),
        ],
      ),
    );
  }
}

///for following page
//ignore: must_be_immutable
class CustomNameStatusSongFollowing extends StatelessWidget {
  CustomNameStatusSongFollowing({
    Key? key,
    required this.followingData,
    required this.followingProviderData,
  }) : super(key: key);

  final TrendingData followingData;
  FollowingProvider followingProviderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, bottom: 20),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///user profile pic and name
              InkWell(
                onTap: () {
                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                    if (followingData.isYou == true) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => InitializeScreen(4)));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            userId: followingData.user!.id,
                          ),
                        ),
                      );
                    }
                  } else {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0, right: 5, bottom: 5),
                      width: 36.w,
                      height: 36.h,
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        imageUrl: followingData.user!.imagePath! + followingData.user!.image!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) => const CustomLoader(),
                        errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          followingData.user!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),

              ///option threeDots
              Visibility(
                visible: followingData.isYou == false,
                child: Container(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                  child: SvgPicture.asset(
                    "images/white_dot.svg",
                    width: 5,
                    height: 5,
                  ),
                ),
              ),
              followingData.isYou == false
                  ? followingData.user!.isFollowing == 0

                      /// follow portion
                      ? InkWell(
                          onTap: () {
                            if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                              followingProviderData.callApiForFollowRequest(
                                  followingData.user!.id, followingData.id);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                              // Constants.toastMessage(
                              //     'Please Login First To Follow');
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                                child: SvgPicture.asset(
                                  "images/follow.svg",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  'Follow',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      /// unfollow portion
                      : InkWell(
                          onTap: () {
                            if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                              followingProviderData.callApiForUnFollowRequest(
                                  followingData.user!.id, followingData.id);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                                child: SvgPicture.asset(
                                  "images/follow.svg",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    followingData.user!.isRequested == 0 ? 'Unfollow' : 'Requested',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        )
                  : Container(),
            ],
          ),

          ///halfStatus
          Visibility(
            visible: followingProviderData.halfStatus && followingData.description!.length > 5,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
              child: Text(
                followingData.description ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
              ),
            ),
          ),

          ///fullStatus
          Visibility(
            visible: followingProviderData.fullStatus && followingData.description!.isNotEmpty,
            child: InkWell(
              onTap: () {
                followingProviderData.changeFullStatus();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
                child: Text(
                  followingData.description ?? "",
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(Constants.whitetext),
                      fontSize: 14,
                      fontFamily: Constants.appFont),
                ),
              ),
            ),
          ),

          ///showMore
          Visibility(
            visible: followingProviderData.showMore && followingData.description!.length > 5,
            child: Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(left: 10, right: 20, bottom: 5),
              child: InkWell(
                onTap: () {
                  followingProviderData.changeFullStatus();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "...more",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(Constants.whitetext),
                          fontSize: 16,
                          fontFamily: Constants.appFont),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "images/down_arrow.svg",
                        width: 8,
                        height: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///audio
          followingData.originalAudio != null
              ? InkWell(
                  onTap: () {
                    String? passSongId = '';
                    bool isSongIdAvailable = true;
                    if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                      if (followingData.songId != '' && followingData.songId != null) {
                        passSongId = followingData.songId;
                        isSongIdAvailable = true;
                      } else if (followingData.audioId != '' && followingData.audioId != null) {
                        passSongId = followingData.audioId;
                        isSongIdAvailable = false;
                      }
                      if (followingData.originalAudio != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsedSoundScreen(
                                    songId: passSongId,
                                    isSongIdAvailable: isSongIdAvailable,
                                  )),
                        );
                        if (kDebugMode) {
                          print("open sound");
                        }
                      }
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 2),
                      child: SvgPicture.asset(
                        "images/sound_waves.svg",
                        width: 15,
                        height: 15,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 20,
                        margin: const EdgeInsets.only(left: 5, right: 2),
                        child: Marquee(
                          text: followingData.originalAudio ?? " ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        // child:Text('
                      ),
                    ),
                  ]),
                )
              : Container(),
        ],
      ),
    );
  }
}

///for nearby page
// ignore: must_be_immutable
class CustomNameStatusSongNearBy extends StatelessWidget {
  CustomNameStatusSongNearBy({
    Key? key,
    required this.nearByData,
    required this.nearByProvider,
  }) : super(key: key);

  final TrendingData nearByData;
  NearByProvider nearByProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, bottom: 20),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///user profile pic and name
              InkWell(
                onTap: () {
                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                    if (nearByData.isYou == true) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => InitializeScreen(4)));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            userId: nearByData.user!.id,
                          ),
                        ),
                      );
                    }
                  } else {
                    Future.delayed(
                      const Duration(seconds: 0),
                          () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0, right: 5, bottom: 5),
                      width: 36.w,
                      height: 36.h,
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        imageUrl: nearByData.user!.imagePath! + nearByData.user!.image!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) => const CustomLoader(),
                        errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          nearByData.user!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),

              ///option threeDots
              Visibility(
                visible: nearByData.isYou == false,
                child: Container(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
                  child: SvgPicture.asset(
                    "images/white_dot.svg",
                    width: 5,
                    height: 5,
                  ),
                ),
              ),
              nearByData.isYou == false
                  ? nearByData.user!.isFollowing == 0

              /// follow portion
                  ? InkWell(
                onTap: () {
                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                    nearByProvider.callApiForFollowRequest(
                        nearByData.user!.id, nearByData.id);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                    // Constants.toastMessage(
                    //     'Please Login First To Follow');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                      child: SvgPicture.asset(
                        "images/follow.svg",
                        width: 15,
                        height: 15,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        'Follow',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )

              /// unfollow portion
                  : InkWell(
                onTap: () {
                  if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                    nearByProvider.callApiForUnFollowRequest(
                        nearByData.user!.id, nearByData.id);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 2, bottom: 5),
                      child: SvgPicture.asset(
                        "images/follow.svg",
                        width: 15,
                        height: 15,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          nearByData.user!.isRequested == 0 ? 'Unfollow' : 'Requested',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )
                  : Container(),
            ],
          ),

          ///halfStatus
          Visibility(
            visible: nearByProvider.halfStatus && nearByData.description!.length > 5,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
              child: Text(
                nearByData.description ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(Constants.whitetext), fontSize: 14, fontFamily: Constants.appFont),
              ),
            ),
          ),

          ///fullStatus
          Visibility(
            visible: nearByProvider.fullStatus && nearByData.description!.isNotEmpty,
            child: InkWell(
              onTap: () {
                nearByProvider.changeFullStatus();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 0, bottom: 5),
                child: Text(
                  nearByData.description ?? "",
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(Constants.whitetext),
                      fontSize: 14,
                      fontFamily: Constants.appFont),
                ),
              ),
            ),
          ),

          ///showMore
          Visibility(
            visible: nearByProvider.showMore && nearByData.description!.length > 5,
            child: Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(left: 10, right: 20, bottom: 5),
              child: InkWell(
                onTap: () {
                  nearByProvider.changeFullStatus();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "...more",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(Constants.whitetext),
                          fontSize: 16,
                          fontFamily: Constants.appFont),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "images/down_arrow.svg",
                        width: 8,
                        height: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///audio
          nearByData.originalAudio != null
              ? InkWell(
            onTap: () {
              String? passSongId = '';
              bool isSongIdAvailable = true;
              if (PreferenceUtils.getBool(Constants.isLoggedIn) == true) {
                if (nearByData.songId != '' && nearByData.songId != null) {
                  passSongId = nearByData.songId;
                  isSongIdAvailable = true;
                } else if (nearByData.audioId != '' && nearByData.audioId != null) {
                  passSongId = nearByData.audioId;
                  isSongIdAvailable = false;
                }
                if (nearByData.originalAudio != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsedSoundScreen(
                          songId: passSongId,
                          isSongIdAvailable: isSongIdAvailable,
                        )),
                  );
                  if (kDebugMode) {
                    print("open sound");
                  }
                }
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: Row(children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 2),
                child: SvgPicture.asset(
                  "images/sound_waves.svg",
                  width: 15,
                  height: 15,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  margin: const EdgeInsets.only(left: 5, right: 2),
                  child: Marquee(
                    text: nearByData.originalAudio ?? " ",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  // child:Text('
                ),
              ),
            ]),
          )
              : Container(),
        ],
      ),
    );
  }
}
