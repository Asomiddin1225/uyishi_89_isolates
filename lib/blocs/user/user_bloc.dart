import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson88_upload_download/data/models/photo.dart';
import 'package:lesson88_upload_download/services/user_count_service.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitialState()) {
    on<GetUsersCount>(_onCount);
    on<GetUsersCountWithIsolate>(_onCountWithIsolate);
    on<GetPhotos>(_onGetPhotos);
    on<GetPhotosWithIsolate>(_onGetPhotosWithIsolate);
  }

  void _onCount(GetUsersCount event, emit) {
    int sum = 0;
    for (var i = 0; i < event.count; i++) {
      sum = sum + i;
    }
    print(sum);
  }

  void _onCountWithIsolate(
    GetUsersCountWithIsolate event,
    emit,
  ) async {
    final receivePort = ReceivePort();
    final data = {
      "count": event.count,
      "sendPort": receivePort.sendPort,
    };
    Isolate.spawn(UserCountService.countUsers, data);

    receivePort.listen((message) {
      print(message);

      receivePort.close();
    });
  }

  void _onGetPhotos(GetPhotos event, emit) async {
    final rawData = await rootBundle.loadString("assets/large-file.json");
    final data = jsonDecode(rawData);

    List<PhotoModel> photos = List<PhotoModel>.from(
      data.map((photo) {
        return PhotoModel.fromJson(photo);
      }),
    );

    print(photos.length);
  }

  void _onGetPhotosWithIsolate(
    GetPhotosWithIsolate event,
    emit,
  ) async {
    final rawData = await rootBundle.loadString("assets/large-file.json");
    
    final receivePort = ReceivePort();
    final data = {"data": rawData, "sendPort": receivePort.sendPort};
    Isolate.spawn(UserCountService.getPhotos, data);

    receivePort.listen((message) {
      print(message);

      receivePort.close();
    });
  }
}
