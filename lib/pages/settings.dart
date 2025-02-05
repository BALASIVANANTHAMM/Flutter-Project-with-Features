import 'package:about/about.dart';
import 'package:expense_tracker/controls/get_controller.dart';
import 'package:expense_tracker/controls/secure_storage.dart';
import 'package:expense_tracker/pages/change_password.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controls/text.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';
import '../utils/store_user_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  var currentWidth = 0.0;
  bool isLoading=true;
  bool security=false;
  String? initialValue;
  String? secureStore;
  var storeUserData=StoreUserData();
  var controller = LangController();
  var menuItems = [
    "தமிழ்",
    "English"
  ];
  var bioStore= BioStorage();

  final aboutPage = AboutPage(
    values: {
      'version': "1.0.0+1",
      'year': DateTime.now().year.toString(),
      'author': "balasivanantham",
    },
    title: const Text('About'),
    applicationVersion: 'Version {{ version }}',
    applicationDescription: const Text(
      "This App purpose is new feature included to track the monthy expenses",
      textAlign: TextAlign.justify,
    ),
    applicationIcon: Image.asset(
        height: 100,
        width: 100,
        "${ASSET_PATH}app_logo.png"),
    applicationLegalese: 'Copyright © {{ author }}, {{ year }}',
    children: const <Widget>[
      MarkdownPageListTile(
        filename: 'LICENSE.md',
        title: Text('View License'),
        icon: Icon(Icons.description),
      ),
      MarkdownPageListTile(
        filename: 'CODE_OF_CONDUCT.md',
        title: Text('Code of conduct'),
        icon: Icon(Icons.sentiment_satisfied),
      ),
      LicensesPageListTile(
        title: Text('Open source Licenses'),
        icon: Icon(Icons.favorite),
      ),
    ],
  );

  bool getValue(){
    secureStore=bioStore.getString(security_secure);
    Utils().log(bioStore.getString(security_secure));
    if(secureStore!.isNotEmpty){
      security = true;
      return true;
    }else{
      security=false;
      return false;
    }
  }

  @override
  void initState() {
    setState(() {
      if(storeUserData.getString(LANG)=="ta"){
        initialValue="தமிழ்";
      }
      if(storeUserData.getString(LANG)=="en"){
        initialValue="English";
      }
      // getValue();
    });
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
                          text: set_bi.tr,
                          fontSize: AppTheme.large,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 15,),
                      ],
                    ),
                    const SizedBox(height: 24,),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: AppTheme.white,
                    //     borderRadius: BorderRadius.circular(15)
                    //   ),
                    //   child: SwitchListTile(
                    //     title: CText(
                    //         text: sec_bi.tr,
                    //       fontSize: AppTheme.medium,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //       value: security,
                    //       activeTrackColor: AppTheme.colorPrimary,
                    //       onChanged: (value)async{
                    //         setState(() {
                    //           security=!security;
                    //         });
                    //       }),
                    // ),
                    Container(
                      margin: EdgeInsets.only(
                        top: currentWidth>SIZE_600?20:10
                      ),
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: ListTile(
                        leading: CText(
                            text: lang_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppTheme.white
                          ),
                          child: DropdownButton(
                            isDense: false,
                            value: initialValue,
                            underline: const Text(""),
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.only(left: 10),
                            hint: const Text("Select Language"),
                            icon: Image.asset(
                                height: 24,
                                width: 24,
                                "${ASSET_PATH}down_arrow.png"),
                            items: menuItems.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                initialValue = newValue!;
                                if(initialValue=="தமிழ்"){
                                  storeUserData.setString(LANG, "ta");
                                  storeUserData.setString(COUN, "LK");
                                  controller.changeLocale("ta", "LK");
                                  Get.offAll(const Home());
                                }else{
                                  storeUserData.setString(LANG, "en");
                                  storeUserData.setString(COUN, "US");
                                  controller.changeLocale("en", "US");
                                  Get.offAll(const Home());
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(const ChangePassword());
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: currentWidth>SIZE_600?20:10
                        ),
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ListTile(
                          leading: CText(
                            text: ch_pa_bi.tr,
                            fontSize: AppTheme.medium,
                            fontWeight: FontWeight.w600,
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppTheme.white
                            ),
                            child: Image.asset(
                                height: 24,
                                width: 24,
                                "${ASSET_PATH}right_arrow.png"),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(aboutPage);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: currentWidth>SIZE_600?20:10
                        ),
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ListTile(
                          leading: CText(
                            text: ab_se.tr,
                            fontSize: AppTheme.medium,
                            fontWeight: FontWeight.w600,
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppTheme.white
                            ),
                            child: Image.asset(
                                height: 24,
                                width: 24,
                                "${ASSET_PATH}right_arrow.png"),
                          ),
                        ),
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
}
