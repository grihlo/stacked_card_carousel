library stacked_card_carousel;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StackedCardCarousel extends StatefulWidget {
  const StackedCardCarousel({
    @required List<Widget> items,
    double initialOffset = 40.0,
    double spaceBetweenItems = 400.0,
    StackedCardCarouselType type = StackedCardCarouselType.fadeOutStack,
  })  : _items = items,
        _initialOffset = initialOffset,
        _spaceBetweenItems = spaceBetweenItems,
        _type = type;

  final List<Widget> _items;
  final double _initialOffset;
  final double _spaceBetweenItems;

  final StackedCardCarouselType _type;

  @override
  _StackedCardCarouselState createState() => _StackedCardCarouselState();
}

class _StackedCardCarouselState extends State<StackedCardCarousel> {
  final PageController _pageController = PageController();
  double _pageValue = 0.0;

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
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: widget._items.length,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    ]);
  }

  Widget _stackedCards(BuildContext context) {
    final List<Widget> _positionedCards = widget._items.asMap().entries.map(
      (MapEntry<int, Widget> item) {
        double position = -widget._initialOffset;
        if (_pageValue < item.key) {
          position += (_pageValue - item.key) *
              widget
                  ._spaceBetweenItems; // TODO(grisha): Add adaptable space (e.g factor * MediaQuery.of(context).textScaleFactor)
        }
        switch (widget._type) {
          case StackedCardCarouselType.fadeOutStack:
            double opacity = 1.0;
            double scale = 1.0;
            if (item.key - _pageValue < 0) {
              final factor = 1 + (item.key - _pageValue);
              opacity = factor < 0.0 ? 0.0 : pow(factor, 1.5).toDouble();
              scale = factor < 0.0 ? 0.0 : pow(factor, 0.1).toDouble();
            }
            return Positioned.fill(
              top: -position,
              child: Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  children: <Widget>[
                    Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: item.value,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case StackedCardCarouselType.cardsStack:
          default:
            double scale = 1.0;
            if (item.key - _pageValue < 0) {
              final factor = 1 + (item.key - _pageValue);
              scale = 0.95 + (factor * 0.1 / 2);
            }
            return Positioned.fill(
              top: -position + (20.0 * item.key),
              child: Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  children: <Widget>[
                    Transform.scale(
                      scale: scale,
                      child: item.value,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    ).toList();

    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: _positionedCards);
  }
}

// To allow all gestures detections to go through
// https://stackoverflow.com/questions/57466767/how-to-make-a-gesturedetector-capture-taps-inside-a-stack
class CustomStack extends Stack {
  CustomStack({List<Widget> children}) : super(children: children);

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
  CustomRenderStack({
    AlignmentGeometry alignment,
    TextDirection textDirection,
    StackFit fit,
    Overflow overflow,
  }) : super(
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            overflow: overflow);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    bool stackHit = false;

    final List<RenderBox> children = getChildrenAsList();

    for (final RenderBox child in children) {
      final StackParentData childParentData =
          child.parentData as StackParentData;

      final bool childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) {
        stackHit = true;
      }
    }

    return stackHit;
  }
}

enum StackedCardCarouselType {
  cardsStack,
  fadeOutStack,
}
