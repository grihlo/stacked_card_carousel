library stacked_card_carousel;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StackedCardCarousel extends StatefulWidget {
  StackedCardCarousel({
    @required List<Widget> items,
    StackedCardCarouselType type = StackedCardCarouselType.cardsStack,
  })  : _items = items,
        _type = type;

  final List<Widget> _items;
  final StackedCardCarouselType _type;

  @override
  _StackedCardCarouselState createState() => _StackedCardCarouselState();
}

class _StackedCardCarouselState extends State<StackedCardCarousel> {
  var _pageController = PageController();
  var _pageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        _pageValue = _pageController.page;
      });
    });

    return CustomStack(children: <Widget>[
      _stackedCards(context),
      PageView.builder(
        controller: _pageController,
        itemCount: widget._items.length,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    ]);
  }

  Widget _stackedCards(BuildContext context) {
    List<Widget> _positionedCards = widget._items.asMap().entries.map((item) {
      double position = 100.0;
      if (_pageValue < item.key) {
        position += (_pageValue - item.key) * 300;
      }
      switch (widget._type) {
        case StackedCardCarouselType.fadeOutStack:
          double opacity = 1.0;
          if (item.key - _pageValue < 0) {
            final factor = 1 + (item.key - _pageValue);
            opacity = 1 + (item.key - _pageValue) < 0.0 ? 0.0 : sqrt(factor);
          }
          return Positioned(
              bottom: position,
              child: Opacity(opacity: opacity, child: item.value));
        case StackedCardCarouselType.cardsStack:
        default:
          return Positioned(
              right: position - 10 * item.key, child: item.value);
      }
    }).toList();

    return Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: _positionedCards);
  }
}

// To allow all gestures detections to go through
// https://stackoverflow.com/questions/57466767/how-to-make-a-gesturedetector-capture-taps-inside-a-stack
class CustomStack extends Stack {
  CustomStack({children}) : super(children: children);

  @override
  CustomRenderStack createRenderObject(BuildContext context) {
    return CustomRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      overflow: overflow,
    );
  }
}

class CustomRenderStack extends RenderStack {
  CustomRenderStack({alignment, textDirection, fit, overflow})
      : super(
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            overflow: overflow);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    var stackHit = false;

    final children = getChildrenAsList();

    for (var child in children) {
      final StackParentData childParentData = child.parentData;

      final childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) stackHit = true;
    }

    return stackHit;
  }
}

enum StackedCardCarouselType {
  cardsStack,
  fadeOutStack,
}
