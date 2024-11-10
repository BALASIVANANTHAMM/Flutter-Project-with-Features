import 'package:expense_tracker/pages/login_screen.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controls/text.dart';
import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var currentWidth =0.0;
  String? docId;
  var dob;
  final nameCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final dobCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();
  final incomeCtl = TextEditingController();
  bool pass=true;

  @override
  Widget build(BuildContext context) {
    currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
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
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 15,),
                      CText(text: sign_up.tr,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        fontSize: AppTheme.big,),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Utils().cTextField(
                      context,
                      nameCtl,
                      n_hint.tr,
                      TextInputType.text,
                      false,
                      false,
                          (){},
                      [FilteringTextInputFormatter.singleLineFormatter],
                      "person.png",
                      ""),
                  const SizedBox(height: 15,),
                  Utils().cTextField(
                      context,
                      emailCtl,
                      e_hint.tr,
                      TextInputType.text,
                      false,
                      false,
                          (){},
                      [FilteringTextInputFormatter.singleLineFormatter],
                      "mail.png",
                      ""),
                  const SizedBox(height: 15,),
                  Utils().cTextField(
                      context,
                      dobCtl,
                      dob_si.tr,
                      TextInputType.text,
                      false,
                      true,
                          (){
                        selectDate();
                      },
                      [FilteringTextInputFormatter.singleLineFormatter],
                      "",
                      "calender.png"),
                  const SizedBox(height: 15,),
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
                  const SizedBox(height: 15,),
                  Utils().cTextField(
                      context,
                      confirmPasswordCtl,
                      c_hint.tr,
                      TextInputType.text,
                      true,
                      false,
                          (){},
                      [FilteringTextInputFormatter.singleLineFormatter],
                      "password.png",
                      ""),
                  const SizedBox(height: 20,),
                  Utils().primaryButton(context,sign_1.tr.toUpperCase(),(){
                    if(passwordCtl.text!=confirmPasswordCtl.text){
                      Utils().snackBar(context,"Password Not Same");
                    }else if(Utils().validateEmail(emailCtl.text)==false){
                      Utils().snackBar(context,"Invalid Email");
                    }else if(nameCtl.text.isEmpty){
                      Utils().snackBar(context,"Please enter your name");
                    } else if(dobCtl.text.isEmpty){
                      Utils().snackBar(context,"Please select your DOB");
                    }else{
                      dialogToUpdate();
                    }
                  }),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       CText(text:"${sign_al.tr} "),
                      GestureDetector(
                        onTap: (){
                          Get.to(const LoginScreen());
                        },
                        child: CText(
                          text:sign_1.tr,
                        textColor: AppTheme.colorPrimary,),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
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
                    text: "Please Enter Your \nIncome",
                    fontSize: AppTheme.big,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 10,),
                  Utils().cTextField(
                      context,
                      incomeCtl,
                      "Enter Income Here",
                      TextInputType.number,
                      false,
                      false,
                          (){},
                      [FilteringTextInputFormatter.digitsOnly],
                      "salery.png",
                      ""
                  ),
                  const SizedBox(height: 28,),
                  Utils().getAlertButton(
                      context,
                      "Cancel",
                      "Submit",
                          (){
                        Get.back();
                      },
                          ()async{
                        if(incomeCtl.text.isNotEmpty){
                          String? fcm = await Api().firebaseMessaging.getToken();
                          Api()
                              .getDataFromFireSS(
                              collectionUser: STORE_USER,
                              collectionId: STORE_USER_ID).then((value){
                            docId=value;
                          });
                          setState((){
                            num a = num.parse(incomeCtl.text);
                          Future.delayed(const Duration(seconds: 2),(){
                            Api().createUserWithEmailAndPassword(
                                emailCtl.text,
                                passwordCtl.text,
                                    (){
                                  Api().addDataFromUi(
                                      fields: {
                                        'userId':Api().fireBaseUser!.uid,
                                        'DOB':dobCtl.text,
                                        'email':emailCtl.text,
                                        'password':passwordCtl.text,
                                        'name':nameCtl.text,
                                        'Date':"${Utils().formatDate(DateTime.now(),DateFormat.yMMMd())}  ${Utils().formatDate(DateTime.now(),DateFormat.jm())}",
                                        'Income':a,
                                        'docId':docId,
                                        'fcm':fcm,
                                        'isActive':true
                                      },
                                      collectionUser: STORE_USER,
                                      collectionId: STORE_USER_ID,
                                      context: context
                                  );
                                  Api().addDataFromUi(
                                      fields: {
                                        "dateNow":DateTime.now(),
                                        "title":"Acc Created",
                                        "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                                        "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                                        "value":"Account Created in ${Utils().formatDate(DateTime.now(), DateFormat.yMMMd().add_jm())}",
                                      },
                                      collectionUser: STORE_NOTI,
                                      collectionId: STORE_NOTI_EMAIL,
                                      context: context
                                  );
                                  Get.offAll(const LoginScreen());
                                },
                                context
                            );
                          });
                          });
                        }else{
                          Utils().snackBar(context,"Income Shouldn't be Empty");
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

  selectDate(){
    showDialog(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.circular(10)
                  ),
                  width: currentWidth-40,
                  height: currentWidth,
                  child: SfDateRangePicker(
                    selectionColor: AppTheme.colorPrimary,
                    backgroundColor: AppTheme.white,
                    onSubmit: (value){
                      setState(() {
                        dob = value;
                        dobCtl.text=DateFormat.yMMMd().format(dob);
                        print(dob);
                        Get.back();
                      });
                    },
                    showActionButtons: true,
                    confirmText: "Submit",
                    cancelText: "No",
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: AppTheme.white,
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        color: AppTheme.colorPrimary,
                        fontSize: AppTheme.large,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    showNavigationArrow: true,
                    minDate: DateTime(1900),
                    maxDate: DateTime(2025),
                    todayHighlightColor: AppTheme.colorPrimary,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                )
              ],
            ),
          );
      },
    );
  }
}
