// Events
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategory extends CategoryEvent {}

class CategoriesByIds extends CategoryEvent {
  final List<String> ids;

  CategoriesByIds({
    required this.ids,
  });

  @override
  List<Object> get props => [ids];
}
