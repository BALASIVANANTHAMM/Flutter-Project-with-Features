import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/login_screen.dart';
import 'package:expense_tracker/pages/welcome_screen.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/utils/color_const.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin{

  var currentWidth = 0.0;
  var storeUserData = StoreUserData();

  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end:  Offset.zero,
  ).animate(_animationController);
  late final Animation<Offset> _offsetAnimation2 = Tween<Offset>(
    begin: const Offset(0.2, 0),
    end:  Offset.zero,
  ).animate(_animationController);
  late final Animation<double> sizeAnimation = Tween<double>(
    begin: 0,
    end:  100,
  ).animate(_animationController);

  late final Animation<double> fade = Tween<double>(
    begin: 1,
    end:  0,
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
    Future.delayed(const Duration(milliseconds: 3002),(){
      if(storeUserData.getBoolean(HAS_SLIDE)==true && storeUserData.getBoolean(LOGGED_IN)==true){
        Get.offAll(const Home());
      }else if(storeUserData.getBoolean(HAS_SLIDE)==true && storeUserData.getBoolean(LOGGED_IN)==false){
        Get.offAll(const LoginScreen());
      }else{
        Get.offAll(const WelcomeScreen());
      }
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
            child: SlideTransition(
              position: _offsetAnimation,
              child: Image.asset(
                  height: SIZE_146,
                  width: SIZE_162,
                  "${ASSET_PATH}circle1.png"
              ),
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
            child: SlideTransition(
              position: _offsetAnimation2,
              child: Image.asset(
                  height: SIZE_146,
                  width: SIZE_162,
                  "${ASSET_PATH}circle1.png"
              ),
            ),
          ),
          Positioned(
            left: SIZE_80_MINUS,
            bottom: SIZE_166,
            child: SlideTransition(
              position: _offsetAnimation2,
              child: Image.asset(
                  height: SIZE_146,
                  width: SIZE_162,
                  "${ASSET_PATH}circle3.png"
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: sizeAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Image.asset(
                        height: sizeAnimation.value,
                        width: sizeAnimation.value,
                        "${ASSET_PATH}app_logo.png"
                    );
                  },
                ),
                const SizedBox(height: 15,),
                FadeTransition(
                  opacity: fade,
                  child: Row(
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
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
