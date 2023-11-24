import 'dart:developer';

import '../../../view_models/mood_list_view_model.dart';

class ImagesEditingHandler {
  // Handles and deletes the images using url from storage
  Future<List<String>> _handleUrlImages({
    required List<String> beforeImagesUrlPath,
    required List<String> afterImagesPath,
    required String date,
    required int timestamp,
  }) async {
    // every url contains https://firebasestorage.googleapis.com/..
    List<String> afterImagesUrlPath = afterImagesPath
        .where((element) => element.contains("https://"))
        .toList();

    // what is to be deleted
    List<String> urlDifference = beforeImagesUrlPath
        .where((element) => !afterImagesUrlPath.contains(element))
        .toList();

    // what images user want to store, contains path of images of database
    List<String> saveImagesStoragePaths = [];

    // contains the paths of images that user wants to delete
    List<String> deletingImagesPaths = [];

    // getting database storagePath of images that the user wants to save
    if (afterImagesUrlPath.isNotEmpty) {
      for (var url in afterImagesUrlPath) {
        var storagePath = Uri.parse(url).pathSegments.last;
        saveImagesStoragePaths.add(storagePath);
      }
    }

    // Getting the database path from the url
    for (var url in urlDifference) {
      // Getting the storage path
      var path = Uri.parse(url).pathSegments.last;
      deletingImagesPaths.add(path);
    }

    // later in firestore it is updated
    await MoodListViewModel().deleteImages(
      deletingImagePaths: deletingImagesPaths,
      date: date,
      timestamp: timestamp,
    );

    log("i might be the reason for your update");

    return saveImagesStoragePaths;
  }

  // Handles the local images and returns it's storage path
  Future<List<String>> _handleLocalImages({
    required List<String> afterImagesPath,
    required String date,
    required int timestamp,
  }) async {
    // basically every path not containing https://firebasestorage.googleapis.com/... is to be inserted
    List<String> localImagesPath =
        afterImagesPath.where((path) => !path.contains("https://")).toList();

    log("Any difference: $localImagesPath`");

    // uploading to the storage
    List<String> storagePaths = await MoodListViewModel().uploadImages(
        localPaths: localImagesPath, date: date, timestamp: timestamp);

    return storagePaths;
  }

  Future<List<String>> handleImages({
    required List<String> beforeImagesUrlPath,
    required List<String> afterImagesPath,
    required String date,
    required int timestamp,
  }) async {
    // 1. Handles the local images that is to be inserted
    var localImages = await _handleLocalImages(
        afterImagesPath: afterImagesPath, date: date, timestamp: timestamp);

    // 2. Handle the deleted url images
    var urlImages = await _handleUrlImages(
        beforeImagesUrlPath: beforeImagesUrlPath,
        afterImagesPath: afterImagesPath,
        date: date,
        timestamp: timestamp);

    return [...localImages, ...urlImages];
  }
}
