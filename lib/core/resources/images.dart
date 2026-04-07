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
  static String icHome = 'assets/icons/ic_home.png';
  static String icHomeActive = 'assets/icons/ic_home_active.png';
  static String icDevice = 'assets/icons/ic_device.png';
  static String icDeviceActive = 'assets/icons/ic_device_active.png';
  static String icChatAI = 'assets/icons/ic_chat_ai.png';
  static String icChatAIActive = 'assets/icons/ic_chat_ai_active.png';
  static String icServices = 'assets/icons/ic_services.png';
  static String icServicesActive = 'assets/icons/ic_services_active.png';
}
