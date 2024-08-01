import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../data/models/photo.dart';

class UserCountService {
  static void countUsers(Map<String, dynamic> data) {
    final count = data['count'];
    final SendPort sendPort = data['sendPort'];

    int sum = 0;
    for (var i = 0; i < count; i++) {
      sum = sum + i;
    }

    sendPort.send(sum);
  }

  static void getPhotos(Map<String, dynamic> data) async {
    final SendPort sendPort = data['sendPort'];
    final malumot = data['data'];
    final mapData = jsonDecode(malumot);
    List<PhotoModel> photos = List<PhotoModel>.from(
      mapData.map((photo) {
        return PhotoModel.fromJson(photo);
      }),
    );

    sendPort.send(photos.length);
  }
}
