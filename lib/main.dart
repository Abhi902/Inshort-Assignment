// lib/main.dart

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'package:inshort_assignment/src/core/theme/app_theme.dart';
import 'package:inshort_assignment/src/data/api/tmdb_api_client.dart';
import 'package:inshort_assignment/src/data/interceptors/logging_interceptor.dart';
import 'package:inshort_assignment/src/data/interceptors/retry_interceptor.dart';
import 'package:inshort_assignment/src/data/local/bookmarked_movie_hive_adapter.dart';
import 'package:inshort_assignment/src/data/local/movie_detail_hive_adapter.dart';
import 'package:inshort_assignment/src/data/local/movie_hive_adapter.dart';
import 'package:inshort_assignment/src/data/repositories/movie_repository.dart';

import 'src/presentation/home_bloc/home_event_bloc.dart';
import 'src/presentation/pages/home_page.dart';
import 'src/presentation/pages/movie_details_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(MovieHiveAdapter());
  Hive.registerAdapter(MovieDetailsHiveAdapter());
  Hive.registerAdapter(BookmarkedMovieHiveAdapter());

  final movieBox = await Hive.openBox<MovieHive>('moviesBox');
  final bookmarkedBox =
      await Hive.openBox<BookmarkedMovieHive>('bookmarkedMoviesBox');
  final movieDetailsBox =
      await Hive.openBox<MovieDetailsHive>('movieDetailsBox');

  // Dio + TMDB client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(LoggingInterceptor());
  dio.interceptors.add(RetryInterceptor(dio: dio));
  dio.options.headers['Authorization'] =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMTNlYTlhMjYyYWZhYzNjMDU5MTc2ZjE0NDhjZjYxNyIsIm5iZiI6MTc2NDE3NDI2Ny41MzMsInN1YiI6IjY5MjcyOWJiZTBjNGNhZmY5MWE3NTgwZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sIZUabYkN-7dSpse1Pf6pl1TzHOMBnxS-f729aYIYWQ';
  dio.options.headers['accept'] = 'application/json';

  final apiClient = TmdbApiClient(dio);

  const apiKey = '013ea9a262afac3c059176f1448cf617';

  final movieRepository = MovieRepository(
    apiClient: apiClient,
    movieBox: movieBox,
    movieDetailsBox: movieDetailsBox,
    bookmarkedBox: bookmarkedBox,
    apiKey: apiKey,
  );

  runApp(
    AppRoot(
      apiClient: apiClient,
      apiKey: apiKey,
      movieRepository: movieRepository,
    ),
  );
}

class AppRoot extends StatefulWidget {
  final TmdbApiClient apiClient;
  final String apiKey;
  final MovieRepository movieRepository;

  const AppRoot({
    Key? key,
    required this.apiClient,
    required this.apiKey,
    required this.movieRepository,
  }) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // App launched via deep link
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } on PlatformException {
      // ignore
    } on FormatException {
      // bad URI, ignore
    }

    // App already running / background
    _sub = uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleUri(uri);
        }
      },
      onError: (Object err) {
        // ignore
      },
    );
  }

  void _handleUri(Uri uri) {
    // Real deep link: myflix://movie/{id}
    // Make sure your share link uses this format.
    if (uri.scheme == 'myflix' &&
        uri.host == 'movie' &&
        uri.pathSegments.isNotEmpty) {
      final id = int.tryParse(uri.pathSegments.first);
      if (id != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => MovieDetailsPage(movieId: id),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TmdbApiClient>.value(value: widget.apiClient),
        RepositoryProvider<String>.value(value: widget.apiKey),
        RepositoryProvider<MovieRepository>.value(
            value: widget.movieRepository),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                movieRepository: context.read<MovieRepository>(),
              ),
            ),
            // other global blocs if needed
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Movies Database',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark, // Netflix dark by default
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
