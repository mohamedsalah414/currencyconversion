import 'package:currencytask/data/api_handling/api_result.dart';
import 'package:currencytask/data/model/exchange_rates_model.dart';
import 'package:flutter/material.dart';

import '../datasource/web_services.dart';

class ExchangeRepo {
  final WebServices webServices;

  ExchangeRepo(this.webServices);

  Future<ApiResult<ExchangeRates>> getExchangeRates(
      {required dynamic startDate,
      required dynamic endDate,
      required dynamic base,
      required dynamic symbols}) async {
    var response = await webServices.getExchangeRates(
        startDate: startDate, endDate: endDate, base: base, symbols: symbols);
    debugPrint('getExchangeRates success is  $response');
    return ApiResult.success(response);
    // try {
    //   if (startDate == null ||
    //       endDate == null ||
    //       base == null ||
    //       symbols == null) {
    //     return const ApiResult.failure(NetworkExceptions.formatException());
    //   }
    //   var response = await webServices.getExchangeRates(
    //       startDate: startDate, endDate: endDate, base: base, symbols: symbols);
    //   debugPrint('getExchangeRates success is  $response');
    //   return ApiResult.success(response);
    // } catch (error) {
    //   debugPrint('getExchangeRates error is  $error');
    //   return ApiResult.failure(NetworkExceptions.getDioException(error));
    // }
  }
//
// Future<ApiResult<User>> getUserById(String userId) async {
//   try {
//     var response = await webServices.getUserById(userId);
//     return ApiResult.success(response);
//   } catch (error) {
//     return ApiResult.failure(NetworkExceptions.getDioException(error));
//   }
// }
//
// Future<ApiResult<User>> createNewUser(User newUser) async {
//   try {
//     var response = await webServices.createNewUser(newUser,
//         'Bearer 266011b7625eba47bb22d916cc895be80d09523c732855d150f2852347bda0ad');
//     return ApiResult.success(response);
//   } catch (error) {
//     return ApiResult.failure(NetworkExceptions.getDioException(error));
//   }
// }
//
// Future<HttpResponse> deleteUser(String userId) async {
//   return await webServices.deleteUser(userId,
//       'Bearer 266011b7625eba47bb22d916cc895be80d09523c732855d150f2852347bda0ad');
// }
}
