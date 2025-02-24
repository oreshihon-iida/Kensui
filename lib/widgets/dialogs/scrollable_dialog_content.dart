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
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite ? 
          constraints.maxHeight : 
          maxHeight.clamp(0.0, MediaQuery.of(context).size.height * 0.7);
        return SizedBox(
          height: height,
          child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
      },
    );
  }
}
