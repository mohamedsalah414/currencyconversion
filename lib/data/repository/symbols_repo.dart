import 'package:currencytask/data/api_handling/api_result.dart';
import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:currencytask/data/model/symbols_model.dart';

import '../datasource/web_services.dart';

class SymbolsRepo {
  final WebServices webServices;

  SymbolsRepo(this.webServices);

  Future<ApiResult<SymbolsModel>> getAllSymbols() async {
    try {
      var response = await webServices.getAllSymbols();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}
