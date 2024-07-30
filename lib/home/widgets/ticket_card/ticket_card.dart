import 'package:flutter/material.dart';

class TicketCard extends StatefulWidget {
  final List<String> images;

  const TicketCard({super.key, required this.images});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> with TickerProviderStateMixin {
  final PageController _controller = PageController();
  final int _currentPage = 0;

  final List<Animation<Offset>> _slideAnimations = [];
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();

    // костилив анімацію для кожної картинки, доволі цікаво
    for (int i = 0; i < 3; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (i + 1) * 250),
      )..forward();

      _animationControllers.add(controller);

      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey<String>(
          'slider-content-state'), // для збереження позиції
      controller: _controller,
      itemCount: widget.images.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            margin: EdgeInsets.symmetric(
              horizontal: index == _currentPage ? 10 : 20,
              vertical: 20,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
