class Images {
  Images._();

  static String icLauncher =
      const String.fromEnvironment('ENV', defaultValue: 'staging') == 'staging'
      ? 'assets/images/ic_launcher_stg.png'
      : 'assets/images/ic_logo_elvasense.png';

  static String icLauncherDark =
      const String.fromEnvironment('ENV', defaultValue: 'staging') == 'staging'
      ? 'assets/images/ic_launcher_stg_dark.png'
      : 'assets/images/ic_launcher_dark.png';

  static String icLogoSplash = 'assets/images/ic_logo_splash.png';
  static String icLogo = 'assets/images/ic_logo.png';
}
