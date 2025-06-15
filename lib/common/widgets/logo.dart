import 'package:flutter_svg/flutter_svg.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';

class Logo extends StatelessWidget{
  const Logo({super.key,this.width,this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context){

    return SvgPicture.asset(
      FImages.appLogo,
      color:  FColors.primary.withAlpha(122),
      width: width ?? 100,
      height: height ?? 100,
    );
  }
}