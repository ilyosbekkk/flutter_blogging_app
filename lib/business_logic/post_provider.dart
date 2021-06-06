import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grpc_client/business_logic/web_service.dart';

class PostProvider extends ChangeNotifier {
  Future<bool> post(String title, String content, List<int> pictureBlob) async {

    print(pictureBlob.length);
    bool posted = await WebService.post(title, content, pictureBlob);

    notifyListeners();
    return posted;
  }

  Future<void> fetchSinglePost(int id) async {
    await WebService.fetchSinglePost(id);
  }
}
