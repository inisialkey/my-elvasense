import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/utils/utils.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Parent(
    // child: BlocListener<GeneralTokenCubit, GeneralTokenState>(
    //   //coverage:ignore-start
    //   listener: (context, state) => {
    //     if (state is GeneralTokenStateSuccess)
    //       {context.goNamed(Routes.root.name)}
    //   },
    //coverage:ignore-end
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
          child: Image.asset(Images.icLogo, width: context.widthInPercent(55)),
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
