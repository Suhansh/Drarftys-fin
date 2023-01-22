import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '/model/add_music_modal.dart';
import '/model/advertice_manage.dart';
import '/model/banners.dart';
import '/model/default_search.dart';
import '/model/edited_video_model.dart';
import '/model/followandinvtelist.dart';
import '/model/followingVideo.dart';
import '/model/hashtag_video.dart';
import '/model/languages.dart';
import '/model/my_profile_info.dart';
import '/model/myprofilemodel.dart';
import '/model/nearByVideo.dart';
import '/model/notification_info.dart';
import '/model/notification_model.dart';
import '/model/own_following_followers.dart';
import '/model/report_reason.dart';
import '/model/search_data.dart';
import '/model/setting.dart';
import '/model/single_audio.dart';
import '/model/single_song_modal.dart';
import '/model/single_user_model.dart';
import '/model/singlevideo.dart';
import '/model/trendingVideoModel.dart';
import '/model/userblocklist.dart';
import '/model/video_upload_model.dart';
import '/model/videocomment.dart';

part 'Apiservice.g.dart';

@RestApi(baseUrl: "Enter_your_base_url/public/api/")
//Please don't remove "/public/api/"
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST("login")
  @FormUrlEncoded()
  Future<String?> login(
    @Field() String login_textbox,
    @Field() String password,
    @Field() String? device_token,
    @Field() String provider,
    @Field() String provider_token,
    @Field() String name,
    @Field() String image,
    @Field() String platform,
  );

  @POST("register")
  @FormUrlEncoded()
  Future<String?> register(
    @Field() String name,
    @Field() String user_id,
    @Field() String email,
    @Field() String? code,
    @Field() String phone,
    @Field() String password,
    @Field() String confirm_password,
  );

  @POST("checkOtp")
  @FormUrlEncoded()
  Future<String?> checkOtp(
    @Field() String otp,
    @Field() String user_id,
  );

  @POST("changePassword")
  @FormUrlEncoded()
  Future<String?> changePassword(
    @Field() String? user_id,
    @Field() String password,
    @Field() String confirm_password,
  );

  @POST("sendOtp")
  @FormUrlEncoded()
  Future<String?> sendotp(
    @Field() String email,
  );

  @GET("settings")
  Future<Setting> settingRequest();

  @GET("language")
  Future<Languages> language();

  @GET("trending_video")
  Future<TrendingVideo> gettrendingvideo();

  @GET("single_video_comments/{id}")
  Future<VideoComment> getvideocomment(
    @Path() int? id,
  );

  @GET("users_block_list")
  Future<UserBlockList> getblockuser();

  @GET("follow_and_invite")
  Future<FollowAndInviteList> getfollowlist();

  @POST("privacy_settings")
  @FormUrlEncoded()
  Future<String?> privacysetting(
    @Field() String follower_request,
  );

  @GET("my_profile")
  Future<MyProfileModel> getmyprofiledata();

  @POST("edit_profile")
  @FormUrlEncoded()
  Future<String?> editprofile(
    @Body() body,
  );

  @POST("report_problem")
  @FormUrlEncoded()
  Future<String?> reportProblem(
    @Body() body,
  );

  @GET("like_video/{id}")
  Future<String?> likevideo(
    @Path() int? id,
  );

  @GET("save_video/{id}")
  Future<String?> savevideo(
    @Path() int? id,
  );

  @POST("block")
  @FormUrlEncoded()
  Future<String?> blockuser(
    @Field() String user_id,
    @Field() String type,
  );

  @POST("unblock")
  @FormUrlEncoded()
  Future<String?> unblockuser(
    @Field() String user_id,
    @Field() String type,
  );

  @GET("banners")
  Future<Banners> getbanners();

  @GET("like_comment/{id}")
  Future<String?> likecomment(
    @Path() int? id,
  );

  @POST("create_comment")
  @FormUrlEncoded()
  Future<String?> postcomment(
    @Field() String video_id,
    @Field() String comment,
  );

  @GET("single_video/{id}")
  Future<SingleVideo> getsinglevideo(
    @Path() int? id,
  );

  @GET("video_view/{id}")
  Future<String?> viewVideo(
    @Path() int? id,
  );

  @GET("guest_user")
  Future<String?> guestUser();

  @GET("following_videos")
  Future<FollowingVideo> getFollowingVideo();

  @POST("nearby_video")
  @FormUrlEncoded()
  Future<NearByVideos> getNearByVideo(
    @Field() double? latitude,
    @Field() double? longitude,
  );

  @GET("search_default")
  Future<DefaultSearch> getDefaultSearch();

  @GET("search/{search}")
  Future<SearchedData> getSearchData(@Path() String search);

  @GET("single_user/{userId}")
  Future<SingleUser> getSingleUserData(@Path() int? userId);

  @GET("unfollow/{userId}")
  Future<String?> unFollowRequest(@Path() int? userId);

  @GET("reject/{userId}")
  Future<String?> rejectRequest(@Path() int? userId);

  @GET("follow/{userId}")
  Future<String?> followRequest(@Path() int? userId);

  @GET("remove_follow/{userId}")
  Future<String?> removeFromFollowRequest(@Path() int? userId);

  @GET("hashtag_videos/{hashtag}")
  Future<HashtagVideos> hashtagVideo(@Path() String? hashtag);

  @GET("my_profile_info")
  Future<MyProfileInformation> myProfileInfo();

  @GET("notification")
  Future<NotificationModal> notificationRequest();

  @GET("accept/{userId}")
  Future<String> acceptRequest(@Path() int? userId);

  @GET("select_song")
  Future<AddMusicModal> addMusicRequest();

  @GET("add_favorite/{id}")
  Future<String?> addMusicFavoriteRequest(@Path() int? id);

  @GET("single_song/{id}")
  Future<MusicSingleSong> singleMusicRequest(@Path() int? id);

  @GET("single_audio/{id}")
  Future<SingleAudio> singleAudioRequest(@Path() int id);

  @POST("upload_video")
  @FormUrlEncoded()
  Future<VideoUpload> uploadVideos(@Body() body);

  @POST("edit_video")
  @FormUrlEncoded()
  Future<EditedVideoModel> editVideo(@Body() body);

  @GET("report_reasons/{parameter}")
  Future<ReportReasonModal> reportReason(@Path() String parameter);

  @GET("not_interested/{videoId}")
  Future<String?> notInterested(@Path() int? videoId);

  @GET("my_profile_info")
  Future<NotificationInfo> notificationGetSetting();

  @POST("report_user")
  @FormUrlEncoded()
  Future<String?> reportUser(
    @Field() String user_id,
    @Field() String report_id,
  );

  @POST("notification_settings")
  @FormUrlEncoded()
  Future<String?> notificationSave(
    @Body() body,
  );

  @POST("report_video")
  @FormUrlEncoded()
  Future<String?> reportVideo(
    @Field() String video_id,
    @Field() String report_id,
  );
  @POST("report_comment")
  @FormUrlEncoded()
  Future<String?> reportComment(
    @Field() String comment_id,
    @Field() String report_id,
  );

  @GET("own_followers")
  Future<OwnFollowersFollowing> ownFollowingFollowers();

  @GET("delete_video/{videoId}")
  Future<String?> deleteVideo(@Path() int? videoId);

  @GET("delete_comment/{commentId}")
  Future<String?> deleteComment(@Path() int? commentId);

  @GET("advertisement")
  Future<AdvertiseManage> adManagement();
}
