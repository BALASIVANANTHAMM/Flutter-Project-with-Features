import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/notification.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controls/text.dart';
import '../models/expense_model.dart';
import '../utils/Utils.dart';
import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  var currentWidth =0.0;
  num accBalance = 0;
  num expense = 0;
  String? inc;
  String? ex;
  List<Expenses> expenseList = [];
  List<Expenses> wholeList = [];
  var amountList = [];
  bool isLoading = false;
  var storeUserData = StoreUserData();


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
        inc=(((storeUserData.getInt(INCOME)-getAmount())/storeUserData.getInt(INCOME))*100).toStringAsFixed(1);
        ex=((getAmount()/storeUserData.getInt(INCOME))*100).toStringAsFixed(1);
        print("==================================================");
        print(inc);
        print(ex);
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
                  SizedBox(height: currentWidth>SIZE_600?26:28,),
                  Row(
                    children: [
                      CText(
                          text: anal_bi.tr,
                        fontWeight: FontWeight.w600,
                        fontSize: AppTheme.large,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: currentWidth>SIZE_600?20:5,),
                  SizedBox(
                    height: currentWidth/1.2,
                    width: currentWidth/1.2,
                    child: PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: true,
                            ),
                            centerSpaceRadius: 0,
                            sectionsSpace: 0,
                            sections: [
                              PieChartSectionData(
                                value: ((storeUserData.getInt(INCOME)-getAmount())/storeUserData.getInt(INCOME))*100,
                                color: AppTheme.green,
                                radius: 120,
                                title: "${inc ?? 100}%",
                                titleStyle: TextStyle(
                                    fontSize: AppTheme.large,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.white
                                ),
                              ),
                              PieChartSectionData(
                                  value: (getAmount()/storeUserData.getInt(INCOME))*100,
                                  color: AppTheme.red,
                                  radius: 112,
                                  title: "$ex%",
                                  titleStyle: TextStyle(
                                      fontSize: AppTheme.large,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.white
                                  ),
                              ),
                            ]
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: currentWidth>SIZE_600?30:20
                    ),
                    elevation: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppTheme.green
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Image.asset("${ASSET_PATH}thumbs-up.png"),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: CText(
                                text: "${ex ?? getAmount()}% ${slog.tr}",
                              fontSize: AppTheme.large,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
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
