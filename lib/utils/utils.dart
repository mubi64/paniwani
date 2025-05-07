import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'responsive/responsive_flutter.dart';

class Utils {
  void showToast(Object message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 14,
    );
  }

  void loggerPrint(Object? object) {
    if (object == null || isValidationEmpty(object.toString())) {
      debugPrint('>---> Empty Message');
    } else {
      debugPrint('>-DEbug console--> $object');
    }
  }

  double parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble(); // Convert integer to double
    } else if (value is double) {
      return value; // Value is already double
    } else {
      return 0.0; // Return null if value is neither int nor double
    }
  }

  bool isValidationEmpty(String? val) {
    if (val == null) {
      return true;
    } else {
      val = val.trim();
      if (val.isEmpty ||
          val == "null" ||
          val == "" ||
          val.isEmpty ||
          val == "NULL") {
        return true;
      } else {
        return false;
      }
    }
  }

  void showProgressDialog(BuildContext buildContext, {text = ""}) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: PopScope(
              canPop: false,
              child: Center(
                child:
                    text == ""
                        ? Container(
                          width: ResponsiveFlutter.of(
                            context,
                          ).moderateScale(80),
                          height: ResponsiveFlutter.of(
                            context,
                          ).moderateScale(80),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary,
                                offset: const Offset(0.0, 1.0),
                                blurRadius: 8.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              ResponsiveFlutter.of(context).moderateScale(100),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                        : Container(
                          width: ResponsiveFlutter.of(
                            context,
                          ).moderateScale(250),
                          height: ResponsiveFlutter.of(
                            context,
                          ).moderateScale(130),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary,
                                offset: const Offset(0.0, 1.0),
                                blurRadius: 8.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              ResponsiveFlutter.of(context).moderateScale(10),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: ResponsiveFlutter.of(
                                    context,
                                  ).verticalScale(20),
                                ),
                                CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  height: ResponsiveFlutter.of(
                                    context,
                                  ).verticalScale(20),
                                ),
                                Text(
                                  text,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }

  void hideProgressDialog(BuildContext buildContext) {
    Navigator.of(buildContext, rootNavigator: true).pop();
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
