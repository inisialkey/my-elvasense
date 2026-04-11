import 'package:get_it/get_it.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
  String prefixBox = '',
}) async {
  if (isUnitTest) {
    await sl.reset();
  }

  if (isHiveEnable) {
    await _initHiveBoxes(isUnitTest: isUnitTest, prefixBox: prefixBox);
  }

  sl.registerLazySingleton<AuthTokenService>(() => AuthTokenService());
  sl.registerLazySingleton<PermissionService>(() => PermissionServiceImpl());

  sl.registerSingleton<DioClient>(DioClient(isUnitTest: isUnitTest));

  if (!isUnitTest) {
    sl.registerSingleton<ConnectivityService>(ConnectivityService());
  }

  _dataSources();
  _repositories();
  _useCase();
  _cubit();
}

Future<void> _initHiveBoxes({
  bool isUnitTest = false,
  String prefixBox = '',
}) async {
  await MainBoxMixin.initHive(prefixBox);

  // One-time migration: clear legacy token keys from Hive.
  // Safe to run on every startup — once keys are gone these become no-ops.
  // isLogin is intentionally NOT deleted here; it remains the auth state flag.
  MainBoxMixin.mainBox?.delete('accessToken');
  MainBoxMixin.mainBox?.delete('refreshToken');

  sl.registerSingleton<MainBoxMixin>(MainBoxMixin());
}

void _repositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));
}

void _dataSources() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<UsersRemoteDatasource>(
    () => UsersRemoteDatasourceImpl(sl()),
  );
}

void _useCase() {
  sl.registerLazySingleton(() => PostLogin(sl()));
  sl.registerLazySingleton(() => PostLogout(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
}

void _cubit() {
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => LogoutCubit(sl()));
  sl.registerFactory(() => PermissionCubit(sl()));
  sl.registerFactory(() => ReloadFormCubit());

  if (sl.isRegistered<ConnectivityService>()) {
    sl.registerFactory(() => ConnectivityCubit(sl()));
  }

  sl.registerFactory(() => UserCubit(sl()));
  sl.registerFactory(() => UsersCubit(sl()));
  sl.registerFactory(() => SettingsCubit());
  sl.registerFactory(() => MainCubit());
}
