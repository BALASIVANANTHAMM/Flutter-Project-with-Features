import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Utils.dart';


class Api{
  FirebaseAuth authentication = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? token;
  QuerySnapshot<Map<String, dynamic>>? data;
  CollectionReference? d;
  User? user;
  final fireBaseUser = FirebaseAuth.instance.currentUser;
  UserCredential? userCredential;
  static const String API_KEY = 'AIzaSyCQ1SMRR1M_xv3jd_rGnfa6FhzzGk37grA';


  loginWithEmailAndPassword(String email,String password,VoidCallback navigation,BuildContext context)async{
    try {
      userCredential = await authentication
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential!.user;
      navigation.call();
    } catch (e) {

      Utils().log(e);
    }
  }

  createUserWithEmailAndPassword(String email,String password,VoidCallback navigation,BuildContext context)async{
    try {
      userCredential = await authentication
          .createUserWithEmailAndPassword(
          email: email,
          password: password);
      user = userCredential!.user;
      navigation.call();
    } catch (e) {
      //Utils().showAlertBar(context, "Please use valid email and password");
      Utils().log(e);
    }
  }

  authSignOut(VoidCallback navigation,BuildContext context){
    try{
      authentication.signOut();
      navigation.call();
    }catch(e){
      //Utils().showAlertBar(context, "Something went wrong");
      Utils().log(e);
    }
  }

  verifyEmail({
    required BuildContext context,
    required String email,
    required VoidCallback function,
    required List<String> userList
})async{
    try{
      userList=await authentication.fetchSignInMethodsForEmail(email);
      function.call();
    }catch(e){
      Utils().log(e);
      Utils().snackBar(context, "Something went wrong!");
    }
  }

  changePassword({
    required BuildContext context,
    required String userEmail,
    required String currentPassword,
    required String newPassword,
    required VoidCallback function
  }) async {

    final cred = EmailAuthProvider.credential(
        email: userEmail, password: currentPassword);

    await fireBaseUser!.reauthenticateWithCredential(cred).then((value) {
      fireBaseUser!.updatePassword(newPassword).then((_) {
        function.call();
      }).catchError((error) {
        Utils().log(error);
      });
    }).catchError((err) {
      Utils().log(err);
    });
  }

  forgotPassword({
    required String email,
    required BuildContext context,
    required VoidCallback function
})async{
    try {
      await authentication.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  addDataFromUi({
    required Map<String,dynamic> fields,
    required String collectionUser,
    required String collectionId,
    required BuildContext context
  }) async {
    try {
      await fireStore
          .collection(collectionUser)
          .doc(fireBaseUser!.email)
          .collection(collectionId)
          .doc()
          .set(fields);
      Utils().log(fields);
      Utils().log(collectionUser);
      Utils().log(collectionId);
      Utils().log(fireBaseUser!.email);
      Utils().log(fireBaseUser!.uid);
    } catch (e) {
      Utils().log(e);
    }
  }

  updateDataFromUi({
    required Map<String,dynamic> fields,
    required String collectionUser,
    required String collectionId,
    required String docID,
    required VoidCallback function,
    required BuildContext context
  }) async {
    try {
      await fireStore
          .collection(collectionUser)
          .doc(fireBaseUser!.email)
          .collection(collectionId)
          .doc(docID)
          .update(fields);
      Utils().log(fields);
      function.call();
    } catch (e) {
      Utils().log(e);
    }
  }



  getDataFromFire({
    required String collectionUser,
    required String collectionId,
  }) async {
    Utils().log(data);
    Utils().log(collectionUser);
    Utils().log(collectionId);
    Utils().log(fireBaseUser!.email);
    Utils().log(fireBaseUser!.uid);
    return await fireStore
        .collection(collectionUser)
        .doc(fireBaseUser!.email)
        .collection(collectionId)
        .get();
  }

  Future<String> getDataFromFireSS({
    required String collectionUser,
    required String collectionId,
  }) async {

    QuerySnapshot docSnap = await fireStore
        .collection(collectionUser)
        .doc(fireBaseUser!.email)
        .collection(collectionId)
        .get();
    var docId = docSnap.docs[0].id;
    return  docId;
  }

  getFCMtoken({
    required String collectionUser,
    required String collectionId,
  })async{
    QuerySnapshot<Map<String, dynamic>> docSnap = await fireStore
        .collection(collectionUser)
        .doc(fireBaseUser!.email)
        .collection(collectionId)
        .get();

    return docSnap;
  }

  getStorageFiles(){}
}
