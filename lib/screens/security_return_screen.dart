import 'package:flutter/material.dart';

import '../utils/strings.dart';

class SecurityReturnScreen extends StatefulWidget {
  const SecurityReturnScreen({super.key});

  @override
  State<SecurityReturnScreen> createState() => _SecurityReturnScreenState();
}

class _SecurityReturnScreenState extends State<SecurityReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.securityReturn)),
      body: Center(
        child: Text(AppStrings.securityReturn, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
