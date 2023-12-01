part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class LoadFoodsFromVendor extends FoodEvent {
  final int limit;
  final DocumentSnapshot? lastDocument;

  LoadFoodsFromVendor({required this.limit, this.lastDocument});
}

class LoadFoods extends FoodEvent {
  // limit, lastDocument
  final int limit;
  final DocumentSnapshot? lastDocument;

  LoadFoods({
    required this.limit,
    required this.lastDocument,
  });
}

class FetchMoreFoods extends FoodEvent {
  // limit, lastDocument
  final int limit;
  final DocumentSnapshot? lastDocument;

  FetchMoreFoods({
    required this.limit,
    required this.lastDocument,
  });
}

class QueryFoods extends FoodEvent {}

class FetchOrderCount extends FoodEvent {
  final String foodId;

  FetchOrderCount({required this.foodId});
}
