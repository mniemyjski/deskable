import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCircle(
      color: Colors.white,
      size: 50.0,
    );
  }
}
