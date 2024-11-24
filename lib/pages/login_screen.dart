import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controls/local_auth.dart';
import 'package:expense_tracker/controls/secure_storage.dart';
import 'package:expense_tracker/controls/text.dart';
import 'package:expense_tracker/models/profile_model.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/sign_up_screen.dart';
import 'package:expense_tracker/utils/Utils.dart';
import 'package:expense_tracker/utils/api.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../utils/color_const.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var currentWidth =0.0;
  var storeUserData = StoreUserData();
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  bool pass=true,remember=false,isLoading=false;
  bool? isActive;
  String? securityStorage;
  String? email;
  String? password;
  List<Profile> profile = [];
  final storage = const FlutterSecureStorage(aOptions:AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  Position? _currentLoc;
  String? address;
  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getAddress()async{
    Position? position = await _getCurrentPosition();
    setState(() {
      _currentLoc=position;
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLoc!.latitude, _currentLoc!.longitude);

    setState(() {
      address="${placemarks[0].street}, ${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea} - ${placemarks[0].postalCode}";
    });
    print(address);
  }

  getProfile() async{
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await Api().getDataFromFire(
        collectionUser: STORE_USER,
        collectionId: STORE_USER_ID);
    profile=snapshot.docs
        .map((docSnap)=>Profile.fromJson(docSnap)).toList();
    setState(() {
      if(profile.isNotEmpty){
        isActive=profile[0].isActive;
        isLoading=false;
        if(isActive!=null){
          if(isActive==true){
            storeUserData.setString(DOB, "${profile[0].dOB}");
            storeUserData.setString(CREATE_DATE, "${profile[0].date}");
            storeUserData.setInt(INCOME, profile[0].income!.toInt());
            storeUserData.setString(DOC_ID, "${profile[0].docId}");
            storeUserData.setString(EMAIL, "${profile[0].email}");
            storeUserData.setString(FCM, "${profile[0].fcm}");
            storeUserData.setBoolean(IS_ACTIVE, isActive!);
            storeUserData.setString(NAME, "${profile[0].name}");
            storeUserData.setString(PASSWORD, "${profile[0].password}");
            storeUserData.setString(USER_ID, "${profile[0].userId}");
            Api().addDataFromUi(
                fields: {
                  "dateNow":DateTime.now(),
                  "title":"Logged In",
                  "latitude":"${_currentLoc!.latitude}",
                  "longitude":"${_currentLoc!.longitude}",
                  "currentAddress":"$address",
                  "date":Utils().formatDate(DateTime.now(), DateFormat.yMMMd()),
                  "time":Utils().formatDate(DateTime.now(), DateFormat.jm()),
                  "value":"Account Logged in ${Utils().formatDate(DateTime.now(), DateFormat.yMMMd().add_jm())}",
                },
                collectionUser: STORE_NOTI,
                collectionId: STORE_NOTI_EMAIL,
                context: context
            );
            Get.offAll(const Home());
          }else{
            Utils().snackBar(context, "Your Account is Expired");
          }
        }
      }
    });
  }

   getStore()async{
    securityStorage=await storage.read(key: security_secure);
    email = await storage.read(key: email_secure);
    password = await storage.read(key: password_secure);
  }

  @override
  void initState() {
    getAddress();
    setState(() {
      getStore();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      isLoading==false
      ?Stack(
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
                      CText(
                        text: sign_1.tr,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        fontSize: AppTheme.big,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
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
                  Flexible(
                    child: Row(
                      children: [
                        const SizedBox(width: 15,),
                        Switch(
                            value: remember,
                            activeTrackColor: AppTheme.colorPrimary,
                            inactiveThumbColor: AppTheme.black.withOpacity(0.6),
                            onChanged: (val){
                              setState(() {
                                remember=!remember;
                              });
                            }),
                        const SizedBox(width: 15,),
                        Flexible(
                          child: CText(
                              text: sign_rem.tr,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Utils().primaryButton(context, sign_1.tr.toUpperCase(), (){
                    if(emailCtl.text.isNotEmpty && passwordCtl.text.isNotEmpty){
                      Api().loginWithEmailAndPassword(
                          emailCtl.text,
                          passwordCtl.text,
                              ()async{
                                await storage.write(key: email_secure, value: emailCtl.text);
                                await storage.write(key: password_secure, value: passwordCtl.text);
                            if(remember==true){
                              storeUserData.setBoolean(LOGGED_IN, true);
                            }
                            getProfile();
                          }, context
                      );
                      setState(() {
                        isLoading=false;
                      });
                    }else{
                      Utils().snackBar(context, e_r_p.tr);
                    }
                  }),
                  storage.read(key:email_secure)!=null
                 ?Column(
                   children: [
                    // email!=null
                     //    ?
                     const SizedBox(height: 20,),
                       //  :Container(),
                     // email!=null
                     //     ?
                     CText(text: new_or.tr),
                     //     :Container(),
                     // email!=null
                     //     ?
                     const SizedBox(height: 15,),
                     //     :Container(),
                     // email!=null
                     //     ?
                     GestureDetector(
                       onTap: ()async{
                         email = await storage.read(key: email_secure);
                         password = await storage.read(key: password_secure);
                         print(email);
                         print(password);
                         BiometricAuth(context: context)
                             .authentication(
                             email: email,
                             password: password,
                             navigate: (){
                               Api().loginWithEmailAndPassword(
                                   email!,
                                   password!,
                                       ()async{
                                     if(remember==true){
                                       storeUserData.setBoolean(LOGGED_IN, true);
                                     }
                                     getProfile();
                                   }, context
                               );
                             }
                         );
                       },
                       child: Image.asset(
                           height: 60,
                           width: 60,
                           "${ASSET_PATH}biometrics.png"),
                     )
                         // :Container(),
                   ],
                 ):Container(),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CText(
                          text: sign_don.tr,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.visible,
                          fontSize: AppTheme.thirteen,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.to(const SignUpScreen());
                        },
                        child:  CText(
                          text:sign_up.tr,
                          textColor: AppTheme.colorPrimary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ):Center(
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
}
