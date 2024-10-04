import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../privates/my_ad_unit_ids.dart';

class AdService extends GetxService {
  late AdUnitIds unitIds;
  MobileAds? _mobileAds;

  @override
  void onInit() {
    super.onInit();
    unitIds = MyAdUnitIds();
  }

  Future<TrackingStatus?> initMobileAds() async {
    TrackingStatus? status = await trackingTransparencyRequest();
    log(status.toString());
    if (status == TrackingStatus.notDetermined) {
      return status;
    }

    await MobileAds.instance.initialize();
    _mobileAds = MobileAds.instance;
    return status;
  }

  // From https://github.com/deniza/app_tracking_transparency/issues/47#issuecomment-1751719988
  Future<TrackingStatus?> trackingTransparencyRequest() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (Platform.isIOS &&
        int.parse(
                Platform.operatingSystemVersion.split(' ')[1].split('.')[0]) >=
            14) {
      TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }

      return status;
    }

    return null;
  }

  Future<bool> _init() async {
    _mobileAds ?? await initMobileAds();
    return _mobileAds != null;
  }

  Future<void> showAppOpenAd() async {
    if (!(await _init())) return;
    AppOpenAd.load(
        adUnitId: unitIds.getAppOpenAdId(),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            log('App Open Ad loaded : $ad');
            ad.show();
          },
          onAdFailedToLoad: (error) {
            log('App Open Ad error : $error');
          },
        ));
  }
}

abstract class AdUnitIds {
  String getAppOpenAdId();
}
