import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gallery_app/home/widgets/ticket_card/ticket_card.dart';

class TabContainerOld extends StatefulWidget {
  const TabContainerOld({super.key});

  @override
  State<TabContainerOld> createState() => _TabContainerOldState();
}

// перша монолітна версія TabContainer
class _TabContainerOldState extends State<TabContainerOld> with SingleTickerProviderStateMixin {
  static const int _numTabs = 5;
  static const int _imageWidth = 100;
  static const int _imageHeight = 100;
  static const double _tabBarWidth = 100;
  static const double _galleryItemMargin = 20;
  static const double _tabIndicatorWeight = 3;

  late final TabController _tabController;
  late final PageController _pageController;

  final List<String> _tabTitles = List.generate(_numTabs, (index) => 'Tab ${index + 1}').reversed.toList();
  final List<List<String>> _tabImages = List.generate(
    _numTabs,
    (tabIndex) => List.generate(
      1,
      (imageIndex) => 'https://picsum.photos/id/${1000 + tabIndex * 10 + imageIndex}/$_imageWidth/$_imageHeight',
    ),
  );

  late final List<String> _allImages;

  @override
  void initState() {
    super.initState();

    final int initialTabIndex = _tabTitles.length - 1;
    _tabController = TabController(initialIndex: initialTabIndex, length: _tabTitles.length, vsync: this);
    _pageController = PageController();

    _allImages = _tabImages.expand((images) => images).toList();

    _pageController.addListener(_syncTabWithPage);
    _tabController.addListener(_syncPageWithTab);
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
    final pageIndex = _pageController.page?.round() ?? 0;
    final tabIndex = pageIndex ~/ _tabImages[0].length;

    if (tabIndex != _tabController.index && tabIndex >= 0 && tabIndex < _tabTitles.length && !_tabController.indexIsChanging) {
      _tabController.animateTo(tabIndex);
    }
  }

  void _syncPageWithTab() {
    if (_tabController.indexIsChanging) {
      final targetPageIndex = _tabController.index * _tabImages[0].length;
      _pageController.animateToPage(
        targetPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          _buildVerticalTabBar(context),
          Expanded(child: _buildPageView()),
        ],
      ),
    );
  }

  Widget _buildVerticalTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: _tabBarWidth,
      child: RotatedBox(
        quarterTurns: 3,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: theme.colorScheme.secondary,
          indicatorWeight: _tabIndicatorWeight,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      reverse: true,
      controller: _pageController,
      itemCount: _allImages.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => _buildGalleryItem(_allImages[index]),
    );
  }

  Widget _buildGalleryItem(String imageUrl) {
    return Animate(
      effects: [
        // просто прикольні ефекти :D
        // FadeEffect(duration: 500.ms),
        // ScaleEffect(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 600.ms),
        MoveEffect(begin: const Offset(0, 100), end: const Offset(0, 0), duration: 700.ms, curve: Curves.easeInOut),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: _galleryItemMargin),
        child: TicketCard(images: [
          imageUrl,
          imageUrl,
          imageUrl,
        ]),
      ),
    );
  }
}