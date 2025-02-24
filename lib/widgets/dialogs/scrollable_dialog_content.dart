import 'package:flutter/material.dart';

class ScrollableDialogContent extends StatelessWidget {
  final List<Widget> children;
  final double maxHeight;
  final EdgeInsetsGeometry padding;

  const ScrollableDialogContent({
    super.key,
    required this.children,
    this.maxHeight = 400,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
