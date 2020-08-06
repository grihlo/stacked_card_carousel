import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  final List<Widget> fancyCards = [
    FancyCard(
      color: Colors.green,
    ),
    FancyCard(
      color: Colors.orange,
    ),
    FancyCard(
      color: Colors.blue,
    ),
    FancyCard(
      color: Colors.red,
    ),
    FancyCard(
      color: Colors.green,
    ),
    FancyCard(
      color: Colors.purple,
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
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
        clipBehavior: Clip.antiAlias,
        elevation: 10.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Column(
          children: <Widget>[
            Container(
              width: 250,
              height: 300,
              child: Placeholder(color: color),
            ),
            Text(
              "Title",
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
              child: Text("Tap me!"),
              onPressed: () => print("Button was tapped"),
            ),
          ],
        ));
  }
}
