import 'package:currencytask/data/repository/symbols_repo.dart';
import 'package:currencytask/presentation/home/bloc/symbols_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/web_services.dart';
import 'data/repository/currency_repo.dart';
import 'presentation/home/bloc/exchange_cubit.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerLazySingleton<ExchangeCubit>(() => ExchangeCubit(getIt()));
  getIt.registerLazySingleton<SymbolsCubit>(() => SymbolsCubit(getIt()));
  getIt.registerLazySingleton<ExchangeRepo>(() => ExchangeRepo(getIt()));
  getIt.registerLazySingleton<SymbolsRepo>(() => SymbolsRepo(getIt()));
  getIt.registerLazySingleton<WebServices>(
      () => WebServices(createAndSetupDio()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();

  dio
    ..options.receiveDataWhenStatusError = true
    ..options.connectTimeout = const Duration(milliseconds: 200 * 1000)
    ..options.receiveTimeout = const Duration(milliseconds: 200 * 1000);

  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    error: true,
    requestHeader: false,
    responseHeader: false,
    request: true,
    requestBody: true,
  ));

  return dio;
}
