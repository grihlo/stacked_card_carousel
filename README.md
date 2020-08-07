# stacked_card_carousel

A widget for creating a vertical carousel with stacked cards.

## ⚙️ Installation

1. Add package to your pubspec.yaml
  ```
  dependencies:
    stacked_card_carousel: ^0.0.1
  
  ```
2. Get the package from pub:

  ```
  flutter packages get
  ```
## 📱 Usage

1. Import package in your file

  ```
  import 'package:stacked_card_carousel/stacked_card_carousel.dart';
  ```

2. Use `StackedCardCarousel` widget

  ```
    StackedCardCarousel(
        items: cards,  // Add your list of card widgets. Accepted type: List<Widget>
        type: StackedCardCarouselType.fadeOutStack,  // Choose a type of cards stack. Default: cardsStack
        initialOffset: 20.0,  // Set initial vertical top offset for cards. Default: 40.0
        spaceBetweenItems: 200,  // Configure vertical space between items. Value start from top of a first item. Default: 400.0
        applyTextScaleFactor: false,  // If set to true scales up space and position linearly according to text scale factor. Scaling down is not included. Default: true
        pageController: PageController(),  // Use your own page controller. Default: PageController()
        onPageChanged: (int pageIndex) => print(pageIndex),  // Listen to page index changes.
    );
  ```
