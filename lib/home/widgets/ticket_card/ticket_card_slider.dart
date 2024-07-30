import 'package:flutter/material.dart';
import 'package:gallery_app/home/widgets/ticket_card/ticket_card.dart';

class TicketCardSlider extends StatelessWidget {
  final PageController pageController;
  final List<List<String>> images;

  const TicketCardSlider({
    super.key,
    required this.pageController,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: true,
      controller: pageController,
      itemCount: images.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => TicketCard(images: images[index]),
    );
  }
}
