import 'package:bloc/bloc.dart';
import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:currencytask/data/model/symbols_model.dart';
import 'package:currencytask/data/repository/symbols_repo.dart';
import 'package:currencytask/presentation/home/bloc/symbols_state.dart';

class SymbolsCubit extends Cubit<SymbolsState<SymbolsModel>> {
  final SymbolsRepo symbolsRepo;
  SymbolsCubit(this.symbolsRepo) : super(const Idle());

  void emitGetAllSymbols() async {
    var symbols = await symbolsRepo.getAllSymbols();
    symbols.when(success: (dynamic symbolData) {
      emit(SymbolsState.success(symbolData));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(SymbolsState.error(networkExceptions));
    });

    // myRepo.getAllUser().then((usersList) {
    //   emit(GetAllUsers(usersList));
    // });
  }
}
