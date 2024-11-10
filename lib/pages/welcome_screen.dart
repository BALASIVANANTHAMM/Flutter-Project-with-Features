import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/color_const.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  var currentWidth =0.0;
  var storeUserData = StoreUserData();
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
  late final Animation<Offset> _offsetAnimation2 = Tween<Offset>(
    begin: const Offset(0.3, 0),
    end:  Offset.zero,
  ).animate(_animationController);

  @override
  void initState() {
    _animationController.forward();
    _animationController.addListener((){
      if(_animationController.status==AnimationStatus.completed){
        _animationController.reverse();
      }else if(_animationController.status==AnimationStatus.dismissed){
        _animationController.forward();
      }
    });
    Future.delayed(Duration(milliseconds: 200),(){
      showBottomSheet();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            child: SlideTransition(
              position: _offsetAnimation2,
              child: Image.asset(
                  height: SIZE_146,
                  width: SIZE_162,
                  "${ASSET_PATH}circle2.png"
              ),
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
          Positioned(
            top: 250,
            left: currentWidth/2-108,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Image.asset(
            height: APP_HEIGHT,
                width: APP_WIDTH,
                "${ASSET_PATH}app_logo.png"
            ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Expense",style: TextStyle(
                        fontSize: AppTheme.ultraBig,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colorPrimary
                    ),),
                    Text(" Tracker",style: TextStyle(
                        fontSize: AppTheme.ultraBig,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colorSecondary
                    ),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
   showBottomSheet(){
    var currentWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      isDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
      builder: (BuildContext context) {
          return Container(
            height: currentWidth>SIZE_600?currentWidth:currentWidth/1.5,
            width: currentWidth,
            decoration: BoxDecoration(
              //gradient: AppTheme.RightToLeft,
              color: AppTheme.colorPrimary.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(currentWidth>SIZE_600?28:24),
                topRight: Radius.circular(currentWidth>SIZE_600?28:24),
              )
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 22,vertical: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(wel_1.tr,style: TextStyle(
                          fontSize: AppTheme.big,
                          fontWeight: FontWeight.bold,
                        color: AppTheme.white
                      ),),
                      const SizedBox(height: 15,),
                      Text(wel_2.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTheme.large,
                          fontWeight: FontWeight.w700,
                        color: AppTheme.white
                        ),),
                    ],
                  ),
                  SizedBox(
                    width: currentWidth-50,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 16,
                        shadowColor: AppTheme.black.withOpacity(0.08),
                        backgroundColor: AppTheme.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                        onPressed: (){
                        storeUserData.setBoolean(HAS_SLIDE, true);
                          Get.offAll(const LoginScreen());
                        }, child: Text(
                      wel_btn.tr,
                      style: TextStyle(
                        fontSize: AppTheme.large,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.white
                      ),
                    )),
                  )
                ],
              ),
            ),
          );
      },
    );
  }
}
