# stacked_card_carousel

A widget for creating a vertical carousel with stacked cards.

<p align="center">
<img src="example/assets/gifs/stacked_cards.gif" title="StackedCardCarouselType.cardsStack" height="500"/>
<img src="example/assets/gifs/fade_out_cards.gif" title="StackedCardCarouselType.fadeOutStack" height="500"/>
</p>

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
        items: cards,
    );
  ```

## 🎛 Attributes
| Attribute | Data type | Description | Default |
|--|--|--|--|
| items | List<Widget> | List of card widgets. | - |
| type | StackedCardCarouselType | A type of cards stack carousel. | cardsStack |
| initialOffset | double | Initial vertical top offset for cards. | 40.0 |
| spaceBetweenItems | double | Vertical space between items. Value start from top of a first item. | 400.0 |
| applyTextScaleFactor | bool | If set to true scales up space and position linearly according to text scale factor. Scaling down is not included. | true |
| pageController | PageController | Use it for your custom page controller. | PageController() |
| onPageChanged | void Function(int pageIndex) | Listen to page index changes. | null |

## 💻 Author
Grigori Hlopkov - [GitHub](https://github.com/grihlo)
