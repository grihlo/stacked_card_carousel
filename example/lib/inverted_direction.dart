import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked card carousel - Inverted direction',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Stacked card carousel'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  final List<Widget> fancyCards = <Widget>[
    FancyCard(
      image: Image.asset("assets/pluto-done.png"),
      title: "Say hello to planets!",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-fatal-error.png"),
      title: "Don't be sad!",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-coming-soon.png"),
      title: "Go for a walk!",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-sign-up.png"),
      title: "Try teleportation!",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-waiting.png"),
      title: "Enjoy your coffee!",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-welcome.png"),
      title: "Play with your cat!",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StackedCardCarousel(
        items: fancyCards,
        inverse: true,
        initialOffset: 100,
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({
    super.key,
    required this.image,
    required this.title,
  });

  final Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 250,
              height: 250,
              child: image,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            OutlinedButton(
              child: const Text("Learn more"),
              onPressed: () => print("Button was tapped"),
            ),
          ],
        ),
      ),
    );
  }
}
