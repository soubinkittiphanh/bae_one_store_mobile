import 'package:flutter/material.dart';

class LogoComp extends StatelessWidget {
  const LogoComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height * 0.35,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(180)),
        color: Colors.red,
      ),
      child: Image.network(
        "https://assets.turbologo.com/blog/en/2019/11/19084834/gaming-logo-cover.jpg",
        fit: BoxFit.contain,
        colorBlendMode: BlendMode.colorBurn,
      ),
    );
  }
}
