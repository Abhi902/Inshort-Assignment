import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inshort_assignment/src/presentation/bloc/home_event_bloc.dart';

import 'src/presentation/pages/home_page.dart';
import 'src/data/api/tmdb_api_client.dart';
import 'src/data/local/movie_hive_adapter.dart';
import 'src/data/repositories/movie_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open box
  await Hive.initFlutter();
  Hive.registerAdapter(MovieHiveAdapter());
  final movieBox = await Hive.openBox<MovieHive>('moviesBox');

  // Initialize Dio and Retrofit client
  final dio = Dio();
  final apiClient = TmdbApiClient(dio);

  // Provide your TMDB API key here
  const apiKey = '013ea9a262afac3c059176f1448cf617';

  // Initialize repository
  final movieRepository = MovieRepository(
    apiClient: apiClient,
    movieBox: movieBox,
    apiKey: apiKey,
  );

  runApp(MyApp(movieRepository: movieRepository));
}

class MyApp extends StatelessWidget {
  final MovieRepository movieRepository;

  const MyApp({Key? key, required this.movieRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => MaterialApp(
        title: 'Movies Database',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocProvider(
          create: (context) => HomeBloc(movieRepository: movieRepository),
          child: const HomePage(),
        ),
      ),
    );
  }
}
