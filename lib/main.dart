import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/airport_bloc/airport_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

// lib/app.dart


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AirportBloc>(
          create: (_) => sl<AirportBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Airport Services',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}


