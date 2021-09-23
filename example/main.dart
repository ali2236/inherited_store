import 'package:flutter/material.dart';
import 'package:inherited_store/inherited_store.dart';

void main() => runApp(SettingsApp());

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Store(
      data: {
        'counter': 1,
        'counter2': 1,
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SettingsDisplay(),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Counter(
                    stKy: 'counter',
                  ),
                ),
                Expanded(
                  child: Counter(
                    stKy: 'counter2',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: StoreText(
                    storeKey: 'counter2',
                  ),
                ),
                Expanded(
                  child: StoreText(
                    storeKey: 'counter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: InheritedStore.of(context)
            .data
            .entries
            .map((e) => Text('${e.key} : ${e.value}'))
            .toList());
  }
}

class StoreText extends StatelessWidget {
  final String storeKey;

  const StoreText({Key? key, required this.storeKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 600)),
            builder: (c, s) {
              if (s.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              return Text(Store.of(context, storeKey).get().toString());
            }),
        Container(),
      ],
    );
  }
}

class Counter extends StatelessWidget {
  final String stKy;

  const Counter({Key? key, required this.stKy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 600)),
            builder: (context, s) {
              if (s.connectionState != ConnectionState.done)
                return CircularProgressIndicator();
              return Text(Store.of(context, stKy).get().toString());
            },
          ),
          ElevatedButton(
            child: Text('increment'),
            onPressed: () {
              Store.of(context, stKy).set(Store.of(context, stKy).get() + 1);
            },
          ),
        ],
      ),
    );
  }
}
