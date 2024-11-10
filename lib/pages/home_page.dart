import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controls/text.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/pages/notification.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';
import '../utils/store_user_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{

  var currentWidth =0.0;
  var storeUserData = StoreUserData();
  num accBalance = 0;
  String noData = "";
  num expense = 0;
  TabController? tabController;
  var isAll=true,
      isFood=false,
      isTrav=false,
      isRech=false,
      isElec=false,
      isShop=false,
      isEnt=false,
      isOth=false,
      isLoading = false;
  List<Expenses> wholeList=[];
  var amountList = [];
  var previousMonth = [];
  List<Expenses> foodList = [];
  List<Expenses> transport = [];
  List<Expenses> subs = [];
  List<Expenses> bills = [];
  List<Expenses> shp = [];
  List<Expenses> enter = [];
  List<Expenses> other = [];
  var tabs = [
     Tab(
      text: all_bi.tr,
    ), Tab(
      text: food_bi.tr,
    ), Tab(
      text: trans_bi.tr,
    ), Tab(
      text: subs_bi.tr,
    ), Tab(
      text: bill_bi.tr,
    ), Tab(
      text: shop_bi.tr,
    ), Tab(
      text: ente_bi.tr,
    ), Tab(
      text: othe_bi.tr,
    ),
  ];

  List<Expenses> expenseList = [];

  var categories = [
    {
      "statusId":1,
      "status":"Food",
      "notes":"Food is rule",
      "amount":23,
      "time":DateTime.now(),
    },
    {
      "statusId":2,
      "status":"Transportation",
      "notes":"Transportation is rule",
      "amount":100,
      "time":DateTime.now(),
    },
    {
      "statusId":3,
      "status":"Subscription",
      "notes":"Subscription is rule",
      "amount":198,
      "time":DateTime.now(),
    },
    {
      "statusId":4,
      "status":"Bills",
      "notes":"Bills is rule",
      "amount":198,
      "time":DateTime.now(),
    },
    {
      "statusId":5,
      "status":"Shopping",
      "notes":"Shopping is rule",
      "amount":500,
      "time":DateTime.now(),
    },
    {
      "statusId":6,
      "status":"Entertainment",
      "notes":"Entertainment is rule",
      "amount":198,
      "time":DateTime.now(),
    },
    {
      "statusId":7,
      "status":"Other",
      "notes":"Other is rule",
      "amount":198,
      "time":DateTime.now(),
    },
  ];


  getExpense() async{
    setState(() {
      isLoading=true;
    });
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await Api().getDataFromFire(
        collectionUser: STORE_EXPENSE,
        collectionId: STORE_EXPENSE_EMAIL);
    expenseList=snapshot.docs
        .map((docSnap)=>Expenses.fromJson(docSnap)).toList();
    setState(() {
      if(expenseList.isNotEmpty){
        wholeList.addAll(expenseList);
        loop(tabController!.index);
        isLoading=false;
      }else{
        isLoading=false;
        noData="No Data Found!";
      }
    });
  }

  @override
  void initState() {
    getExpense();
    tabController=TabController(length: tabs.length, vsync: this);
    tabController!.addListener((){
      setState(() {
        getExpense();
        loop(tabController!.index);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: const DecorationImage(
                                image: NetworkImage("https://www.pngall.com/wp-content/uploads/5/Profile.png"),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(const NotificationScreen());
                          },
                          child: Image.asset(
                              height: 32,
                              width: 32,
                              "${ASSET_PATH}notifiaction.png"),
                        )
                      ],
                    ),
                    const SizedBox(height: 4,),
                     CText(text: acc_bal.tr),
                    CText(
                        text: "₹$accBalance",
                      fontSize: AppTheme.ultraBig_40,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4,),
                    Utils().budgetCard(
                        context,
                        "${storeUserData.getInt(INCOME)}",
                        "${getAmount()}"),
                    SizedBox(height: currentWidth>SIZE_600?26:22,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: AppTheme.white,width: 1)
                      ),
                      child: TabBar(
                        dividerColor: AppTheme.transparent,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppTheme.white,
                        physics: const BouncingScrollPhysics(),
                        indicatorPadding: const EdgeInsets.only(top: 2,bottom: 2),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppTheme.large,
                        ),
                        textScaler: const TextScaler.linear(1),
                        unselectedLabelColor: AppTheme.colorPrimary,
                        indicator: BoxDecoration(
                          color: AppTheme.colorPrimary,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        tabs: tabs,
                        onTap: (value){
                          setState(() {
                            getExpense();
                            loop(value);
                          });
                        },
                        controller: tabController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                          children:[
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                            listViews(context, wholeList,tabController!.index),
                          ]
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loop (int tabIndex){
    setState(() {
      amountList.clear();
      wholeList.clear();
      transport.clear();
      foodList.clear();
      other.clear();
      enter.clear();
      shp.clear();
      bills.clear();
      subs.clear();
      // for(var i in categories){
      //  // if(i["Month"]==DateTime.now().month){
      //     //amountList.add(i["amount"]);
      //   if(tabIndex==0){
      //     wholeList.add(i);
      //   }
      //     if(tabIndex==1){
      //       if(i["statusId"]==1){
      //        // individualAmount+=i["amount"];
      //         foodList.add(i);
      //         wholeList.clear();
      //         wholeList.addAll(foodList);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(foodList);
      //       }
      //     }if(tabIndex==2){
      //       if(i["statusId"]==2){
      //         //individualAmount+=i["amount"];
      //         transport.add(i);
      //         wholeList.clear();
      //         wholeList.addAll(transport);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(transport);
      //       }
      //     }if(tabIndex==3){
      //       if(i["statusId"]==3){
      //         //individualAmount+=i["amount"];
      //         subs.add(i);
      //         wholeList.clear();
      //         wholeList.addAll(subs);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(subs);
      //       }
      //     }if(tabIndex==4){
      //       if(i["statusId"]==4){
      //         //individualAmount+=i["amount"];
      //         bills.add(i);
      //         wholeList.clear();
      //         wholeList.addAll(bills);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(bills);
      //       }
      //     }if(tabIndex==5){
      //       if(i["statusId"]==5){
      //         shp.add(i);
      //         wholeList.clear();
      //        // individualAmount+=i["amount"];
      //         //print(individualAmount);
      //         wholeList.addAll(shp);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(shp);
      //       }
      //     }if(tabIndex==6){
      //       if(i["statusId"]==6){
      //         enter.add(i);
      //         //individualAmount+=i["amount"];
      //         wholeList.clear();
      //         wholeList.addAll(enter);
      //       }else{
      //         wholeList.clear();
      //         wholeList.addAll(enter);
      //       }
      //     }if(tabIndex==7){
      //       if(i["statusId"]==7){
      //         other.add(i);
      //         wholeList.clear();
      //         wholeList.addAll(other);
      //       }else{
      //         //individualAmount+=i["amount"];
      //         wholeList.clear();
      //         wholeList.addAll(other);
      //       }
      //     }
      //   //}
      //   // if(i["Month"]==DateTime.now().month-1){
      //   //   previousAmountList.add(i["amount"]);
      //   // }
      // }
      for(var i in expenseList) {
        if(i.month==DateTime.now().month){
          amountList.add(i.amount);
          if(tabIndex==0){
            wholeList.add(i);
          }
          if(tabIndex==1){
            if(i.statusId==1){
              // individualAmount+=i["amount"];
              foodList.add(i);
              wholeList.clear();
              wholeList.addAll(foodList);
            }else{
              wholeList.clear();
              wholeList.addAll(foodList);
            }
          }
          if(tabIndex==2){
            if(i.statusId==2){
              //individualAmount+=i["amount"];
              transport.add(i);
              wholeList.clear();
              wholeList.addAll(transport);
            } else{
              wholeList.clear();
              wholeList.addAll(transport);
            }
          }
          if(tabIndex==3){
            if(i.statusId==3){
              //individualAmount+=i["amount"];
              subs.add(i);
              wholeList.clear();
              wholeList.addAll(subs);
            }else{
              wholeList.clear();
              wholeList.addAll(subs);
            }
          }
          if(tabIndex==4){
            if(i.statusId==4){
              //individualAmount+=i["amount"];
              bills.add(i);
              wholeList.clear();
              wholeList.addAll(bills);
            }else{
              wholeList.clear();
              wholeList.addAll(bills);
            }
          }
          if(tabIndex==5){
            if(i.statusId==5){
              shp.add(i);
              wholeList.clear();
              // individualAmount+=i["amount"];
              //print(individualAmount);
              wholeList.addAll(shp);
            }else{
              wholeList.clear();
              wholeList.addAll(shp);
            }
          }
          if(tabIndex==6){
            if(i.statusId==6){
              enter.add(i);
              //individualAmount+=i["amount"];
              wholeList.clear();
              wholeList.addAll(enter);
            }else{
              wholeList.clear();
              wholeList.addAll(enter);
            }
          }
          if(tabIndex==7){
            if(i.statusId==7){
              other.add(i);
              wholeList.clear();
              wholeList.addAll(other);
            }else{
              //individualAmount+=i["amount"];
              wholeList.clear();
              wholeList.addAll(other);
            }
          }
        }
        if(i.month==DateTime.now().month-1){
          previousMonth.add(i.amount);
        }
      }
      getAmount();
      setState(() {
        //wholeList.addAll(categories);
        accBalance=storeUserData.getInt(INCOME)-getAmount();
      });
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

  Widget listViews(BuildContext context,List<Expenses> list,int tabIndex){
    return Flex(
        direction: Axis.vertical,
      children: [
        Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child:
              isLoading==false
              ?ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {

                  return Utils().cardList(
                      context,
                      Utils().getImage(list[index].statusId!),
                      list,
                      index,
                      Utils().getColor(list[index].statusId!)
                  );
                },

              )
              :Center(
                child: expenseList.isEmpty && isLoading==false
                ?Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CText(
                      text: noData,
                      fontSize: AppTheme.large,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.colorPrimary,
                    ),
                  ],
                )
                :Column(
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
              ),
            )
        )
      ],
    );
  }
}
