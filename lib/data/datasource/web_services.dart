import 'package:currencytask/core/utils/app_strings.dart';
import 'package:currencytask/data/model/exchange_rates_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/symbols_model.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: AppStrings.baseUrl)
abstract class WebServices {
  factory WebServices(Dio dio, {String baseUrl}) = _WebServices;

  @GET(AppStrings.symbolsEndPoint)
  Future<SymbolsModel> getAllSymbols();

  @GET(AppStrings.timeSeriesEndPoint)
  Future<ExchangeRates> getExchangeRates({
    @Query('start_date') required String startDate,
    @Query('end_date') required String endDate,
    @Query('base') required String base,
    @Query('symbols') required String symbols,
  });
  //
  // @POST("users")
  // Future<User> createNewUser(
  //     @Body() User newuser, @Header('Authorization') String token);
  //
  // @DELETE("users/{id}")
  // Future<HttpResponse> deleteUser(
  //     @Path() String id, @Header('Authorization') String token
  //     );
}
