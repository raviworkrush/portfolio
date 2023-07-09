import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:me/bloc/logging/app_logging.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/data/repositories/api_repository.dart';
import 'package:me/data/utils/contants.dart';
import 'ui/pages/home_page.dart';

Future<void> main() async {
  /// initialize flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  /// register license assets/fonts/OFL.txt
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['urbanist'], license);
  });

  /// use web plugin for removing # from url
  setUrlStrategy(PathUrlStrategy());
  Bloc.observer = Logging();
  runApp(const MyApp());
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
            fontFamily: kFontFamily,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
              brightness: Brightness.dark,
            ).copyWith(
              background: Colors.black,
            ),
          ),
          home: const MyHomePage(),
        ),
      );
}

//https://script.google.com/macros/s/AKfycbybg2YLApS964dNOB8UJE7K3bKRA2obfIBxYGwDY7zkAV2ONr2-/exec
