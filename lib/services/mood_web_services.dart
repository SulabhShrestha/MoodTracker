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
    var user = FirebaseAuth.instance.currentUser;

    log("USER ID before sending: ${user?.uid}");

    return FirebaseFirestore.instance
        .collectionGroup('List')
        .where("userID", isEqualTo: user!.uid)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> addNewMood(
      {required int rating,
      required int timestamp,
      required List<String?> imagesPath,
      String? why,
      String? feedback}) async {
    CollectionReference moodRef = FirebaseFirestore.instance.collection('Mood');
    var user = FirebaseAuth.instance.currentUser;

    // Getting today's date, however it's system date
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Location of images
    List<String?> imagesDbPaths = [];

    if (imagesPath.isNotEmpty) {
      imagesDbPaths = await uploadImages(
          localPaths: imagesPath, date: date, timestamp: timestamp);
    }

    // useful when searching, since firebase allows query for specific word in text
    // lowercase cause don't know how to search for 'not' with 'NOt'
    List<String> whyArray = why?.toLowerCase().split(" ") ?? [];
    List<String> feedbackArray = feedback?.toLowerCase().split(" ") ?? [];

    await moodRef
        .doc(user!.uid)
        .collection("Dates")
        .doc(date)
        .collection('List')
        .add({
          'userID': user.uid,
          'rating': rating,
          'why': why ?? "",
          'feedback': feedback ?? "",
          'timestamp': timestamp,
          'date': date,
          'imagesPath': imagesDbPaths,
          'whyArray': whyArray,
          'feedbackArray': feedbackArray,
        })
        .then((value) => log("Mood Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  /// Responsible for uploading images and returns the location of images
  Future<List<String>> uploadImages({
    required List<String?> localPaths,
    required String date,
    required int timestamp,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    int index = 1;

    // getting the last index within the folder
    final listResult = await FirebaseStorage.instance
        .ref()
        .child("moodsImages/${user?.uid}/$date/$timestamp/")
        .listAll();

    // result may be empty
    try {
      index = int.parse(listResult.items.last.name.split(".").first) + 1;
    } catch (e) {
      index = 1;
    }

    // Location of images
    List<String> imagesDbPaths = [];

    for (var path in localPaths) {
      File file = File(path!);

      // multiple images can be inserted at a single timestamp
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

  /// Responsible for removing images
  Future<void> deleteImages({
    required List<String> deletingImagePaths,
    required String date,
    required int timestamp,
    List<dynamic> updatedImagesPath = const [],
    bool updateToFirestore = true,
  }) async {
    var user = FirebaseAuth.instance.currentUser;
    // creating references
    final storageRef = FirebaseStorage.instance.ref();
    var moodsRef = FirebaseFirestore.instance
        .collection('Mood')
        .doc(user!.uid)
        .collection("Dates")
        .doc(date)
        .collection('List');

    //1.  Removing from firebase storage
    for (String deletingImagePath in deletingImagePaths) {
      final pathRef = storageRef.child(deletingImagePath);
      await pathRef.delete();
    }

    // getting doc
    var firebaseData =
        await moodsRef.where("timestamp", isEqualTo: timestamp).get();

    // There will be only one document having same timestamp
    String docId = firebaseData.docs.first.id;

    if (updateToFirestore) {
      //2. updating to firestore
      await moodsRef.doc(docId).update({'imagesPath': updatedImagesPath});
    }
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

  /// Returns Map<String(Date), Map<String, dynamic>>
  /// Also combines the result in a group according to the date
  Future<Map<String, List<Mood>>> searchMoodsByKeyword(
      {required String searchKeyword}) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    // Date : List<>
    final Map<String, List<Mood>> groupedData = {};
    String groupedKey;

    log("Search '$searchKeyword'");

    var whyData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("userID", isEqualTo: userID)
        .where('whyArray', arrayContains: searchKeyword)
        .get();

    var feedbackData = await FirebaseFirestore.instance
        .collectionGroup('List')
        .where("userID", isEqualTo: userID)
        .where('feedbackArray', arrayContains: searchKeyword)
        .get();

    var dataCollection = [...whyData.docs, ...feedbackData.docs];

    // --- removing duplicate data from [dataCollection] ---

    // Define a Set to store the unique document IDs
    Set<String> uniqueIds = {};

    // Define a List to store the unique snapshots
    List<QueryDocumentSnapshot<Map<String, dynamic>>> uniqueDataCollection = [];

    // Iterate over the original list and add each snapshot to the unique list
    // only if its documentID is not already in the Set of unique IDs
    for (var snapshot in dataCollection) {
      if (!uniqueIds.contains(snapshot.id)) {
        uniqueIds.add(snapshot.id);
        uniqueDataCollection.add(snapshot);
      }
    }

    // in descending order
    uniqueDataCollection
        .sort((a, b) => b.get('timestamp').compareTo(a.get('timestamp')));

    for (var i = 0; i < uniqueDataCollection.length; i++) {
      var element = uniqueDataCollection[i];

      // First converting to json, and decoding to json
      // Maybe in the future, db will be placed and instead of Object?, actual JSON be returned
      final Map<String, dynamic> json = jsonDecode(jsonEncode(element.data()));

      groupedKey = element.get("date");

      String keywordIncludesIn = "";

      // stating where the keyword is
      List<dynamic> whyArray = element.get("whyArray");
      List<dynamic> feedbackArray = element.get("feedbackArray");

      if (whyArray.contains(searchKeyword) &&
          feedbackArray.contains(searchKeyword)) {
        keywordIncludesIn = "both";
      } else if (whyArray.contains(searchKeyword)) {
        keywordIncludesIn = "why";
      }
      // that means feedback contains the keyword
      else {
        keywordIncludesIn = "feedback";
      }

      // This means that the current date mood is more than once
      if (groupedData.containsKey(groupedKey)) {
        groupedData[groupedKey]
            ?.add(Mood.fromJSON(json, keywordIncludesIn: keywordIncludesIn));
      } else {
        groupedData[groupedKey] = [
          Mood.fromJSON(json, keywordIncludesIn: keywordIncludesIn)
        ];
      }
    }

    log("Keyword: $groupedData");

    return groupedData;
  }

  Future<void> deleteMood(
      {required int timestamp, required String date}) async {
    var user = FirebaseAuth.instance.currentUser;

    var moodsRef = FirebaseFirestore.instance
        .collection('Mood')
        .doc(user!.uid)
        .collection("Dates")
        .doc(date)
        .collection('List');

    // getting doc
    var firebaseData = await moodsRef
        .where("userID", isEqualTo: user.uid)
        .where("timestamp", isEqualTo: timestamp)
        .get();

    // There will be only one document having same timestamp
    String docId = firebaseData.docs.first.id;

    log("Deleting: ${firebaseData.docs.first.data()}");

    try {
      // Deleting images
      List<dynamic> imagesPath = firebaseData.docs.first.get("imagesPath");
      for (var path in imagesPath) {
        log("Path: $path");
        await _deleteFileFromStorage(path);
      }

      // Deleting document
      await moodsRef.doc(docId).delete();
      log("Deleted");
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> _deleteFileFromStorage(String fileLink) async {
    // Extract the path from the provided link
    String filePath = Uri.parse(fileLink).path;

    // Get a reference to the storage instance
    FirebaseStorage storage = FirebaseStorage.instance;

    // Get a reference to the file
    Reference fileReference = storage.ref().child(filePath);

    // Delete the file
    await fileReference.delete();
    log('Image deleted successfully.');
  }

  Future<void> updateMood(
      {required int rating,
      required int timestamp,
      required String date,
      String? why = "",
      String? feedback = "",
      List<String?>? storageImagesPath}) async {
    var user = FirebaseAuth.instance.currentUser;
    var moodsRef = FirebaseFirestore.instance
        .collection('Mood')
        .doc(user!.uid)
        .collection("Dates")
        .doc(date)
        .collection('List');

    // getting doc
    var firebaseData = await moodsRef
        .where("userID", isEqualTo: user.uid)
        .where("timestamp", isEqualTo: timestamp)
        .get();

    // There will be only one document having same timestamp
    String docId = firebaseData.docs.first.id;

    // useful when searching, since firebase allows query for specific word in text
    // lowercase cause don't know how to search for 'not' with 'NOt'
    List<String> whyArray = why?.toLowerCase().split(" ") ?? [];
    List<String> feedbackArray = feedback?.toLowerCase().split(" ") ?? [];

    await moodsRef.doc(docId).update({
      "date": date,
      "feedback": feedback,
      "rating": rating,
      "timestamp": timestamp,
      "why": why,
      "imagesPath": storageImagesPath,
      "feedbackArray": feedbackArray,
      "whyArray": whyArray,
    });
  }
}
