class Setting {
  String? msg;
  Data? data;
  bool? success;

  Setting({this.msg, this.data, this.success});

  Setting.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  String? appName;
  String? projectNo;
  String? appId;
  String? appVersion;
  String? appFooter;
  String? whiteLogo;
  String? colorLogo;
  String? termsOfUse;
  String? privacyPolicy;
  int? isWatermark;
  String? watermark;
  int? vidQty;
  String? shareUrl;
  int? admob;
  String? androidAdmobAppId;
  String? androidBanner;
  String? androidInterstitial;
  String? androidRewarded;
  String? androidNative;
  String? iosNative;
  String? iosAdmobAppId;
  String? iosBanner;
  String? iosInterstitial;
  String? iosRewarded;
  String? imagePath;
  String? facebookBanner;
  String? facebookInit;

  Data({
    this.appName,
    this.projectNo,
    this.appId,
    this.appVersion,
    this.appFooter,
    this.whiteLogo,
    this.colorLogo,
    this.termsOfUse,
    this.privacyPolicy,
    this.isWatermark,
    this.watermark,
    this.vidQty,
    this.shareUrl,
    this.admob,
    this.androidAdmobAppId,
    this.androidBanner,
    this.androidInterstitial,
    this.androidRewarded,
    this.iosAdmobAppId,
    this.iosBanner,
    this.iosInterstitial,
    this.iosRewarded,
    this.imagePath,
    this.androidNative,
    this.iosNative,
    this.facebookBanner,
    this.facebookInit,
  });

  Data.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    projectNo = json['project_no'];
    appId = json['app_id'];
    appVersion = json['app_version'];
    appFooter = json['app_footer'];
    whiteLogo = json['white_logo'];
    colorLogo = json['color_logo'];
    termsOfUse = json['terms_of_use'];
    privacyPolicy = json['privacy_policy'];
    isWatermark = json['is_watermark'];
    watermark = json['watermark'];
    vidQty = json['vid_qty'];
    shareUrl = json['share_url'];
    admob = json['admob'];
    androidAdmobAppId = json['android_admob_app_id'];
    androidBanner = json['android_banner'];
    androidInterstitial = json['android_interstitial'];
    androidRewarded = json['android_rewarded'];
    androidNative = json['android_native'];
    iosNative = json['ios_native'];
    iosAdmobAppId = json['ios_admob_app_id'];
    iosBanner = json['ios_banner'];
    iosInterstitial = json['ios_interstitial'];
    iosRewarded = json['ios_rewarded'];
    imagePath = json['imagePath'];
    facebookBanner = json['facebook_banner'];
    facebookInit = json['facebook_init'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['project_no'] = projectNo;
    data['app_id'] = appId;
    data['app_version'] = appVersion;
    data['app_footer'] = appFooter;
    data['white_logo'] = whiteLogo;
    data['color_logo'] = colorLogo;
    data['terms_of_use'] = termsOfUse;
    data['privacy_policy'] = privacyPolicy;
    data['is_watermark'] = isWatermark;
    data['watermark'] = watermark;
    data['vid_qty'] = vidQty;
    data['share_url'] = shareUrl;
    data['admob'] = admob;
    data['android_admob_app_id'] = androidAdmobAppId;
    data['android_banner'] = androidBanner;
    data['android_interstitial'] = androidInterstitial;
    data['android_rewarded'] = androidRewarded;
    data['android_native'] = androidNative;
    data['ios_native'] = iosNative;
    data['ios_admob_app_id'] = iosAdmobAppId;
    data['ios_banner'] = iosBanner;
    data['ios_interstitial'] = iosInterstitial;
    data['ios_rewarded'] = iosRewarded;
    data['imagePath'] = imagePath;
    data['facebook_banner'] = facebookBanner;
    data['facebook_init'] = facebookInit;
    return data;
  }
}
