import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conPasswordRepeat = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordRepeatVisible = false;
  bool _isAgreed = false;

  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();
  final _fnPasswordRepeat = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  Widget build(BuildContext context) => Parent(
    avoidBottomInset: false,
    appBar: const MyAppBar(),
    extendBodyBehindAppBar: true,
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

        Positioned.fill(
          bottom: 350.w,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.icLogo,
                  width: Dimens.logo,
                  height: Dimens.logo,
                  fit: BoxFit.cover,
                ),
                SpacerV(value: Dimens.space24),
                Text(
                  'Start your healthy \njourney',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SpacerV(value: Dimens.space12),
                Text(
                  "Register now, it's free and easy",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space24),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimens.cornerRadius),
                topRight: Radius.circular(Dimens.cornerRadius),
              ),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.cardDark
                  : Palette.card,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SpacerV(),
                    Container(
                      width: 140.w,
                      height: Dimens.space6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Palette.handleBarDark
                            : Palette.handleBarLight,
                      ),
                    ),
                    SpacerV(value: 22.w),
                    TextF(
                      autoFillHints: const [AutofillHints.email],
                      key: const Key('email'),
                      focusNode: _fnEmail,
                      textInputAction: TextInputAction.next,
                      controller: _conEmail,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Email Address',
                      isValid: _formValidator.putIfAbsent('email', () => false),
                      validatorListener: (String value) {
                        _formValidator['email'] = value.isValidEmail();
                        context.read<ReloadFormCubit>().reload();
                      },
                      errorMessage: Strings.of(context)!.errorInvalidEmail,
                    ),
                    SpacerV(value: Dimens.space12),
                    TextF(
                      autoFillHints: const [AutofillHints.password],
                      key: const Key('password'),
                      focusNode: _fnPassword,
                      textInputAction: TextInputAction.done,
                      controller: _conPassword,
                      keyboardType: TextInputType.text,
                      obscureText: !_isPasswordVisible,
                      hint: 'Password',
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          _isPasswordVisible = !_isPasswordVisible;
                          context.read<ReloadFormCubit>().reload();
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      isValid: _formValidator.putIfAbsent(
                        'password',
                        () => false,
                      ),
                      validatorListener: (String value) {
                        _formValidator['password'] = value.length > 5;
                        context.read<ReloadFormCubit>().reload();
                      },
                      errorMessage: Strings.of(context)!.errorPasswordLength,
                    ),
                    SpacerV(value: Dimens.space12),
                    TextF(
                      key: const Key('repeat_password'),
                      focusNode: _fnPasswordRepeat,
                      textInputAction: TextInputAction.done,
                      controller: _conPasswordRepeat,
                      keyboardType: TextInputType.text,
                      obscureText: !_isPasswordRepeatVisible,
                      hint: '••••••••••••',
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          _isPasswordRepeatVisible = !_isPasswordRepeatVisible;
                          context.read<ReloadFormCubit>().reload();
                        },
                        icon: Icon(
                          !_isPasswordRepeatVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      isValid: _formValidator.putIfAbsent(
                        'repeat_password',
                        () => false,
                      ),
                      validatorListener: (String value) {
                        _formValidator['repeat_password'] =
                            value == _conPassword.text;
                        context.read<ReloadFormCubit>().reload();
                      },
                      errorMessage: Strings.of(context)!.errorPasswordNotMatch,
                      semantic: 'repeat_password',
                    ),
                    SpacerV(value: Dimens.space12),
                    CheckboxAgreement(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() => _isAgreed = value ?? false);
                        context.read<ReloadFormCubit>().reload();
                      },
                      onTapTerms: () => context.pushNamed('/terms-of-service'),
                      onTapPrivacy: () =>
                          context.pushNamed('/privacy-policy'),
                    ),
                    SpacerV(value: Dimens.space24),
                    Button(
                      width: double.maxFinite,
                      title: 'Next',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Palette.buttonDark
                          : Palette.button,
                      titleColor: Palette.text,
                      onPressed: () =>
                          context.pushNamed(Routes.completeProfile.name),
                    ),
                    SpacerV(value: 32.w),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
