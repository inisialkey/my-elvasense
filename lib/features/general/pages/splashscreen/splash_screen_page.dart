import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/utils/utils.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.goNamed(Routes.onboarding.name);
    });
  }

  @override
  Widget build(BuildContext context) => Parent(
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/background_dark.jpeg'
                    : 'assets/images/background.jpeg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Center(
          child: Image.asset(
            Images.icLogoSplash,
            width: context.widthInPercent(55),
          ),
        ),

        Positioned(
          bottom: 28 + MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          child: Text(
            'Version 2.0',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
