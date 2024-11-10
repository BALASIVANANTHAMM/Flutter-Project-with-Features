import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controls/text.dart';
import '../utils/Utils.dart';
import '../utils/api.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  var currentWidth =0.0;
  List<Expenses> expenseList = [];
  List<Expenses> wholeList = [];
  var income = [];
  var expense = [];
  num incomeAmount = 0;
  num expenseAmount = 0;
  num accBalance = 0;
  bool isLoading = true;
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
  int indexMonth=DateTime.now().month;
  var menuItems = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  String? initialValue;

  getExpense() async{
    setState(() {
      wholeList.clear();
      income.clear();
      expense.clear();
      expenseAmount=0;
      incomeAmount=0;
      accBalance=0;
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
        for(var i in expenseList){
          if(i.month==menuItems.indexOf(initialValue!)+1){
            wholeList.add(i);
            income.add(i.income);
            expense.add(i.amount);
          }
        }
        print(getIncomeAmount());
        print(getExpenseAmount());
        accBalance=getIncomeAmount()-getExpenseAmount();
        getExpenseAmount();
        getIncomeAmount();
        isLoading=false;
      }else{
        isLoading=false;
      }
    });
  }

  num getIncomeAmount(){
    setState(() {
      incomeAmount=0;
      for(var i in income){
        incomeAmount+=i;
      }
      incomeAmount/=income.length;
    });
    return incomeAmount;
  }
  num getExpenseAmount(){
    setState(() {
      expenseAmount=0;
      for(var i in expense){
        expenseAmount+=i;
      }
    });
    return expenseAmount;
  }

  String getMonth(int index){
    if(index==0){
      return jan_.tr.capitalizeFirst.toString();
    }
    else if(index==1){
      return feb_.tr.capitalizeFirst.toString();
    }
    else if(index==2){
      return mar_.tr.capitalizeFirst.toString();
    }
    else if(index==3){
      return apr_.tr.capitalizeFirst.toString();
    }
    else if(index==4){
      return may_.tr.capitalizeFirst.toString();
    }
    else if(index==5){
      return jun_.tr.capitalizeFirst.toString();
    }
    else if(index==6){
      return jul_.tr.capitalizeFirst.toString();
    }
    else if(index==7){
      return aug_.tr.capitalizeFirst.toString();
    }
    else if(index==8){
      return sep_.tr.capitalizeFirst.toString();
    }
    else if(index==9){
      return oct_.tr.capitalizeFirst.toString();
    }
    else if(index==10){
      return nov_.tr.capitalizeFirst.toString();
    }
    else{
      return dec_.tr.capitalizeFirst.toString();
    }
  }
  
  @override
  void initState() {
    getExpense();
    initialValue=menuItems[indexMonth-1];
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
                            color: AppTheme.colorPrimary
                        ),
                      ),
                      DropdownButton(
                        isDense: false,
                        value: initialValue,
                        underline: const Text(""),
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.only(left: 10,right: 10),
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
                            getExpense();
                          });
                        },
                      )
                    ],
                  ),
                  CText(
                    text: "${getMonth(menuItems.indexOf(initialValue!))}  ${exp_bal.tr}",
                    textColor: AppTheme.black,
                    fontWeight: FontWeight.w600,
                    fontSize: AppTheme.big,
                  ),
                  SizedBox(height: currentWidth>SIZE_600?20:10,),
                    CText(text: acc_bal.tr,textColor: AppTheme.grey,),
                  CText(
                    text: "₹${accBalance.isNaN?0:accBalance.toStringAsFixed(0)}",
                    fontSize: AppTheme.ultraBig_40,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: currentWidth>SIZE_600?20:10,),
                  Utils().budgetCard(context,
                      getIncomeAmount().isNaN?"0":getIncomeAmount().toStringAsFixed(0),
                      getExpenseAmount().isNaN?"0":getExpenseAmount().toStringAsFixed(0)),
                  SizedBox(height: currentWidth>SIZE_600?20:10,),
                  isLoading==false
                  ?listViews(context, wholeList)
                      : Center(
                    child: expenseList.isEmpty && isLoading==false
                        ?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CText(
                          text: "No Data Found!",
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget listViews(BuildContext context,List<Expenses> list){
    return Expanded(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
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

          ),
        )
    );
  }

}
