import 'package:expense_tracker/controls/get_controller.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controls/text.dart';
import 'color_const.dart';
import 'constants.dart';

class Utils{
  RegExp pattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  log(Object? value){
    if(kDebugMode){
      print(value);
    }
  }

  snackBar(BuildContext context,String content){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(milliseconds: 1500),
          content:CText(text: content))
    );
  }

  bool validateEmail(String? email){
    if(email!.contains(pattern)){
      return true;
    }
    return false;
  }

  String formatDate(DateTime date,DateFormat format){
    return format.format(date);
  }

  String getImage(int statusId){
    if(statusId==1){
      return "food.png";
    }else if(statusId==2){
      return "travel.png";
    }else if(statusId==3){
      return "subscription.png";
    }else if(statusId==4){
      return "bills.png";
    }else if(statusId==5){
      return "shopping-bag.png";
    }else if(statusId==6){
      return "entertainment.png";
    }else{
      return "others.png";
    }
  }

  Color getColor(int statusId){
    if(statusId==1){
      return AppTheme.red20;
    }else if(statusId==2){
      return AppTheme.blueLight;
    }else if(statusId==3){
      return AppTheme.violetLight;
    }else if(statusId==4){
      return AppTheme.billsLight;
    }else if(statusId==5){
      return AppTheme.yellowLight;
    }else if(statusId==6){
      return AppTheme.enterLight;
    }else{
      return AppTheme.othersLight;
    }
  }

  Widget primaryButton(BuildContext context,String content,VoidCallback onTab){
    var currentWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        height: 58,
        width: currentWidth-100,
        child: ElevatedButton(onPressed: onTab,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                CText(
                  text: content,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTheme.big,
                  textColor: AppTheme.white,
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: AppTheme.darkPrimary,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("${ASSET_PATH}right_button.png"),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getAlertButton(BuildContext context,String cancelContent,String confirmContent,VoidCallback onCancel,VoidCallback onSubmit){
    var currentWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onCancel,
          child: Container(
            height: 50,
            width: currentWidth/2-68,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                // color: AppTheme.red.withOpacity(0.7),
              border: Border.all(color: AppTheme.red,width: 1.5)
            ),
            child: Center(
              child: CText(
                text: cancelContent,
                textColor: AppTheme.red,
                fontWeight: FontWeight.w500,
                fontSize: AppTheme.medium_15,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            height: 50,
            width: currentWidth/2-68,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppTheme.colorPrimary
            ),
            child: Center(
              child: CText(
                text: confirmContent,
                textColor: AppTheme.white,
                fontWeight: FontWeight.w500,
                fontSize: AppTheme.medium_15,
              ),
            ),
          ),
        )
      ],
    );
  }


  Widget cTextField(
      BuildContext context,
      TextEditingController controller,
      String hintText,
      TextInputType textType,
      bool obsure,
      bool read,
      VoidCallback onSuffix,
      List<TextInputFormatter> inputFormatter,
      String prefixImageLocation,
      String suffixImageLocation){
    var currentWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: currentWidth-80,
      child: TextField(
        controller: controller,
        obscureText: obsure,
        obscuringCharacter: "*",
        readOnly: read,
        keyboardType: textType,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.white,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppTheme.grey,
              fontSize: AppTheme.medium
            ),
            suffixIcon: suffixImageLocation==""?null:GestureDetector(
              onTap: onSuffix,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12,end: 12),
                child: Image.asset(
                  color: AppTheme.grey,
                    "${ASSET_PATH}$suffixImageLocation"),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
                maxHeight: 48,
                maxWidth: 48
            ),
          suffixIconConstraints: const BoxConstraints(
              maxHeight: 48,
              maxWidth: 48
          ),
            prefixIcon: prefixImageLocation==""?null:Padding(
              padding: const EdgeInsetsDirectional.only(start: 12,end: 12),
              child: Image.asset(
                color: AppTheme.grey,
                  "${ASSET_PATH}$prefixImageLocation"),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color:AppTheme.grey.withOpacity(0.6),width: 0.5)
            ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color:AppTheme.grey.withOpacity(0.6),width: 0.5)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color:AppTheme.grey.withOpacity(0.6),width: 0.5)
          ),
        ),
      ),
    );
  }

  Widget cardList(
      BuildContext context,
      String image,
      List<Expenses> list,
      int index,
      Color color,
      VoidCallback navigation
      ){
    var currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: navigation,
      child: Card(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: color
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset("${ASSET_PATH}$image"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CText(
                        text: list[index].status,
                        fontWeight: FontWeight.w600,
                        fontSize: AppTheme.large,
                      ),
                      CText(
                        text: list[index].filter,
                        textColor: AppTheme.grey,
                        fontSize: AppTheme.thirteen,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CText(
                    text: "₹${list[index].amount}",
                    fontWeight: FontWeight.w600,
                    fontSize: AppTheme.large,
                    textColor: AppTheme.red,
                  ),
                  CText(
                    text: list[index].time,
                    textColor: AppTheme.grey,
                    fontSize: AppTheme.medium_15,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget budgetCard(BuildContext context,String moneyIncome,String moneyExpense){
    var currentWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height:currentWidth>SIZE_600?88:80,
          width:currentWidth>SIZE_600?176:currentWidth/2-19,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppTheme.green
          ),
          child: Padding(
            padding: EdgeInsets.all(currentWidth>SIZE_600?14:10),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                        height: 32,
                        width: 32,
                        "${ASSET_PATH}income.png"),
                  ),
                ),
                const SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CText(
                      text: inc_bal.tr,
                      textColor: AppTheme.white,
                    ),
                    CText(
                      text: "₹$moneyIncome",
                      textColor: AppTheme.white,
                      fontSize: AppTheme.big,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          height:currentWidth>SIZE_600?88:80,
          width:currentWidth>SIZE_600?176:currentWidth/2-19,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppTheme.red
          ),
          child: Padding(
            padding: EdgeInsets.all(currentWidth>SIZE_600?14:10),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                        height: 32,
                        width: 32,
                        "${ASSET_PATH}expense.png"),
                  ),
                ),
                const SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CText(
                      text: exp_bal.tr,
                      textColor: AppTheme.white,
                    ),
                    CText(
                      text: "₹$moneyExpense",
                      textColor: AppTheme.white,
                      fontSize: AppTheme.big,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

}