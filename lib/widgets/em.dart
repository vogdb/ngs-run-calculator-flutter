import 'package:flutter/material.dart';

/// An analog of CSS em size. Calculate em size in pixels
double em(BuildContext context, double em, double px) {
  var fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize;
  return fontSize != null ? (fontSize * em) : px;
}
