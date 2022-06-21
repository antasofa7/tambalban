import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tambal_ban/model/place_model.dart';

class PlaceService {
  final CollectionReference _placeReference =
      FirebaseFirestore.instance.collection('places');
  final firebaseStorageRef = FirebaseStorage.instance.ref();

  Future<void> createPlace(
      PlaceModel place, File? image, String fileName) async {
    try {
      final snapshot =
          await firebaseStorageRef.child('places/$fileName').putFile(image!);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      _placeReference.add({
        'name': place.name,
        'address': place.address,
        'openTime': place.openTime,
        'latitude': place.latitude,
        'longitude': place.longitude,
        'isTambalBan': place.isTambalBan,
        'isIsiAngin': place.isIsiAngin,
        'isGantiBan': place.isGantiBan,
        'imageUrl': downloadUrl,
      });
    } catch (err) {
      rethrow;
    }
  }

  Future<List<PlaceModel>> fetchPlaces() async {
    try {
      final QuerySnapshot results = await _placeReference.get();

      List<PlaceModel> places = results.docs.map((e) {
        return PlaceModel.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return places;
    } catch (err) {
      rethrow;
    }
  }
}
