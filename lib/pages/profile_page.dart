import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/account_page.dart';
import 'package:expense_tracker/pages/login_screen.dart';
import 'package:expense_tracker/pages/settings.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:expense_tracker/utils/api.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controls/text.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var currentWidth =0.0;
  bool isEdit = false;
  var storeUserData = StoreUserData();
  String balance = "3800";
  final ctl = TextEditingController();

  // Future<void> getProfile() async {
  //   try{
  //     QuerySnapshot<Map<String, dynamic>> snapshot =
  //     await Api()
  //         .getDataFromFire(
  //         collectionUser: STORE_USER,
  //         collectionId: STORE_USER_ID);
  //     setState(() {
  //       profile = jsonDecode(snapshot);
  //     });
  //     Future.delayed(Duration(seconds: 2),(){
  //       print(snapshot);
  //       print(profile!.income);
  //     });
  //   }catch(e){
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: AppTheme.lightTopToBottom
        ),
        child: SizedBox(
          height: double.infinity,
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
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    top: currentWidth>SIZE_600?20:50,
                    right: currentWidth>SIZE_600?20:16,
                    left: currentWidth>SIZE_600?20:16,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: currentWidth>SIZE_600?20:16,),
                        Container(
                          height: currentWidth>SIZE_600?100:80,
                          width: currentWidth>SIZE_600?100:80,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: NetworkImage("https://www.pngall.com/wp-content/uploads/5/Profile.png"),
                              fit: BoxFit.cover
                            ),
                            border: Border.all(color: AppTheme.green,width: 5),
                            borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(height: currentWidth>SIZE_600?18:12,),
                        CText(
                            text: user_bi.tr,
                          textColor: AppTheme.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: AppTheme.thirteen,
                        ),
                        SizedBox(height: currentWidth>SIZE_600?18:12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CText(
                              text: storeUserData.getString(NAME),
                              textColor: AppTheme.black,
                              fontWeight: FontWeight.w800,
                              fontSize: AppTheme.large,
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isEdit=true;
                                  ctl.text=storeUserData.getString(NAME);
                                  dialogToUpdate();
                                });
                              },
                              child: Container(
                                height: currentWidth>SIZE_600?26:30,
                                width: currentWidth>SIZE_600?26:30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: AppTheme.red,width: 2)
                                ),
                                child: Image.asset(
                                    height: 20,
                                    width: 20,
                                    "${ASSET_PATH}edit.png"),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: currentWidth>SIZE_600?24:20,),
                        Container(
                          height: currentWidth>SIZE_600?currentWidth*2:currentWidth,
                          width: currentWidth>SIZE_600?currentWidth:currentWidth-32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.white
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 22
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                 getCart(AppTheme.blueLight, "account.png", acc_bi.tr.capitalizeFirst.toString(),(){
                                   Get.to(const AccountPage());
                                 }),
                                  Divider(color: AppTheme.grey.withOpacity(0.2),),
                                 getCart(AppTheme.blueLight, "settings.png", set_bi.tr.capitalizeFirst.toString(),(){
                                    Get.to(const SettingsScreen());
                                 }),
                                 Divider(color: AppTheme.grey.withOpacity(0.2),),
                                 getCart(AppTheme.blueLight, "update.png", up_in_bi.tr,(){
                                   setState(() {
                                     ctl.clear();
                                     isEdit=false;
                                   });
                                   dialogToUpdate();
                                 }),
                                 Divider(color: AppTheme.grey.withOpacity(0.2),),
                                 getCart(AppTheme.red20, "logout.png", log_bi.tr,(){
                                   getBottomSheet();
                                 }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget getCart(Color color,String image,String content,VoidCallback onTab){
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 60,
        width: currentWidth-30,
        decoration: const BoxDecoration(
          color: AppTheme.white
        ),
        child: Row(
          children: [
            Container(
              height: currentWidth>SIZE_600?70:60,
              width: currentWidth>SIZE_600?70:60,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                    height: 25,
                    width: 25,
                    "${ASSET_PATH}$image"),
              ),
            ),
            SizedBox(width: currentWidth>SIZE_600?20:12,),
            Flexible(
              child: CText(
                  text: content,
                overflow: TextOverflow.ellipsis,
                fontSize: AppTheme.large,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
  void getBottomSheet(){
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
      builder: (BuildContext context) { 
        return Container(
          height: currentWidth/2,
          width: currentWidth,
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Image.asset(
                  height: 10,
                  width: 30,
                  "${ASSET_PATH}line_bottom.png"
              ),
              const SizedBox(height: 16,),
              CText(
                  text: "${log_bi.tr}?",
                fontWeight: FontWeight.w700,
                fontSize: AppTheme.large,
              ),
              const SizedBox(height: 16,),
              CText(
                  text: ar_lo_bi.tr,
                fontSize: AppTheme.medium,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 24,),
              Utils().getAlertButton(
                  context,"No","Yes",(){
                  Get.back();
              },(){
                Api().authSignOut((){
                  storeUserData.clearData();
                  Api().addDataFromUi(
                      fields: {
                        "dateNow":DateTime.now(),
                        "title":log_bi.tr,
                        "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                        "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                        "value":"Account Logged Out ${Utils().formatDate(DateTime.now(), DateFormat.yMMMd().add_jm())}",
                      },
                      collectionUser: STORE_NOTI,
                      collectionId: STORE_NOTI_EMAIL,
                      context: context
                  );
                  Get.offAll(const LoginScreen());
                }, context);
              })
            ],
          ),
        );
      },);
  }

  void dialogToUpdate(){
    showDialog(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: AppTheme.light,
            content: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                        height: 45,
                        width: 45,
                        "${ASSET_PATH}app_logo.png"),
                    CText(
                        text: isEdit==false?pl_in_bi.tr:ch_n_bi.tr,
                      fontSize: AppTheme.big,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10,),
                    Utils().cTextField(
                        context,
                        ctl,
                        isEdit==false?pl_in_bi.tr.capitalizeFirst.toString():"",
                        isEdit==false?TextInputType.number:TextInputType.text,
                        false,
                        false,
                        (){},
                        isEdit==false?[FilteringTextInputFormatter.digitsOnly]:[FilteringTextInputFormatter.singleLineFormatter],
                        isEdit==false?"salery.png":"edit.png",
                        ""
                    ),
                    const SizedBox(height: 28,),
                    Utils().getAlertButton(
                        context,
                        can_bi.tr,
                        up_bi.tr,
                        (){
                          Get.back();
                        },
                        (){
                          if(isEdit==false){
                            num a = num.parse(ctl.text);
                            Api().getFCMtoken(
                                collectionUser: STORE_USER,
                                collectionId: STORE_USER_ID
                            ).then((value){
                              Api().updateDataFromUi(
                                fields: {
                                  'userId':Api().fireBaseUser!.uid,
                                  'DOB':storeUserData.getString(DOB),
                                  'email':storeUserData.getString(EMAIL),
                                  'password':storeUserData.getString(PASSWORD),
                                  'name':storeUserData.getString(NAME),
                                  'Date':storeUserData.getString(CREATE_DATE),
                                  'Income':a,
                                  'docId':storeUserData.getString(DOC_ID),
                                  'fcm':storeUserData.getString(FCM),
                                  'isActive':storeUserData.getBoolean(IS_ACTIVE)
                                },
                                collectionUser: STORE_USER,
                                collectionId: STORE_USER_ID,
                                context: context,
                                function: () {
                                  Get.back();
                                  storeUserData.setInt(INCOME, a.toInt());
                                  Api().addDataFromUi(
                                      fields: {
                                        "dateNow":DateTime.now(),
                                        "title":inc_bal.tr,
                                        "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                                        "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                                        "value":"Income Updated to ₹$a",
                                      },
                                      collectionUser: STORE_NOTI,
                                      collectionId: STORE_NOTI_EMAIL,
                                      context: context
                                  );
                                  Utils().snackBar(context, "Income Updated Successfully");
                                }, docID: value.docs[0].id,
                              );
                            });
                          }else{
                            Api().getFCMtoken(
                                collectionUser: STORE_USER,
                                collectionId: STORE_USER_ID
                            ).then((value){
                              Api().updateDataFromUi(
                                fields: {
                                  'userId':Api().fireBaseUser!.uid,
                                  'DOB':storeUserData.getString(DOB),
                                  'email':storeUserData.getString(EMAIL),
                                  'password':storeUserData.getString(PASSWORD),
                                  'name':ctl.text,
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
                                  setState((){
                                    storeUserData.setString(NAME, ctl.text);
                                    Api().addDataFromUi(
                                        fields: {
                                          "dateNow":DateTime.now(),
                                          "title":prof_bi.tr,
                                          "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                                          "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                                          "value":"Name Updated to ${ctl.text}",
                                        },
                                        collectionUser: STORE_NOTI,
                                        collectionId: STORE_NOTI_EMAIL,
                                        context: context
                                    );
                                    Get.offAll(const Home());
                                  });
                                  Utils().snackBar(context, "Name Updated Successfully");
                                }, docID: value.docs[0].id,
                              );
                            });
                          }
                        }
                    )
                  ],
                );
              },),
          );
      },

    );
  }
}
