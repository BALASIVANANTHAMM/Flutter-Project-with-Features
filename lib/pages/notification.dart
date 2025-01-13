import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controls/text.dart';
import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  var currentWidth = 0.0;
  bool isLoading=true;
  List<NotificationModel> notifications = [];
  List<NotificationModel> dummyList = [];

  getNotification() async{
    setState(() {
      dummyList.clear();
      isLoading=true;
    });
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await Api().getDataFromFire(
        collectionUser: STORE_NOTI,
        collectionId: STORE_NOTI_EMAIL);
    notifications=snapshot.docs
        .map((docSnap)=>NotificationModel.fromJson(docSnap)).toList();
    setState(() {
      if(notifications.isNotEmpty){
        for(var i in notifications){
          dummyList.add(i);
        }
        isLoading=false;
      }else{
        isLoading=false;
      }
    });
  }

  @override
  void initState() {
    getNotification();
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
                        text: "Notifications",
                        fontSize: AppTheme.large,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(width: 15,),
                    ],
                  ),
                  const SizedBox(height: 24,),
                  isLoading==false
                  ?Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: dummyList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return card(dummyList,index);
                            },
                          ),
                        ),
                      )
                  :Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppTheme.colorPrimary,
                        ),
                        const SizedBox(height: 10,),
                        CText(
                          text: "Loading...",
                          textColor: AppTheme.black,
                          fontWeight: FontWeight.w500,
                          fontSize: AppTheme.medium,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget card(List<NotificationModel> list,int index){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  text: dummyList[index].title,
                  fontSize: AppTheme.big,
                  fontWeight: FontWeight.w600,
                  textColor: dummyList[index].title=="Log Out"?AppTheme.red:AppTheme.green,
                ),
                CText(
                  text: "${dummyList[index].date}",
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.medium,
                   textColor:dummyList[index].title=="Log Out"?AppTheme.red:AppTheme.green
                )
              ],
            ),
            const SizedBox(height: 5,),
            Divider(color: AppTheme.grey.withOpacity(0.4),),
            const SizedBox(height: 5,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //
            //     CText(
            //       text: dummyList[index].date,
            //       fontWeight: FontWeight.w500,
            //       fontSize: AppTheme.medium,
            //       textColor: dummyList[index].title=="Log Out"?AppTheme.red:AppTheme.green,
            //     )
            //   ],
            // ),
            CText(
              text: dummyList[index].value,
              fontSize: AppTheme.large,
              fontWeight: FontWeight.w500,
              textColor: dummyList[index].title=="Log Out"?AppTheme.red:AppTheme.green,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 5,),
            // CText(
            //   text: "Location :",
            //   fontSize: AppTheme.medium_15,
            //   fontWeight: FontWeight.w400,
            //   textColor: AppTheme.grey,
            //   overflow: TextOverflow.visible,
            // ),
            // const SizedBox(height: 5,),
            // CText(
            //   text: dummyList[index].address,
            //   fontSize: AppTheme.large,
            //   fontWeight: FontWeight.w500,
            //   textColor: AppTheme.black,
            //   overflow: TextOverflow.visible,
            // ),
          ],
        ),
      ),
    );
  }
}
