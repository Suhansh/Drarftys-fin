import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/custom/video_player_provider.dart';
import '/screen/my_profile/followers_list_provider.dart';
import '/screen/register/register_provider.dart';
import '/screen/setting/notification_setting/notification_setting_provider.dart';
import '/screen/setting/privacy/privacy_provider.dart';
import '/screen/setting/report_problem/report_problem_provider.dart';
import '/screen/edit_post/edit_post_provider.dart';
import '/screen/edit_profile/edit_profile_provider.dart';
import '/screen/notification/notification_provider.dart';
import '/screen/own_post/own_post_provider.dart';
import '/screen/search/search_creator_provider.dart';
import '/custom/like_comment_share.dart';
import '/screen/following/following_provider.dart';
import '/screen/homepage/homepage_provider.dart';
import '/screen/nearby/nearBy_provider.dart';
import '/screen/search/search_hashtag_video_provider.dart';
import '/screen/search/search_history_provider.dart';
import '/screen/search/search_provider.dart';
import '/screen/trending/trending_provider.dart';
import '/screen/chat/provider/chat_home_provider.dart';
import '/screen/initialize_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '/util/preference_utils.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'advertisement_provider/advertise_provider.dart';
import 'screen/bottom_bar/bottom_bar_provider.dart';
import 'screen/chat/provider/auth_provider_firebase.dart';
import 'screen/chat/provider/chat_provider.dart';
import 'screen/chat/provider/setting_provider.dart';
import 'screen/my_profile/my_profile_provider.dart';
import 'screen/setting/privacy/blocked_user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Platform.isAndroid
      ? await Firebase.initializeApp()
      : await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCQXp_Ee4ht2YqsmvSeyjrjiX5dMw77Xmg",
              appId: "1:641776889411:ios:e40ea6dd905821953feef6",
              messagingSenderId: "641776889411",
              projectId: "acoustic-tiktok",
              storageBucket: "acoustic-tiktok.appspot.com"));

  await Firebase.app();

  await PreferenceUtils.init();
  await FacebookAudienceNetwork.init();
  HttpOverrides.global = MyHttpOverrides();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: firebaseFirestore,
            ),
          ),
          Provider<SettingProvider>(
            create: (_) => SettingProvider(
              firebaseFirestore: firebaseFirestore,
              firebaseStorage: firebaseStorage,
            ),
          ),
          Provider<ChatHomeProvider>(
            create: (_) => ChatHomeProvider(
              firebaseFirestore: firebaseFirestore,
            ),
          ),
          Provider<ChatProvider>(
            create: (_) => ChatProvider(
              firebaseFirestore: firebaseFirestore,
              firebaseStorage: firebaseStorage,
            ),
          ),
          ChangeNotifierProvider<BottomBarProvider>(
            create: (_) => BottomBarProvider(),
          ),
          ChangeNotifierProvider<HomepageProvider>(
            create: (_) => HomepageProvider(),
          ),
          ChangeNotifierProvider<TrendingProvider>(
            create: (_) => TrendingProvider(),
          ),
          ChangeNotifierProvider<LikeCommentShareProvider>(
            create: (_) => LikeCommentShareProvider(),
          ),
          ChangeNotifierProvider<FollowingProvider>(
            create: (_) => FollowingProvider(),
          ),
          ChangeNotifierProvider<NearByProvider>(
            create: (_) => NearByProvider(),
          ),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(),
          ),
          ChangeNotifierProvider<SearchHistoryProvider>(
            create: (_) => SearchHistoryProvider(),
          ),
          ChangeNotifierProvider<SearchHashtagVideoProvider>(
            create: (_) => SearchHashtagVideoProvider(),
          ),
          ChangeNotifierProvider<SearchCreatorProvider>(
            create: (_) => SearchCreatorProvider(),
          ),
          ChangeNotifierProvider<OwnPostProvider>(
            create: (_) => OwnPostProvider(),
          ),
          ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider(),
          ),
          ChangeNotifierProvider<MyProfileProvider>(
            create: (_) => MyProfileProvider(),
          ),
          ChangeNotifierProvider<EditPostProvider>(
            create: (_) => EditPostProvider(),
          ),
          ChangeNotifierProvider<EditProfileProvider>(
            create: (_) => EditProfileProvider(),
          ),
          ChangeNotifierProvider<PrivacyProvider>(
            create: (_) => PrivacyProvider(),
          ),
          ChangeNotifierProvider<NotificationSettingProvider>(
            create: (_) => NotificationSettingProvider(),
          ),
          ChangeNotifierProvider<ReportProblemProvider>(
            create: (_) => ReportProblemProvider(),
          ),
          ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider(),
          ),
          ChangeNotifierProvider<FollowersListProvider>(
            create: (_) => FollowersListProvider(),
          ),
          ChangeNotifierProvider<BlockedUserProvider>(
            create: (_) => BlockedUserProvider(),
          ),
          ChangeNotifierProvider<VideoPlayerProvider>(
            create: (_) => VideoPlayerProvider(),
          ),
          ChangeNotifierProvider<AdvertiseProvider>(
              create: (_) => AdvertiseProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: InitializeScreen(0),
        ),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
