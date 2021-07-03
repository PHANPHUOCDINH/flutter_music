import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../source.dart';

class AppFirebase {
  AppFirebase._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static final CollectionReference userCollection =
      firebaseFirestore.collection('users');

  static void sendOTPPhoneNumber({
    String phoneNumber,
    int timeout = 60,
    Function(PhoneAuthCredential credential) verificationCompleted,
    Function(FirebaseAuthException ex) verificationFailed,
    Function(String verificationId, int forceResendingToken) codeSent,
    Function(String verificationId) codeTimeout,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: AppHelper.convertPhoneNumber(phoneNumber.trim()),
      timeout: Duration(seconds: timeout),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeTimeout,
    );
  }

  static Future<void> uploadUser(UserModel userModel) async {
    await userCollection.doc("userID-${userModel.id}").set(userModel.toJson());
  }

  static Future<UploadTask> uploadImageFile(File file) async {
    if (file == null) return null;
    Reference ref = firebaseStorage.ref().child('media').child(
          '/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
        );

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'picked-file-path': file.path,
      },
    );

    UploadTask uploadTask = ref.putFile(File(file.path), metadata);
    return Future.value(uploadTask);
  }

  static Future<Uint8List> downloadBytes(Reference ref) async =>
      await ref.getData();

  static Future<String> downloadLink(Reference ref) async =>
      await ref.getDownloadURL();
}
