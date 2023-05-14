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
  // Initial Selected Value
  String? dropDownBaseValue;
  String? dropDownConvertToValue;
  // String dropDownConvertToValue = '';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  var itemsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 5',
  ];
  DateTime selectedBeforeDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  final PagingController _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SymbolsCubit>(context).emitGetAllSymbols();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  static const _pageSize = 30;
  Future<void> _fetchPage(int pageKey) async {
    try {
      // final newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
      final isLastPage = itemsList.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(itemsList);
      } else {
        final nextPageKey = pageKey + itemsList.length;
        _pagingController.appendPage(itemsList, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
        child: Column(
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
            Row(
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
            ),
            25.ph,
            TextWidget(
              txt: 'Base Currency : ${dropDownBaseValue ?? ''}',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>>(
              builder: (context, SymbolsState<SymbolsModel> state) {
                return state.when(
                  idle: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  success: (SymbolsModel symbolsData) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
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
                        menuMaxHeight: context.height * .2,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: symbolsData.symbols.values
                            .map<DropdownMenuItem<String>>((Currency currency) {
                          return DropdownMenuItem<String>(
                            value: currency.code,
                            child: TextWidget(
                                txt:
                                    '${currency.code} : ${currency.description}',
                                overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            baseSelected = true;

                            dropDownBaseValue = value;
                          });
                        },
                      ),
                    );
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
            15.ph,
            TextWidget(
              txt: 'Convert to : ${dropDownConvertToValue ?? ''}',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            BlocBuilder<SymbolsCubit, SymbolsState<SymbolsModel>>(
              builder: (context, SymbolsState<SymbolsModel> state) {
                return state.when(
                  idle: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  success: (SymbolsModel symbolsData) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: DropdownButton(
                        value: dropDownConvertToValue,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                            color: Colors.black),
                        hint: const TextWidget(
                            txt: 'Choose Base Currency',
                            overflow: TextOverflow.ellipsis),
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: context.height * .2,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: symbolsData.symbols.values
                            .map<DropdownMenuItem<String>>((Currency currency) {
                          return DropdownMenuItem<String>(
                            value: currency.code,
                            child: TextWidget(
                                txt:
                                    '${currency.code} : ${currency.description}',
                                overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            convertSelected = true;
                            dropDownConvertToValue = value;
                          });
                        },
                      ),
                    );
                    // return Container(
                    //   height: 150,
                    //   color: Colors.amber,
                    //   child: Center(
                    //       child: ListView.builder(
                    //           itemCount: symbolsData.symbols.entries.length,
                    //           shrinkWrap: true,
                    //           itemBuilder: (context, index) {
                    //             // final List keys =
                    //             //     symbolsData.symbols.keys.toList();
                    //             // final List values =
                    //             //     symbolsData.symbols.values.toList();
                    //             final List<Currency> currencies =
                    //                 symbolsData.symbols.values.toList();
                    //
                    //             return Text(
                    //                 '${currencies[index].code} : ${currencies[index].description} ');
                    //           })),
                    // );
                  },
                  error: (NetworkExceptions networkExceptions) {
                    return Center(
                      child: Text(
                          NetworkExceptions.getErrorMessage(networkExceptions)),
                    );
                  },
                );
                //   if (state is ) {
                //    // user = (state).newUser;
                //     return Container(
                //       height: 50,
                //       color: Colors.amber,
                //       child: Center(child: Text((state).user.toString())),
                //     );
                //   } else {
                //     return const Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }
              },
            ),

            25.ph,
            // SizedBox(
            //   height: 300,
            //   child: PagedListView.separated(
            //     pagingController: _pagingController,
            //     shrinkWrap: true,
            //     builderDelegate: PagedChildBuilderDelegate(
            //       itemBuilder: (context, item, index) {
            //         return TextWidget(txt: itemsList[index]);
            //       },
            //     ),
            //     separatorBuilder: (context, index) {
            //       return Divider();
            //     },
            //   ),
            // ),
            Visibility(
              visible: convertSelected && baseSelected,
              replacement: const TextWidget(
                txt: 'You should select currencies',
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ExchangeCubit>(context)
                        .emitGetExchangeRates(
                            DateFormat('yyyy-MM-dd')
                                .format(selectedBeforeDate)
                                .toString(),
                            DateFormat('yyyy-MM-dd')
                                .format(selectedToDate)
                                .toString(),
                            dropDownBaseValue.toString(),
                            dropDownConvertToValue.toString());
                    setState(() {
                      exchangePressed = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.carolinaBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_exchange),
                      15.pw,
                      const TextWidget(
                        txt: 'Currency Exchange',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColor.black,
                      ),
                    ],
                  )),
            ),
            Visibility(
              visible: exchangePressed,
              child: BlocBuilder<ExchangeCubit, ExchangeState<ExchangeRates>>(
                builder: (context, ExchangeState<ExchangeRates> state) {
                  return state.when(
                    idle: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    success: (ExchangeRates exchangeRates) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: SizedBox(
                            height: 180,
                            child: ListView.builder(
                              itemCount: exchangeRates.rates.length,
                              itemBuilder: (context, index) {
                                final date =
                                    exchangeRates.rates.keys.toList()[index];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      txt: 'Date: $date',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    10.ph,
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          exchangeRates.rates[date]!.length,
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
                                        );
                                      },
                                    ),
                                    20.ph,
                                  ],
                                );
                              },
                            )

                            // child: PagedListView.separated(
                            //   pagingController: _pagingController,
                            //   shrinkWrap: true,
                            //   builderDelegate: PagedChildBuilderDelegate(
                            //     itemBuilder: (context, item, index) {
                            //       return TextWidget(txt: itemsList[index]);
                            //     },
                            //   ),
                            //   separatorBuilder: (context, index) {
                            //     return Divider();
                            //   },
                            // ),
                            ),
                      );
                    },
                    error: (NetworkExceptions networkExceptions) {
                      return Center(
                        child: Text(NetworkExceptions.getErrorMessage(
                            networkExceptions)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
              },
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.carolinaBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
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

  Future<DateTime?> showDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }
}
