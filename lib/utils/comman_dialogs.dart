import 'package:flutter/material.dart';

import 'common_widget.dart';
import 'responsive/responsive_flutter.dart';
import 'strings.dart';
import 'utils.dart';

typedef AlertAction<T> = void Function(T index);

void dialogConfirm(
  BuildContext context,
  Utils utils,
  GestureTapCallback? callbackPositive,
  String? msg,
) async {
  utils.hideKeyboard(context);

  showDialog(
    context: context,
    barrierColor: const Color(0x73000000),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      ResponsiveFlutter.of(context).moderateScale(28),
                    ),
                    margin: EdgeInsets.all(
                      ResponsiveFlutter.of(context).moderateScale(20, 0.0),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(12, 0.0),
                      ),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      children: [
                        MyTextView(
                          /*Strings.titleConfirmation*/
                          AppStrings.appName,
                          textStyleNew: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: ResponsiveFlutter.of(context).fontSize(3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(
                            context,
                          ).verticalScale(28),
                        ),
                        MyTextView(
                          msg!,
                          textAlignNew: TextAlign.start,
                          textStyleNew: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: ResponsiveFlutter.of(context).fontSize(2),
                            fontWeight: FontWeight.w400,
                          ),
                          isMaxLineWrap: true,
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(
                            context,
                          ).verticalScale(28),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: commonButton(
                                  context: context,
                                  title: AppStrings.btnYes,
                                  fontSize: 3,
                                  fontWeight: FontWeight.w800,
                                  callback: callbackPositive,
                                  padding: 8,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveFlutter.of(
                                context,
                              ).verticalScale(20),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: commonButton1(
                                  context: context,
                                  title: AppStrings.btnNo,
                                  fontSize: 3,
                                  callback: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  },
                                  padding: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
