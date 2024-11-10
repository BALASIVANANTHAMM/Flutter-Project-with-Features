import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/login_screen.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controls/text.dart';
import '../models/expense_model.dart';
import '../utils/Utils.dart';
import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var currentWidth =0.0;
  var storeUserData = StoreUserData();
  num accBalance = 0;
  num expense = 0;
  List<Expenses> expenseList = [];
  List<Expenses> wholeList = [];
  var amountList = [];
  bool isLoading = false;

  getExpense() async{
    setState(() {
      isLoading=true;
      amountList.clear();
      wholeList.clear();
    });
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await Api().getDataFromFire(
        collectionUser: STORE_EXPENSE,
        collectionId: STORE_EXPENSE_EMAIL);
    expenseList=snapshot.docs
        .map((docSnap)=>Expenses.fromJson(docSnap)).toList();
    setState(() {
      if(expenseList.isNotEmpty){
        isLoading=false;
        wholeList.addAll(expenseList);
        for(var i in expenseList){
          amountList.add(i.amount);
        }
        getAmount();
        accBalance=storeUserData.getInt(INCOME)-getAmount();
      }else{
        isLoading=false;
      }
    });
  }
  num getAmount(){
    setState(() {
      expense=0;
      for(int i=0;i<amountList.length;i++){
        expense+=amountList[i];
      }
    });
    return expense;
  }

  @override
  void initState() {
    getExpense();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      isLoading==false
      ?Container(
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
                        text: acc_bi.tr.capitalizeFirst.toString(),
                        fontSize: AppTheme.large,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 70,),
                   CText(text: acc_bal.tr),
                  CText(
                    text: "₹$accBalance",
                    fontSize: AppTheme.ultraBig_40,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: currentWidth>SIZE_600?80:70,),
                  getCard("salery.png", inc_bal.tr, "₹${storeUserData.getInt(INCOME)}", (){

                  }),
                  getCard("trash.png", "Delete Account", "", (){
                    dialogToUpdate();
                  }),
                  getCard("calender.png", dob_si.tr, storeUserData.getString(DOB), (){

                  })

                ],
              ),
            )
          ],
        ),
      )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.colorPrimary,
            ),
            const SizedBox(height: 10,),
            CText(
                text: lod_bi.tr,
              textColor: AppTheme.black,
              fontWeight: FontWeight.w500,
              fontSize: AppTheme.medium,
            )
          ],
        ),
      ),
    );
  }
  Widget getCard(String icon,String content,String tail,VoidCallback onTab){
    return GestureDetector(
      onTap: onTab,
      child: Card(
        elevation: 0,
        color: AppTheme.white,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 20
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                      height: 28,
                      width: 28,
                      "${ASSET_PATH}$icon"),
                  const SizedBox(width: 7,),
                  CText(
                    text: content,
                    fontWeight: FontWeight.w600,
                    fontSize: AppTheme.medium,
                  )
                ],
              ),
              tail==""
              ?Image.asset(
                  height: 24,
                  width: 24,
                  "${ASSET_PATH}right_arrow.png")
              :CText(
                  text: tail,
                fontWeight: FontWeight.w600,
                fontSize: AppTheme.medium,
              )
            ],
          ),
        ),
      ),
    );
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
                    text: "Are you sure to delete \nyour account",
                    fontSize: AppTheme.big,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 28,),
                  Utils().getAlertButton(
                      context,
                      "No",
                      "Yes",
                          (){
                        Get.back();
                      },
                          (){
                        Api().updateDataFromUi(
                          fields: {
                            'userId':Api().fireBaseUser!.uid,
                            'DOB':storeUserData.getString(DOB),
                            'email':storeUserData.getString(EMAIL),
                            'password':storeUserData.getString(PASSWORD),
                            'name':storeUserData.getString(NAME),
                            'Date':storeUserData.getString(CREATE_DATE),
                            'Income':storeUserData.getInt(INCOME),
                            'docId':storeUserData.getString(DOC_ID),
                            'fcm':storeUserData.getString(FCM),
                            'isActive':false
                          },
                          collectionUser: STORE_USER,
                          collectionId: STORE_USER_ID,
                          context: context,
                          function: () {
                            Get.back();
                            storeUserData.setBoolean(IS_ACTIVE, false);
                            Api().authSignOut((){
                              storeUserData.clearData();
                              Get.offAll(const LoginScreen());
                            }, context);
                            Utils().snackBar(context, "Your Acc Has Been Deleted!");
                          }, docID: storeUserData.getString(DOC_ID),
                        );
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
