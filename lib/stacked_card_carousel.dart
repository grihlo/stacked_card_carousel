library stacked_card_carousel;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// A widget for creating a vertical carousel with stacked cards.
///
/// Attributes:
///
/// Input your cards in `items`.
///
/// Select a `type` from enum `StackedCardCarouselType`:
/// `StackedCardCarouselType.cardsStack` makes an animation that makes an effect
/// of stack of cards.
/// `StackedCardCarouselType.fadeOutStack` makes an animation that makes an
/// effect of faded out cards as soon as they are going to be stacked.
///
/// `initialOffset` is initial vertical top offset for cards.
///
/// `spaceBetweenItems` is vertical space between items. Value start from top of
/// a first item. Choose a value that is related to your card size.
/// To make it responsive use `MediaQuery.of(context).size.height` * percentage.
///
/// `applyTextScaleFactor` if set to true scales up space and position linearly
/// according to text scale factor. Scaling down is not included.
///
/// `pageController` ise it for your custom page controller.
///
/// `onPageChanged` listen to page index changes.
class StackedCardCarousel extends StatefulWidget {
  StackedCardCarousel({
    @required List<Widget> items,
    StackedCardCarouselType type = StackedCardCarouselType.cardsStack,
    double initialOffset = 40.0,
    double spaceBetweenItems = 400,
    bool applyTextScaleFactor = true,
    PageController pageController,
    OnPageChanged onPageChanged,
  })  : assert(items != null && items.isNotEmpty),
        _items = items,
        _type = type,
        _initialOffset = initialOffset,
        _spaceBetweenItems = spaceBetweenItems,
        _applyTextScaleFactor = applyTextScaleFactor,
        _pageController = pageController ?? _defaultPageController,
        _onPageChanged = onPageChanged;

  final List<Widget> _items;
  final StackedCardCarouselType _type;
  final double _initialOffset;
  final double _spaceBetweenItems;
  final bool _applyTextScaleFactor;
  final PageController _pageController;
  final OnPageChanged _onPageChanged;

  @override
  _StackedCardCarouselState createState() => _StackedCardCarouselState();
}

class _StackedCardCarouselState extends State<StackedCardCarousel> {
  double _pageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    widget._pageController.addListener(() {
      if (mounted) {
        setState(() {
          _pageValue = widget._pageController.page;
        });
      }
    });

    return ClickThroughStack(
      children: <Widget>[
        _stackedCards(context),
        PageView.builder(
          scrollDirection: Axis.vertical,
          controller: widget._pageController,
          itemCount: widget._items.length,
          onPageChanged: widget._onPageChanged,
          itemBuilder: (BuildContext context, int index) {
            return Container();
          },
        ),
      ],
    );
  }

  Widget _stackedCards(BuildContext context) {
    double textScaleFactor = 1.0;
    if (widget._applyTextScaleFactor) {
      final double mediaQueryFactor = MediaQuery.of(context).textScaleFactor;
      if (mediaQueryFactor > 1.0) {
        textScaleFactor = mediaQueryFactor;
      }
    }

    final List<Widget> _positionedCards = widget._items.asMap().entries.map(
      (MapEntry<int, Widget> item) {
        double position = -widget._initialOffset;
        if (_pageValue < item.key) {
          position += (_pageValue - item.key) *
              widget._spaceBetweenItems *
              textScaleFactor;
        }
        switch (widget._type) {
          case StackedCardCarouselType.fadeOutStack:
            double opacity = 1.0;
            double scale = 1.0;
            if (item.key - _pageValue < 0) {
              final double factor = 1 + (item.key - _pageValue);
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
              final double factor = 1 + (item.key - _pageValue);
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
        overflow: Overflow.clip,
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: _positionedCards);
  }
}

// To allow all gestures detections to go through
// https://stackoverflow.com/questions/57466767/how-to-make-a-gesturedetector-capture-taps-inside-a-stack
class ClickThroughStack extends Stack {
  ClickThroughStack({List<Widget> children}) : super(children: children);

  @override
  ClickThroughRenderStack createRenderObject(BuildContext context) {
    return ClickThroughRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
    );
  }
}

class ClickThroughRenderStack extends RenderStack {
  ClickThroughRenderStack({
    AlignmentGeometry alignment,
    TextDirection textDirection,
    StackFit fit,
  }) : super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
        );

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

final PageController _defaultPageController = PageController();

enum StackedCardCarouselType {
  cardsStack,
  fadeOutStack,
}

typedef OnPageChanged = void Function(int pageIndex);
