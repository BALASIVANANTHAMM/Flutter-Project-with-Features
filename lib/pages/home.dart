import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controls/text.dart';
import 'package:expense_tracker/pages/account_page.dart';
import 'package:expense_tracker/pages/analytics_page.dart';
import 'package:expense_tracker/pages/expense_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:expense_tracker/utils/color_const.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../models/profile_model.dart';
import '../utils/api.dart';
import '../utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var storeUserData = StoreUserData();
  var isFilter = true,isSort = false,isLoading = true;
  final amountCtl = TextEditingController();
  final notesCtl = TextEditingController();
  List<Profile> profile=[];
  String? initialValue;
  var menuItems = [
    food_bi.tr,
    trans_bi.tr,
    subs_bi.tr,
    bill_bi.tr,
    shop_bi.tr,
    ente_bi.tr,
    othe_bi.tr
  ];
  List<IconData> icons = const [
    Icons.home,
    Icons.swap_horiz,
    Icons.pie_chart,
    Icons.person
  ];
  var currentWidth = 0.0;
  List<String> text = [
    home_bi.tr,
    exp_bal.tr,
    anal_bi.tr,
    prof_bi.tr,
  ];
  int bottomNavIndex=0;

  @override
  void initState() {
    menuItems;
    text;
    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        isLoading=false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentWidth=MediaQuery.of(context).size.width;
    return
      isLoading==false
      ?Scaffold(
      body: IndexedStack(
        index: bottomNavIndex,
        children: const [
          Dashboard(),
          ExpensePage(),
          AnalyticsPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colorPrimary,
          shape: const CircleBorder(),
          onPressed: (){
            showBottomAdd();
          },
          child: const Icon(
            Icons.add,
            size: 34,
            color: AppTheme.white,
          )
      ),
      bottomNavigationBar:AnimatedBottomNavigationBar.builder(
          itemCount: icons.length,
          height: currentWidth/6.4,
          splashRadius: 0,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index],
                  size: 24,
                  color: isActive ? AppTheme.colorPrimary : AppTheme.grey,
                ),
                CText(
                  text: text[index],
                  overflow: TextOverflow.ellipsis,
                  textColor: isActive ? AppTheme.colorPrimary : AppTheme.grey,
                ),
              ],
            );
          },
          gapLocation: GapLocation.center,
          activeIndex: bottomNavIndex,
          leftCornerRadius: 10,
          rightCornerRadius: 10,
          onTap: (int index){
            setState(() {
              bottomNavIndex=index;
            });
          }
      )
    ): Scaffold(
        body:  Center(
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

  void showBottomAdd(){
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      builder: (BuildContext context) {
        return Container(
          height: currentWidth*1.8,
          width: currentWidth,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16)
            )
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                        height: 10,
                        width: 30,
                        "${ASSET_PATH}line_bottom.png"
                    ),
                    const SizedBox(height: 10,),
                    CText(
                      text: add_bi.tr,
                      fontSize: AppTheme.large,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        CText(
                          text: fil_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    getSort(isFilter, (){
                      setState((){
                        isFilter=true;
                      });
                    }, (){
                      setState((){
                        isFilter=false;
                      });
                    }, exp_bal.tr, tr_bi.tr),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        CText(
                          text: so_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    getSort(isSort, (){
                      setState((){
                        isSort=true;
                      });
                    }, (){
                      setState((){
                        isSort=false;
                      });
                    }, hi_bi.tr, low_bi.tr),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        CText(
                          text: ex_am_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Utils().cTextField(
                          context,
                          amountCtl,
                          en_am_hint.tr,
                          TextInputType.number,
                          false,
                          (){},
                          [FilteringTextInputFormatter.digitsOnly],
                          "person.png",
                          ""
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        CText(
                          text: not_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Utils().cTextField(
                          context,
                          notesCtl,
                          not_hint.tr,
                          TextInputType.text,
                          false,
                              (){},
                          [FilteringTextInputFormatter.singleLineFormatter],
                          "bills.png",
                          ""
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          text: ch_ca_bi.tr,
                          fontSize: AppTheme.medium,
                          fontWeight: FontWeight.w600,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppTheme.white
                          ),
                          child: DropdownButton(
                            isDense: false,
                            value: initialValue,
                            underline: const Text(""),
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            hint:  Flexible(
                                flex: 1,
                                child: CText(text:sel_ca_bi.tr,overflow: TextOverflow.ellipsis,)),
                            icon: Image.asset(
                                height: 24,
                                width: 24,
                                "${ASSET_PATH}down_arrow.png"),
                            items: menuItems.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Flexible(child: CText(text: items,overflow: TextOverflow.ellipsis,)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                initialValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    SizedBox(
                      height: 50,
                      width: currentWidth-40,
                      child: ElevatedButton(
                          onPressed: (){
                            num a = num.parse(amountCtl.text);
                            Api().addDataFromUi(
                                fields: {
                                  "userId":Api().fireBaseUser!.uid,
                                  "filter":isFilter==true?exp_bal.tr:tr_bi.tr,
                                  "sort":isSort==true?hi_bi.tr:low_bi.tr,
                                  "amount":a,
                                  "notes":notesCtl.text,
                                  "status":initialValue,
                                  "statusId":menuItems.indexOf(initialValue!)+1,
                                  "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                                  "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                                  "month":DateTime.now().month,
                                  "utc":DateTime.now(),
                                  "name":storeUserData.getString(NAME),
                                  "email":storeUserData.getString(EMAIL),
                                  "income":storeUserData.getInt(INCOME)
                                },
                                collectionUser: STORE_EXPENSE,
                                collectionId: STORE_EXPENSE_EMAIL,
                                context: context
                            );
                            setState((){
                              amountCtl.clear();
                              Get.offAll(const Home());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.colorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13)
                              )
                          ),
                          child: CText(
                            text: sub_btn.tr,
                            textColor: AppTheme.white,
                            fontSize: AppTheme.medium_15,
                            fontWeight: FontWeight.w500,
                          )
                      ),
                    )
                  ],
                ),
              );
            },),
        );
      },
    );
  }
  Widget getSort(bool isExpense,VoidCallback c1,VoidCallback c2,String con1,String con2){
    return Row(
      children: [
        GestureDetector(
          onTap: c1,
          child: Container(
            height: 45,
            width: currentWidth/4,
            decoration: BoxDecoration(
                color: isExpense==false?AppTheme.white:AppTheme.colorPrimary,
                borderRadius: BorderRadius.circular(24),
                border: isExpense==false?Border.all(
                    color: AppTheme.grey.withOpacity(0.5),
                    width: 1
                ):Border.all(
                    color: AppTheme.colorPrimary
                )
            ),
            child: Center(
              child: CText(
                text: con1,
                textColor: isExpense==false?AppTheme.black:AppTheme.white,
                fontWeight: FontWeight.w500,
                fontSize: AppTheme.medium,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8,),
        GestureDetector(
          onTap: c2,
          child: Container(
            height: 45,
            width: currentWidth/4,
            decoration: BoxDecoration(
                color: isExpense==true?AppTheme.white:AppTheme.colorPrimary,
                borderRadius: BorderRadius.circular(24),
                border: isExpense==true?Border.all(
                    color: AppTheme.grey.withOpacity(0.5),
                    width: 1
                ):Border.all(
                    color: AppTheme.colorPrimary
                )
            ),
            child: Center(
              child: CText(
                text: con2,
                textColor: isExpense==true?AppTheme.black:AppTheme.white,
                fontWeight: FontWeight.w500,
                fontSize: AppTheme.medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
