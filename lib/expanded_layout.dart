library expanded_layout;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:measure_size/measure_size.dart';

class ExpandedLayout extends StatefulWidget {
  final Widget topSection;
  final Widget bottomSection;
  final double minSpacing;
  final bool forceBottomVisible;
  final ScrollController? controller;

  ExpandedLayout({
    Key? key,
    required this.topSection,
    required this.bottomSection,
    this.minSpacing = 20,
    this.forceBottomVisible = false,
    this.controller,
  }) : super(key: key);

  @override
  _ExpandedLayoutState createState() => _ExpandedLayoutState();
}

class _ExpandedLayoutState extends State<ExpandedLayout> {
  Size? _topSize;
  Size? _bottomSize;

  @override
  Widget build(BuildContext context) {
    Widget topSection = MeasureSize(
      onChange: (size) {
        setState(() {
          _topSize = size;
        });
      },
      child: widget.topSection,
    );
    Widget bottomSection = MeasureSize(
      onChange: (size) {
        setState(() {
          _bottomSize = size;
        });
      },
      child: widget.bottomSection,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing;
        if (_topSize != null && _bottomSize != null) {
          spacing =
              constraints.maxHeight - _topSize!.height - _bottomSize!.height;
        } else {
          spacing = 0;
        }

        spacing = max(widget.minSpacing, spacing);

        if (widget.forceBottomVisible) {
          return Column(
            children: [
              Expanded(
                child: topSection,
              ),
              SizedBox(height: widget.minSpacing),
              bottomSection,
            ],
          );
        } else {
          return SingleChildScrollView(
            controller: widget.controller,
            child: Column(
              children: [
                topSection,
                SizedBox(height: spacing),
                bottomSection,
              ],
            ),
          );
        }
      },
    );
  }
}
