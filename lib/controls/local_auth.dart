

import 'package:expense_tracker/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth{
  final BuildContext context;
  BiometricAuth({
    required this.context
});
  LocalAuthentication localAuthentication = LocalAuthentication();

  void authentication({
    required String? email,
    required String? password,
    required VoidCallback navigate})async{
    bool checkBiometrics = await localAuthentication.canCheckBiometrics;

    if(checkBiometrics==true){
      List<BiometricType> availableBiometrics = await localAuthentication.getAvailableBiometrics();
      Utils().log(availableBiometrics);
      if(email != null && password != null){
        bool authenticate = await localAuthentication.authenticate(
            localizedReason: "Please Scan your Biometrics",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true
          )
        );
        if(authenticate==true){
          navigate.call();
        }
      }
      else{
        Utils().snackBar(context, "First Login Using Credentials!");
      }
    }
  }
}