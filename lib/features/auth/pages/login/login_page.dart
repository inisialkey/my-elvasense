import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  bool _isPasswordVisible = false;

  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  Widget build(BuildContext context) => Parent(
    avoidBottomInset: false,
    child: BlocListener<AuthCubit, AuthState>(
      listener: (_, state) => switch (state) {
        AuthStateLoading() => context.show(),
        AuthStateSuccess() => (() {
          context.dismiss();

          TextInput.finishAutofillContext();
          context.goNamed(Routes.root.name);
        })(),
        AuthStateFailure(:final message) => (() {
          context.dismiss();
          message.toToastError(context);
        })(),
        _ => {},
      },
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
                    'Welcome Back',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SpacerV(value: Dimens.space12),
                  Text(
                    'We are glad you are back to continue your \nprogress',
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
                      _loginForm(),
                      SpacerV(value: Dimens.space24),
                      Text(
                        'By continuing, you agree to our Terms of Service and \nPrivacy Policy.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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
    ),
  );

  Widget _loginForm() => BlocBuilder<ReloadFormCubit, ReloadFormState>(
    builder: (_, _) => Column(
      children: [
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
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          isValid: _formValidator.putIfAbsent('password', () => false),
          validatorListener: (String value) {
            _formValidator['password'] = value.length > 5;
            context.read<ReloadFormCubit>().reload();
          },
          errorMessage: Strings.of(context)!.errorPasswordLength,
        ),
        SpacerV(value: Dimens.space12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot password?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.textDark
                  : Palette.text,
            ),
          ),
        ),
        SpacerV(value: Dimens.space24),
        Button(
          width: double.maxFinite,
          title: 'Log In',
          onPressed: _formValidator.validate()
              ? () => context.read<AuthCubit>().login(
                  LoginParams(
                    email: _conEmail.text,
                    password: _conPassword.text,
                  ),
                )
              : null,
        ),
      ],
    ),
  );
}
