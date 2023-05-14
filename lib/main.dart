import 'package:currencytask/presentation/home/bloc/symbols_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import 'presentation/home/bloc/exchange_cubit.dart';
import 'presentation/home/screens/home_screen.dart';

void main() {
  initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => getIt<ExchangeCubit>(),
          ),
          BlocProvider(
            create: (BuildContext context) => getIt<SymbolsCubit>(),
          ),
        ],
        child: const HomePageScreen(),
      ),
    );
  }
}
