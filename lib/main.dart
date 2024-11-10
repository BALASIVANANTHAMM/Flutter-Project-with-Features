import 'package:expense_tracker/pages/splash.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/utils/store_user_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'controls/LanguageControlls.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await StoreUserData.init();
  // await FirebaseAppCheck.instance.activate();
  Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCQ1SMRR1M_xv3jd_rGnfa6FhzzGk37grA",
        authDomain: "expense-af9b2.firebaseapp.com",
        projectId: "expense-af9b2",
        storageBucket: "expense-af9b2.firebasestorage.app",
        messagingSenderId: "117362387323",
        appId: "1:117362387323:web:1487295833fbfbeb6c35de",
        measurementId: "G-KZ127FSNX3"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var storeUserData=StoreUserData();
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: storeUserData.getString(LANG).isNotEmpty
          ?Locale(storeUserData.getString(LANG),storeUserData.getString(COUN)):const Locale('en','US'),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
