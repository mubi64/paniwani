import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'responsive/responsive_flutter.dart';

class MyTextView extends Text {
  final TextAlign? textAlignNew;
  final int? maxLinesNew;
  final TextStyle? textStyleNew;
  final TextOverflow? overflowText;
  final bool isMaxLineWrap;

  const MyTextView(
    super.s, {
    super.key,
    this.textAlignNew = TextAlign.start,
    this.maxLinesNew = 1,
    this.overflowText = TextOverflow.ellipsis,
    this.isMaxLineWrap = false,
    @required this.textStyleNew,
  }) : super(
         textAlign: textAlignNew,
         maxLines: isMaxLineWrap ? null : maxLinesNew,
         overflow: isMaxLineWrap ? null : overflowText,
         style: textStyleNew,
       );
}

class MyTextStyle extends TextStyle {
  @override
  Color? color;
  @override
  FontWeight? fontWeight;
  double? size;

  // String? fontFamily;
  TextDecoration? decorationNew;
  @override
  Paint? background;
  @override
  double? letterSpacing;

  MyTextStyle({
    this.color = Colors.black,
    // @required this.fontWeight,
    this.fontWeight = FontWeight.normal,
    this.size = 14,
    // this.fontFamily = "Poppins",
    this.decorationNew = TextDecoration.none,
    this.background,
    this.letterSpacing = 0.0,
  }) : assert(color != null && fontWeight != null),
       super(
         color: color,
         fontWeight: fontWeight,
         fontSize: size,
         // fontFamily: fontFamily,
         decoration: decorationNew,
         background: background,
         letterSpacing: letterSpacing,
       );
}

Widget commonButton({
  BuildContext? context,
  GestureTapCallback? callback,
  String? title,
  double? padding = 12,
  double? cornerRadius = 12,
  double? fontSize = 2.5,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveFlutter.of(context).moderateScale(cornerRadius!),
        ),
        color: Theme.of(context!).colorScheme.inversePrimary,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveFlutter.of(context).moderateScale(padding!),
        ),
        child: MyTextView(
          title!,
          textAlignNew: TextAlign.center,
          textStyleNew: MyTextStyle(
            size: ResponsiveFlutter.of(context).fontSize(fontSize!),
            color: Colors.white,
            fontWeight: fontWeight,
          ),
          isMaxLineWrap: true,
        ),
      ),
    ),
  );
}

Widget commonButton1({
  BuildContext? context,
  GestureTapCallback? callback,
  String? title,
  double? padding = 12,
  double? cornerRadius = 12,
  double? fontSize = 2.5,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveFlutter.of(context).moderateScale(cornerRadius!),
        ),
        border: Border.all(
          color: Theme.of(context!).colorScheme.primary,
          width: ResponsiveFlutter.of(context).moderateScale(1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveFlutter.of(context).moderateScale(padding!),
        ),
        child: MyTextView(
          title!,
          textAlignNew: TextAlign.center,
          textStyleNew: MyTextStyle(
            size: ResponsiveFlutter.of(context).fontSize(fontSize!),
            color: Theme.of(context).colorScheme.primary,
            fontWeight: fontWeight,
          ),
          isMaxLineWrap: true,
        ),
      ),
    ),
  );
}
