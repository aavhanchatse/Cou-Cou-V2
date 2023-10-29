import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:flutter/material.dart';

class DefaultContainer2 extends StatelessWidget {
  final Widget child;

  const DefaultContainer2({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.w),
      decoration: StyleUtil.defaultBoxDecoration3(),
      child: child,
    );
  }
}
