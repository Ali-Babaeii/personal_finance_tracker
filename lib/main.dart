import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/transaction_cubit.dart';
import 'bloc/theme_cubit.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';
import 'screens/home//home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  final transactionRepository = TransactionRepository();
  await transactionRepository.init();

  runApp(MyApp(repository: transactionRepository));
}

class MyApp extends StatelessWidget {
  final TransactionRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TransactionCubit(repository),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(ThemeMode.light),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
