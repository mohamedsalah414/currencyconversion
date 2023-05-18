import 'package:currencytask/core/utils/app_colors.dart';
import 'package:currencytask/core/utils/app_strings.dart';
import 'package:currencytask/core/utils/helper_extenstions.dart';
import 'package:currencytask/core/widgets/text_widget.dart';
import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:currencytask/data/model/exchange_rates_model.dart';
import 'package:currencytask/data/model/symbols_model.dart';
import 'package:currencytask/presentation/home/bloc/exchange_cubit.dart';
import 'package:currencytask/presentation/home/bloc/exchange_state.dart';
import 'package:currencytask/presentation/home/bloc/symbols_cubit.dart';
import 'package:currencytask/presentation/home/bloc/symbols_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? dropDownBaseValue;
  String? dropDownConvertToValue;

  DateTime selectedBeforeDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SymbolsCubit>(context).emitGetAllSymbols();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  static const _pageSize = 10;

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<String> newDataList = await fetchYourData(pageKey, _pageSize);

      final isLastPage = newDataList.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newDataList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newDataList, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<String>> fetchYourData(int pageKey, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2));

    final List<String> newDataList = [];
    final startIndex = pageKey * pageSize;
    final endIndex = startIndex + pageSize;

    for (int i = startIndex; i < endIndex; i++) {
      if (i < _dataList.length) {
        newDataList.add(_dataList[i]);
      }
    }

    return newDataList;
  }

  bool baseSelected = false;
  bool convertSelected = false;
  bool exchangePressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white2,
      appBar: AppBar(
        backgroundColor: AppColor.carolinaBlue,
        centerTitle: true,
        title: const TextWidget(
          txt: 'Currency Exchange',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: buildColumnContainsData(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildExchangeFloatButton(context),
    );
  }

  Column buildColumnContainsData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const TextWidget(
          txt: AppStrings.choosePeriod,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        10.ph,
        buildDatesRow(context),
        25.ph,
        TextWidget(
          txt: 'Base Currency : ${dropDownBaseValue ?? ''}',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        buildBaseDropDown(),
        15.ph,
        TextWidget(
          txt: 'Convert to : ${dropDownConvertToValue ?? ''}',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        buildConvertDropDown(),
        25.ph,
        Visibility(
          visible: convertSelected == false || baseSelected == false,
          child: const TextWidget(
            txt: 'You should select currencies',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        buildPaginationListForCurrencies(),
      ],
    );
  }

  Visibility buildExchangeFloatButton(BuildContext context) {
    return Visibility(
      visible: convertSelected && baseSelected,
      child: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            BlocProvider.of<ExchangeCubit>(context).emitGetExchangeRates(
                DateFormat('yyyy-MM-dd').format(selectedBeforeDate).toString(),
                DateFormat('yyyy-MM-dd').format(selectedToDate).toString(),
                dropDownBaseValue.toString(),
                dropDownConvertToValue.toString());
            _pagingController.refresh();
            exchangePressed = true;
          });
          dateHandle(context);
        },
        icon: const Icon(Icons.currency_exchange),
        label: const TextWidget(
          txt: 'Currency Exchange',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColor.black,
        ),
      ),
    );
  }

  Visibility buildPaginationListForCurrencies() {
    return Visibility(
      visible: exchangePressed,
      child: Column(
        children: [
          BlocBuilder<ExchangeCubit, ExchangeState<ExchangeRates>>(
            builder: (context, ExchangeState<ExchangeRates> state) {
              return state.when(
                idle: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                success: (ExchangeRates exchangeRates) {
                  _dataList = exchangeRates.rates.keys.toList();
                  return Container(
                      padding: const EdgeInsets.all(15),
                      height: context.height * .35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColor.blue),
                      child: PagedListView<int, String>(
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<String>(
                            itemBuilder: (context, item, index) {
                              final date = item;
                              return ListTile(
                                subtitle: TextWidget(
                                  txt: 'Date: $date',
                                  // fontWeight: FontWeight.bold,
                                  // fontSize: 18,
                                  color: AppColor.white2,
                                ),
                                leading: CircleAvatar(
                                  child: TextWidget(txt: '${index + 1}'),
                                ),
                                title: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: exchangeRates.rates[date]!.length,
                                  itemBuilder: (context, index) {
                                    final currencyCode = exchangeRates
                                        .rates[date]!.keys
                                        .toList()[index];
                                    final exchangeRate = exchangeRates
                                        .rates[date]![currencyCode];
                                    return TextWidget(
                                      txt: '$currencyCode: $exchangeRate',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: AppColor.white2,
                                    );
                                  },
                                ),
                              );
                            },
                          )));
                },
                error: (NetworkExceptions networkExceptions) {
                  return Center(
                    child: Text(
                        NetworkExceptions.getErrorMessage(networkExceptions)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Row buildDatesRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            buildElevatedButton(context, 'Date From', 'from'),
            10.ph,
            TextWidget(
              txt: DateFormat('dd MMM yyyy').format(selectedBeforeDate),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Column(
          children: [
            buildElevatedButton(context, 'Date To', 'to'),
            10.ph,
            TextWidget(
              txt: DateFormat('dd MMM yyyy').format(selectedToDate),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>> buildConvertDropDown() {
    return BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>>(
      builder: (context, SymbolsState<SymbolsModel> state) {
        return state.when(
          idle: () => const Center(
            child: CircularProgressIndicator(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          success: (SymbolsModel symbolsData) {
            return Container(
              decoration: BoxDecoration(
                  color: AppColor.carolinaBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: false,
                  value: dropDownConvertToValue,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade,
                      color: Colors.black),
                  hint: const TextWidget(
                      txt: 'Choose Base Currency',
                      overflow: TextOverflow.ellipsis),
                  borderRadius: BorderRadius.circular(10),
                  menuMaxHeight: context.height * .3,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: symbolsData.symbols.values
                      .map<DropdownMenuItem<String>>((Currency currency) {
                    return DropdownMenuItem<String>(
                      value: currency.code,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              txt: '${currency.code}',
                              overflow: TextOverflow.clip),
                          7.ph,
                          TextWidget(
                              txt: '${currency.description}',
                              fontWeight: FontWeight.normal,
                              color: AppColor.grey,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      convertSelected = true;
                      dropDownConvertToValue = value;
                    });
                  },
                ),
              ),
            );
          },
          error: (NetworkExceptions networkExceptions) {
            return Center(
              child: Text(NetworkExceptions.getErrorMessage(networkExceptions)),
            );
          },
        );
      },
    );
  }

  BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>> buildBaseDropDown() {
    return BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>>(
      builder: (context, SymbolsState<SymbolsModel> state) {
        return state.when(
          idle: () => const Center(
            child: CircularProgressIndicator(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          success: (SymbolsModel symbolsData) {
            return Container(
              decoration: BoxDecoration(
                  color: AppColor.carolinaBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: dropDownBaseValue,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade,
                      color: Colors.black),
                  hint: const TextWidget(
                      txt: 'Choose Base Currency',
                      overflow: TextOverflow.ellipsis),
                  borderRadius: BorderRadius.circular(10),
                  menuMaxHeight: context.height * .3,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: symbolsData.symbols.values
                      .map<DropdownMenuItem<String>>((Currency currency) {
                    return DropdownMenuItem<String>(
                      value: currency.code,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              txt: '${currency.code}',
                              overflow: TextOverflow.clip),
                          7.ph,
                          TextWidget(
                              txt: '${currency.description}',
                              fontWeight: FontWeight.normal,
                              color: AppColor.grey,
                              overflow: TextOverflow.clip),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      baseSelected = true;

                      dropDownBaseValue = value;
                    });
                  },
                ),
              ),
            );
          },
          error: (NetworkExceptions networkExceptions) {
            return Center(
              child: Text(NetworkExceptions.getErrorMessage(networkExceptions)),
            );
          },
        );
      },
    );
  }

  Widget buildElevatedButton(BuildContext context, String txt, String type) {
    return SizedBox(
      width: context.width * .4,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            showDate(context).then(
              (value) {
                setState(() {
                  type == 'to'
                      ? selectedToDate = value!
                      : selectedBeforeDate = value!;
                });
                dateHandle(context);
              },
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.carolinaBlue,
              shadowColor: AppColor.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month),
              5.pw,
              TextWidget(
                txt: txt,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.black,
              ),
            ],
          )),
    );
  }

  void dateHandle(BuildContext context) {
    if (selectedBeforeDate.isAfter(selectedToDate)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColor.pink,
        behavior: SnackBarBehavior.floating,
        content: TextWidget(
            txt: 'Choose date correctly!!',
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ));
    }
  }

  Future<DateTime?> showDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }
}
