import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/home/bloc/tab_container_bloc.dart';
import 'package:gallery_app/home/widgets/ticket_card/ticket_card_slider.dart';
import 'package:gallery_app/home/widgets/vertical_slider.dart';

class TabContainer extends StatefulWidget {
  const TabContainer({super.key});

  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    const lengthOfTabs = 5;
    const initialIndex = lengthOfTabs - 1;
    
    _tabController = TabController(
      length: lengthOfTabs,
      vsync: this,
      initialIndex: initialIndex,
    );
    _pageController = PageController(initialPage: initialIndex);

    _pageController.addListener(_syncTabWithPage);
    _tabController.addListener(_syncPageWithTab);

    context.read<TabContainerBloc>().add(LoadTabContainerData());
  }

  @override
  void dispose() {
    _pageController.removeListener(_syncTabWithPage);
    _tabController.removeListener(_syncPageWithTab);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _syncTabWithPage() {
    if (_tabController.index != _pageController.page?.round()) {
      _tabController.animateTo(_pageController.page!.round());
    }
  }

  void _syncPageWithTab() {
    if (_pageController.page?.round() != _tabController.index) {
      _pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabContainerBloc, TabContainerState>(
      builder: (context, state) {
        if (state is TabContainerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TabContainerLoaded) {
          return SizedBox(
            height: 300,
            child: Row(
              children: [
                VerticalTabSlider(
                  tabController: _tabController,
                  tabTitles: state.tabTitles,
                ),
                Expanded(
                  child: TicketCardSlider(
                    pageController: _pageController,
                    images: state.tabImages,
                  ),
                )
              ],
            ),
          );
        } else if (state is TabContainerError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
