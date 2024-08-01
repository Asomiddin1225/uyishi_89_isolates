import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lesson88_upload_download/data/repositories/file_repository.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/file_model.dart';
import '../../services/permission_service.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc({
    required this.fileRepository,
  }) : super(FileState()) {
    on<GetFiles>(_onGetFiles);
    on<DownloadFile>(_onDownload);
    on<OpenFile>(_onOpen);
    on<UploadFile>(_onUpload);
  }

  final FileRepository fileRepository;

  void _onGetFiles(
    GetFiles event,
    Emitter<FileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // await Future.delayed(const Duration(seconds: 1));

      for (var file in fileRepository.files) {
        final fullPath = await _getSavePath(file);
        if (_checkFileExists(fullPath)) {
          file = file
            ..savePath = fullPath
            ..isDownloaded = true;
        }
      }

      emit(state.copyWith(
        files: fileRepository.files,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDownload(
    DownloadFile event,
    Emitter<FileState> emit,
  ) async {
    if (await PermissionService.requestStoragePermission()) {
      final index = state.files!.indexWhere((f) {
        return event.file.id == f.id;
      });
      try {
        state.files![index].isLoading = true;
        emit(state.copyWith(files: state.files));

        final dio = Dio();
        final fullPath = await _getSavePath(event.file);

        if (_checkFileExists(fullPath)) {
          add(OpenFile(path: fullPath));
          state.files![index]
            ..isLoading = false
            ..savePath = fullPath
            ..isDownloaded = true;

          emit(state.copyWith(files: state.files));
        } else {
          final response = await dio.download(
            event.file.url,
            fullPath,
            onReceiveProgress: (count, total) {
              // count (byte) - qancha ma'lumot  yuklanganini aytadi
              // total (byte) - umumiy faylni hajmi
              state.files![index].progress = count / total;
              emit(state.copyWith(files: state.files));
            },
          );

          state.files![index]
            ..isLoading = false
            ..savePath = fullPath
            ..isDownloaded = true;
          emit(
            state.copyWith(files: state.files),
          );
        }
      } on DioException catch (e) {
        print("DIO EXCEPTION");
        state.files![index].isLoading = false;
        emit(
          state.copyWith(
            files: state.files,
            errorMessage: e.response?.data,
          ),
        );
      } catch (e) {
        print("DIO EXCEPTION");
         state.files![index].isLoading = false;
        emit(
          state.copyWith(
            files: state.files,
           errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onUpload(UploadFile event, emit) async {
    try {
      final dio = Dio();

      final file = File(event.path);
      final formData = FormData.fromMap(
        {
          "file": MultipartFile.fromBytes(
            file.readAsBytesSync(),
            filename: "Salom2.pdf",
          ),
        },
      );

      final response = await dio.post(
        "https://api.escuelajs.co/api/v1/files/upload",
        // options: Options(
        //   headers: {"ContentType": "multipart/form-data"},
        // ),
        data: formData,
        onSendProgress: (count, total) {
          print("${count / total}% yuborilmoqda");
        },
      );

      print(response.data);
    } on DioException catch (e) {
      print(e.response?.data);
    } catch (e) {
      print(e.toString());
    }
  }

  void _onOpen(
    OpenFile event,
    Emitter<FileState> emit,
  ) async {
    await OpenFilex.open(event.path);
  }

  bool _checkFileExists(String filePath) {
    final file = File(filePath);

    return file.existsSync();
  }

  Future<String> _getSavePath(FileModel file) async {
    Directory? savePath = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      savePath = Directory("/storage/emulated/0/download");
    }
    // iphone/application/documents
    final fileExtension =
        file.url.split('.').last; // https://www.hp.com/video.mp4
    final fileName = "${file.title}.$fileExtension"; // Harry Potter Video.mp4
    final fullPath = "${savePath.path}/$fileName";

    return fullPath;
  }
}
