import 'dart:developer';

import 'package:allclearer/app/data/all_clear_preset.dart';
import 'package:allclearer/app/data/optional_time.dart';
import 'package:allclearer/app/sync/server_time_sync.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/time_set_page_arguments.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';

class ServerUrlInputController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final TextEditingController _editingController = TextEditingController();
  final RxList<String> _recentHosts = RxList();

  @override
  void onInit() {
    super.onInit();
    loadRecentList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _editingController.dispose();
  }

  TextEditingController getUriInputController() {
    return _editingController;
  }

  Future<void> onButtonClick() async {
    String input = _editingController.text.trim();
    if (input.isEmpty) {
      Get.snackbar('올바른 주소가 아닙니다.', '올바른 웹 페이지 주소를 입력해주세요');
      return;
    }

    if (!input.startsWith('https://') && !input.startsWith('http://')) {
      input = 'http://$input';
    }

    ServerTimeSync? sts = await getServerTimeSync(input);
    if (sts == null) return;

    Uri uri = sts.uri;
    String host = uri.host;
    if (uri.hasPort && (uri.port != 80 || uri.port != 443)) {
      host += ":${uri.port}";
    }

    addHostToRecentHostList(host);
    saveRecentList();

    Get.offAndToNamed(Routes.TIME_SET, arguments: TimeSetPageArguments(AllClearPreset(name: '', ts: sts, ot: OptionalTime())));
  }

  Future<ServerTimeSync?> getServerTimeSync(String uriStr) async {
    Uri? uri = Uri.tryParse(uriStr);
    if (uri == null) {
      Get.snackbar('올바른 주소가 아닙니다.', '주소를 분석하지 못했습니다.');
      log('잘못된 주소 : $uriStr');
      return null;
    }

    ServerTimeSync sts = ServerTimeSync(uri);
    Duration? diff = await sts.getDifference();
    if (diff == null) {
      Get.snackbar('서버 시간을 가져오지 못함', '주소가 올바르게 입력되었고 인터넷에 연결된 상태인지 확인해주세요.');
      return null;
    }

    return sts;
  }

  void addHostToRecentHostList(String host) {
    removeHostFromRecentHostList(host);
    _recentHosts.add(host);
    if (_recentHosts.length > 10) {
      _recentHosts.removeAt(0);
    }
  }

  Future<void> saveRecentList() async {
    await storage.setRecentHostList(_recentHosts);
  }

  void loadRecentList() {
    List<String>? data = storage.getRecentHostList();

    _recentHosts.clear();
    _recentHosts.addAll(data);
  }

  List<String> getRecentHostList() {
    List<String> hostList = [];
    for (String host in _recentHosts.value.reversed) {
      hostList.add(host);
    }

    return hostList;
  }

  void setHost(String host) {
    _editingController.text = host;
  }

  void removeHostFromRecentHostList(String host) {
    _recentHosts.remove(host);
  }
}
