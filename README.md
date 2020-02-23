# inherited_store

A widget that only rebuilds the widgets whom depend on the changed data.

This package uses `InharitedModel` as its base.

## Example

`TODO: Demo gif`

The code for the example is in the example tab. 

## Getting Started

### Step 1: Wrap your app with your Store

```dart
    Store(
      data: {
        'counter': 1,
      },
      child: MaterialApp(
        /* ... */
      ),
    );
```

### Step 2: use it

```dart
class CounterText extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Text(Store.of(context, 'counter').get().toString()); 
  }
}
```

If you edit `counter` using `Store.of(context,'counter').set(2)` the CounterText widget
will be automatically rebuilt.

### What exactly gets rebuilt?
When you call `Store.of(context,'key')` all the widgets that use the current `context`
will be subscribed to changes for that key.
If the value for the key changes the widget that uses the subscribed context will be  

## Read the source code
Less then 100 lines of code!
[link] [https://github.com/ali2236/inherited_store/blob/master/lib/src/store.dart]

## Suggested use cases

### 1.Store global variables

### 1.Managing App Preferences

You can use `Inherited_Store` to effectively manage your app preferences.

#### How to do
TODO: explanation
```dart
//TODO
```

## Advantages

1. lightweight (less that 100 lines of code)
2. uses flutter's own `InheritedModel` & `InheritedModel` for detecting what needs to be rebuilt.
3. no boilerplate code 

## Disadvantages

1. using string for keys is inconvenient
    [flutter_store][https://pub.dev/packages/flutter_store] is another package for state management
    that uses abstract store classes in inherited widget to go around this issue.
2. no computed values