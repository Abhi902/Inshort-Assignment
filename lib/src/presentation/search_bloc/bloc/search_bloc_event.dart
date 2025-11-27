import 'package:equatable/equatable.dart';

abstract class SearchBlocEvent extends Equatable {
  const SearchBlocEvent();

  @override
  List<Object> get props => [];
}

class TextChanged extends SearchBlocEvent {
  final String text;

  const TextChanged(this.text);

  @override
  List<Object> get props => [text];
}
