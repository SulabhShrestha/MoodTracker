import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/mood.dart';

class MoodWebServices {
  var today = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> get moodsStream {
    return FirebaseFirestore.instance.collection('Mood').snapshots();
  }

  Future<void> addNewMood(
      {required int rating,
      required int timestamp,
      required List<String?> imagesPath,
      String? why,
      String? feedback}) async {
    CollectionReference moodRef = FirebaseFirestore.instance.collection('Mood');

    // Getting today's date, however it's system date
    String date = "${today.year}-${today.month}-${today.day}";

    // Location of images
    List<String?> imagesDbPaths = [];

    if (imagesPath.isNotEmpty) {
      imagesDbPaths = await uploadImage(
          paths: imagesPath, date: date, timestamp: timestamp);
    }

    log("Paths: $imagesDbPaths");

    await moodRef
        .doc(date)
        .collection('List')
        .add({
          'rating': rating,
          'why': why ?? "",
          'feedback': feedback ?? "",
          'timestamp': timestamp,
          'date': date,
          'imagesPath': imagesDbPaths,
        })
        .then((value) => log("Mood Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  // Responsible for uploading images and returns the location of images
  Future<List<String?>> uploadImage({
    required List<String?> paths,
    required String date,
    required int timestamp,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    int index = 1;

    // Location of images
    List<String?> imagesDbPaths = [];

    for (var path in paths) {
      File file = File(path!);

      String location = "moodsImages/${user?.uid}/$date/$timestamp/$index.jpg";
      imagesDbPaths.add(location);

      // same path leads to overwrite of the image
      final profileRef = storageRef.child(location);

      index += 1;

      await profileRef
          .putFile(file)
          .then((value) => log("Successfully inserted ${value.state}"));
    }

    return imagesDbPaths;
  }

  // Responsible for getting images
  Future<List<String>> getImagesURL(List<dynamic> paths) async {
    final storageRef = FirebaseStorage.instance.ref();
    List<String> downloadURLs = [];

    for (var path in paths) {
      var imageUrl = await storageRef.child(path).getDownloadURL();
      downloadURLs.add(imageUrl);
    }
    return downloadURLs;
  }

  /// returns Map<String, List>
  Future<Map<String, List<Mood>>> getAllMoodsString() async {
    // Date : List<>
    final Map<String, List<Mood>> groupedData = {};
    String groupedKey;

    var firebaseData = await FirebaseFirestore.instance
        .collection('Mood')
        .orderBy("timestamp", descending: true)
        .get();

    for (var element in firebaseData.docs) {
      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      groupedKey = element.get("date");

      // This means that the current date mood is more than once
      if (groupedData.containsKey(groupedKey)) {
        groupedData[groupedKey]?.add(Mood.fromJSON(json));
      } else {
        groupedData[groupedKey] = [Mood.fromJSON(json)];
      }
    }

    return groupedData;
  }

  /// returns Map<DateTime, List>
  Future<Map<DateTime, List<Mood>>> getAllMoodsDateTime() async {
    // Date : List<>
    final Map<DateTime, List<Mood>> groupedData = {};

    var firebaseData =
        await FirebaseFirestore.instance.collectionGroup('List').get();

    log("Size: ${firebaseData.docs.length}");
    for (var element in firebaseData.docs) {
      log("Element: $element");
      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      var res = element.get("date").split(" ").first.split("-"); // 1920-12-11

      DateTime dateTimeKey = DateTime.utc(
        int.parse(res[0]),
        int.parse(res[1]),
        int.parse(res[2]),
      );

      // This means that the current date mood is more than once
      if (groupedData.containsKey(dateTimeKey)) {
        groupedData[dateTimeKey]?.add(Mood.fromJSON(json));
      } else {
        groupedData[dateTimeKey] = [Mood.fromJSON(json)];
      }
    }

    return groupedData;
  }

  Future<void> deleteMood(
      {required int timestamp, required String date}) async {
    var moodsRef = FirebaseFirestore.instance
        .collection('Mood')
        .doc(date)
        .collection("List");

    // getting doc
    var firebaseData =
        await moodsRef.where("timestamp", isEqualTo: timestamp).get();

    log(firebaseData.toString());

    // There will be only one document having same timestamp
    String docId = firebaseData.docs.first.id;

    await moodsRef.doc(docId).delete();
    log("Deleted");
  }

  Future<void> updateMood(
      {required int rating,
      required int timestamp,
      required String date,
      String? why = "",
      String? feedback = ""}) async {
    var moodsRef = FirebaseFirestore.instance
        .collection('Mood')
        .doc(date)
        .collection("List");

    // getting doc
    var firebaseData =
        await moodsRef.where("timestamp", isEqualTo: timestamp).get();

    // There will be only one document having same timestamp
    String docId = firebaseData.docs.first.id;

    moodsRef.doc(docId).update({
      "date": date,
      "feedback": feedback,
      "rating": rating,
      "timestamp": timestamp,
      "why": why,
    });
  }
}
