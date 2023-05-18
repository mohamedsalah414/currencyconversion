import 'package:bloc/bloc.dart';
import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:currencytask/data/model/exchange_rates_model.dart';
import 'package:currencytask/presentation/home/bloc/exchange_state.dart';

import '../../../data/repository/currency_repo.dart';

class ExchangeCubit extends Cubit<ExchangeState<ExchangeRates>> {
  final ExchangeRepo exchangeRepo;

  ExchangeCubit(this.exchangeRepo) : super(const Idle());

  void emitGetExchangeRates(
      String startDate, String endDate, String base, String symbols) async {
    var rates = await exchangeRepo.getExchangeRates(
        startDate: startDate, endDate: endDate, base: base, symbols: symbols);
    rates.when(success: (dynamic rate) {
      emit(ExchangeState.success(rate));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(ExchangeState.error(networkExceptions));
    });
  }
}
