import 'package:expense_tracker/pages/login_screen.dart';
import 'package:expense_tracker/utils/api.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controls/text.dart';
import '../utils/Utils.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';
import '../utils/store_user_data.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  var currentWidth = 0.0;
  String? initialValue;
  var storeUserData=StoreUserData();
  final confirmCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final newCtl = TextEditingController();
  final appCheck = FirebaseAppCheck.instance;
  String _message = '';
  String _eventToken = 'not yet';
  bool pass=true,remember=false,isLoading=false;
  // Position? _currentLoc;
  // String? address;
  // Future<Position?> _getCurrentPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   return await Geolocator.getCurrentPosition();
  // }
  //
  // getAddress()async{
  //   Position? position = await _getCurrentPosition();
  //   setState(() {
  //     _currentLoc=position;
  //   });
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _currentLoc!.latitude, _currentLoc!.longitude);
  //
  //   setState(() {
  //     address="${placemarks[0].street}, ${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea} - ${placemarks[0].postalCode}";
  //   });
  //   print(address);
  // }


  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void setEventToken(String? token) {
    setState(() {
      _eventToken = token ?? 'not yet';
    });
  }

  @override
  void initState() {
    //getAddress();
    appCheck.onTokenChange.listen(setEventToken);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    currentWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: AppTheme.lightTopToBottom
          ),
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: SIZE_75_MINUS,
                child: Image.asset(
                    height: SIZE_146,
                    width: SIZE_162,
                    "${ASSET_PATH}circle1.png"
                ),
              ),
              Positioned(
                right: SIZE_30,
                top: SIZE_150,
                child: Image.asset(
                    height: SIZE_146,
                    width: SIZE_162,
                    "${ASSET_PATH}circle2.png"
                ),
              ),
              Positioned(
                right: SIZE_65_MINUS,
                bottom: SIZE_20_MINUS,
                child: Image.asset(
                    height: SIZE_146,
                    width: SIZE_162,
                    "${ASSET_PATH}circle1.png"
                ),
              ),
              Positioned(
                left: SIZE_80_MINUS,
                bottom: SIZE_166,
                child: Image.asset(
                    height: SIZE_146,
                    width: SIZE_162,
                    "${ASSET_PATH}circle3.png"
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: currentWidth>SIZE_600?20:50,
                  right: currentWidth>SIZE_600?20:16,
                  left: currentWidth>SIZE_600?20:16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Get.back();
                          },
                          child: Image.asset(
                              height: 26,
                              width: 26,
                              "${ASSET_PATH}back.png"),
                        ),
                        CText(
                          text: ch_pa_bi.tr,
                          fontSize: AppTheme.large,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 15,),
                      ],
                    ),
                    const SizedBox(height: 50,),
                    Row(
                      children: [
                        CText(
                            text: ch_pa_bi.tr,
                          fontWeight: FontWeight.w600,
                          fontSize: AppTheme.large,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Utils().cTextField(
                        context,
                        passwordCtl,
                        p_hint.tr,
                        TextInputType.text,
                        pass,
                        false,
                            (){
                          setState(() {
                            pass=!pass;
                          });
                        },
                        [FilteringTextInputFormatter.singleLineFormatter],
                        "password.png",
                        pass==false
                            ?"eye.png":"eye_cross.png"),
                    const SizedBox(height: 10,),
                    Utils().cTextField(
                        context,
                        newCtl,
                        new_bo.tr,
                        TextInputType.text,
                        true,
                        false,
                            (){},
                        [FilteringTextInputFormatter.singleLineFormatter],
                        "password.png",
                        ""),
                    const SizedBox(height: 10,),
                    Utils().cTextField(
                        context,
                        confirmCtl,
                        c_hint.tr,
                        TextInputType.text,
                        true,
                        false,
                            (){},
                        [FilteringTextInputFormatter.singleLineFormatter],
                        "password.png",
                        ""),
                    const SizedBox(height: 20,),
                    Utils().primaryButton(context, ch_pa_bi.tr, (){
                      Api().changePassword(
                          context: context,
                          userEmail: storeUserData.getString(EMAIL),
                          currentPassword: passwordCtl.text,
                          newPassword: confirmCtl.text,
                          function: (){
                            Api().getFCMtoken(
                                collectionUser: STORE_USER,
                                collectionId: STORE_USER_ID
                            ).then((value){
                              Api().updateDataFromUi(
                                fields: {
                                  'userId':Api().fireBaseUser!.uid,
                                  'DOB':storeUserData.getString(DOB),
                                  'email':storeUserData.getString(EMAIL),
                                  'password':confirmCtl.text,
                                  'name':storeUserData.getString(NAME),
                                  'Date':storeUserData.getString(CREATE_DATE),
                                  'Income':storeUserData.getInt(INCOME),
                                  'docId':storeUserData.getString(DOC_ID),
                                  'fcm':storeUserData.getString(FCM),
                                  'isActive':storeUserData.getBoolean(IS_ACTIVE)
                                },
                                collectionUser: STORE_USER,
                                collectionId: STORE_USER_ID,
                                context: context,
                                function: () {
                                  storeUserData.setString(PASSWORD, confirmCtl.text);
                                  Api().addDataFromUi(
                                      fields: {
                                        "dateNow":DateTime.now(),
                                        "title":ch_pa_bi.tr,
                                        "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                                        "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                                        "value":"Password Changed Successfully..",
                                      },
                                      collectionUser: STORE_NOTI,
                                      collectionId: STORE_NOTI_EMAIL,
                                      context: context
                                  );
                                  Utils().snackBar(context, "Password Changed Successfully");
                                }, docID: value.docs[0].id,
                              );
                            });
                          }
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}
