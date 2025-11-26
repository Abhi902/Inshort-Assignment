import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inshort_assignment/src/data/local/movie_detail_hive_adapter.dart';
import 'src/presentation/home_bloc/home_event_bloc.dart';

import 'src/presentation/pages/home_page.dart';
import 'src/data/api/tmdb_api_client.dart';
import 'src/data/local/movie_hive_adapter.dart';
import 'src/data/repositories/movie_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open box
  await Hive.initFlutter();
  Hive.registerAdapter(MovieHiveAdapter());
  Hive.registerAdapter(MovieDetailsHiveAdapter());

  final movieBox = await Hive.openBox<MovieHive>('moviesBox');

  // Initialize Dio and Retrofit client
  final dio = Dio();
  dio.options.headers['Authorization'] =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMTNlYTlhMjYyYWZhYzNjMDU5MTc2ZjE0NDhjZjYxNyIsIm5iZiI6MTc2NDE3NDI2Ny41MzMsInN1YiI6IjY5MjcyOWJiZTBjNGNhZmY5MWE3NTgwZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sIZUabYkN-7dSpse1Pf6pl1TzHOMBnxS-f729aYIYWQ';
  dio.options.headers['accept'] = 'application/json';
  final apiClient = TmdbApiClient(dio);

  // Provide your TMDB API key here
  const apiKey = '013ea9a262afac3c059176f1448cf617';
  final movieDetailsBox =
      await Hive.openBox<MovieDetailsHive>('movieDetailsBox');

  // Initialize repository
  final movieRepository = MovieRepository(
    apiClient: apiClient,
    movieBox: movieBox,
    movieDetailsBox: movieDetailsBox, // Add details box here
    apiKey: apiKey,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TmdbApiClient>.value(value: apiClient),
        RepositoryProvider<String>.value(value: apiKey),
        RepositoryProvider<MovieRepository>.value(value: movieRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              movieRepository: context.read<MovieRepository>(),
            ),
          ),
          // Add other BlocProviders here e.g. MovieDetailsBloc if needed globally
        ],
        child: MaterialApp(
          title: 'Movies Database',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomePage(),
        ),
      ),
    );
  }
}
