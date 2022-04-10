import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget wide;
  final Widget narrow;

  const ResponsiveLayout({required this.wide, required this.narrow, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return MediaQuery.of(context).size.width > 600 ? wide : narrow;
    });
  }
}
