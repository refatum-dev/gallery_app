import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class TabContainerEvent extends Equatable {
  const TabContainerEvent();

  @override
  List<Object> get props => [];
}

class LoadTabContainerData extends TabContainerEvent {}

// State
abstract class TabContainerState extends Equatable {
  const TabContainerState();

  @override
  List<Object> get props => [];
}

class TabContainerLoading extends TabContainerState {}

class TabContainerLoaded extends TabContainerState {
  final List<String> tabTitles;
  final List<List<String>> tabImages;

  const TabContainerLoaded({
    required this.tabTitles,
    required this.tabImages,
  });

  @override
  List<Object> get props => [tabTitles, tabImages];
}

class TabContainerError extends TabContainerState {
  final String message;

  const TabContainerError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class TabContainerBloc extends Bloc<TabContainerEvent, TabContainerState> {
  TabContainerBloc() : super(TabContainerLoading()) {
    on<LoadTabContainerData>(_onLoadGalleryData);
  }

  void _onLoadGalleryData(
      LoadTabContainerData event, Emitter<TabContainerState> emit) async {
    try {
      const int numberOfTabs = 5;
      const int imagesPerTab = 3;

      final tabTitles =
          List.generate(numberOfTabs, (index) => 'Tab ${index + 1}')
              .reversed
              .toList();

      final tabImages = List.generate(
        numberOfTabs,
        (tabIndex) => List.generate(
          imagesPerTab,
          (imageIndex) =>
              'https://picsum.photos/seed/${generateRandomSeed()}/1000/1000',
        ),
      );

      emit(TabContainerLoaded(tabTitles: tabTitles, tabImages: tabImages));
    } catch (e) {
      emit(const TabContainerError('Failed to load data'));
    }
  }
}

String generateRandomSeed() {
  Random random = Random();
  return random.nextInt(1000000).toString();
}
