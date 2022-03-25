import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me/bloc/logging/app_logging.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/data/repositories/api_repository.dart';
import 'package:me/data/utils/contants.dart';
import 'package:url_strategy/url_strategy.dart';
import 'ui/pages/home_page.dart';

Future<void> main() async {
  setPathUrlStrategy();
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: Logging(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ProjectCubit>(
            create: (context) => ProjectCubit(APIRepository())..getProjects(),
          ),
          BlocProvider<MessageCubit>(
            create: (context) => MessageCubit(APIRepository()),
          ),
        ],
        child: MaterialApp(
          title: kName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            fontFamily: kFontFamily,
            useMaterial3: true,
            backgroundColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
                elevation: 0.0, backgroundColor: Colors.transparent),
          ),
          home: const MyHomePage(),
        ),
      );
}


//https://script.google.com/macros/s/AKfycbybg2YLApS964dNOB8UJE7K3bKRA2obfIBxYGwDY7zkAV2ONr2-/exec