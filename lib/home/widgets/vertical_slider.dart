import 'package:flutter/material.dart';

class VerticalTabSlider extends StatelessWidget {
  final TabController tabController;
  final List<String> tabTitles;

  const VerticalTabSlider({
    super.key,
    required this.tabController,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: RotatedBox(
        quarterTurns: 3,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          indicatorWeight: 3,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
    );
  }
}
