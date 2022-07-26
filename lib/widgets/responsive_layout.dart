import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  static const threshold = 800;
  final Widget wide;
  final Widget narrow;

  const ResponsiveLayout({required this.wide, required this.narrow, Key? key}) : super(key: key);

  static bool isWide(BuildContext context){
    return MediaQuery.of(context).size.width > threshold;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return MediaQuery.of(context).size.width > threshold ? wide : narrow;
    });
  }
}
