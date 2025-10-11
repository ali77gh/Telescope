# Telescope

<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.png" height="200" width="200"> <br>
Easy to use <b>State manager</b> for flutter based on observer:eyes: design pattern.

```
Telescope is more than a normal observer.
```

Telescope:telescope: <br>

0. Supports all platforms.

1. Easy to learn:book:

    1. You can learn it in 5-10 min by reading README.
    2. Also see [examples](https://github.com/ali77gh/Telescope/tree/master/example/lib).
    3. Full dart standard
       documentation [here](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
2. Feature rich:hearts:

    1. Can directly bind to Flutters StateFullWidget and rebuild:recycle: widget on value change.
    2. Save states on disk and load when needed.
    3. Telescopes can watch each other with dependsOn() constructor.
    4. Depends on can be async.
    5. Caching ability with expireTime option.
    6. debounceTime option (something like rx-js debounceTime).
    7. Request a feature [here](https://github.com/ali77gh/Telescope/issues).
3. Make it harder to make bugs:beetle::no_entry:.

    1. With separation of concerns:raised_hands:.
    2. No setState() needed:no_good:.
4. Fast:zap: (just rebuild widgets that need to rebuild).
5. Lightweight:hatched_chick: (less then 900KB)
6. Flexible:ocean:

    1. It lets you do it in your way as a library (not a framework):muscle:.
    2. Can be used beside other state managers:couple:.

### Installation:

```bash
flutter pub add telescope
```

### Import:

```dart
import 'package:telescope/telescope.dart';
```

# How to use

In 3 steps.

### 1. Make a telescope instance:

```dart

var textValue = Telescope("default value");
```

### 2. Watch(this):

Put this in middle of your widget build function:

```dart
@override
Widget build(BuildContext context) {
  return Material(
      child: SafeArea(
          child: Container(
            child: Column(children: [
              Text(textValue.watch(this)),
              Text(textValue.watch(this)),
              Text(textValue
                  .watch(this)
                  .length
                  .toString()),
            ],),
          )
      )
  );
}
```

You can also use `TelescopeBuilder` to selectively rebuild a widget:

```dart
TelescopeBuilder<String>
(
telescope: textValue,
builder: (context, value) {
return Text("Current value: $value");
},
)
```

Or `TelescopeProvider` + `TelescopeSelector` for multiple telescopes:

```dart
TelescopeProvider
(
telescopes: {"text": textValue},
child: TelescopeSelector<String>(
keyName: "text",
builder: (context, val) {
return Text("Selected text: $val");
},
)
,
)
```

### 3. Update value:

You can update `telescope.value` from anywhere in your code:

```dart
GestureDetector
(
onTap: () {
textValue.value += "a";
},
child: Text("Add a"),
)
```

### Boom:

And the widget will get updated automatically without calling setState.

<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.gif"> <br>

You can also subscribe to observable by passing a callback:

```dart
textValue.subscribe
(
(newValue){
// execute on value change
});
```

### Non Builtin Types

Just implement hashCode getter:

```dart
class Human {
  int height;
  int weight;

  Human(this.height, this.weight);

  @override
  int get hashCode => height * weight;
}
```

Then:

```dart

var human = Telescope<Human>(null);
```

# Other features:

### Depends on:

Telescopes can depend on other telescopes.

```dart

var height = Telescope(186);
var weight = Telescope(72);

var bmi = Telescope.dependsOn([height, weight], () {
  return weight.value / ((height.value / 100) * (height.value / 100));
});

var showingText = Telescope.dependsOn([bmi], () {
  return "weight is ${weight.value} and height is ${height.value} so bmi will be ${bmi.value
      .toString().substring(0, 5)}";
});
```

#### Async way:

```dart

var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
  return await calculateBMI(height.value, weight.value);
});
```

#### Caching:

```dart

var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
  return await calculateBMI(height.value, weight.value);
}, enableCaching: true, cacheExpireTime: Duration(minutes: 5));
```

#### Debounce:

```dart

var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
  return await calculateBMI(height.value, weight.value);
}, debounceTime: Duration(milliseconds: 500));
```

#### Observable on loading state:

```dart

var isCalculatingBMI = Telescope<bool>(false);
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
  return await calculateBMI(height.value, weight.value);
}, isCalculating: isCalculatingBMI);
```

### Save On Disk

```dart

var height = Telescope.saveOnDiskForBuiltInType(187, "bmi_height_input");
```

### TelescopeList

```dart

var items = TelescopeList(["ab", "abb", "bc", "bcc", "c"]);
```

### Save non built in values on disk

```dart
class HumanOnDiskAbility implements OnDiskSaveAbility<Human> {
  @override
  Human parseOnDiskString(String data) {
    var sp = data.split(":";");
    return Human(int.parse(sp[0]),
        int
        .parse(sp[1])
    );
  }

  @override
  String toOnDiskString(Human instance) => "${instance.height}:${instance.weight}";
}

var human = Telescope.saveOnDiskForNonBuiltInType(
    Human(187, 72),
    "human_for_bmi",
    HumanOnDiskAbility()
);
```

This method also works with `TelescopeList`.

# Last Words:

* Plz:pray: star:star: repo.
* [Full documentation](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
* [Examples](https://github.com/ali77gh/Telescope/tree/master/example/lib).
* Static instance of Telescopes? Not recommended, but sometimes OK.
* Extends from Telescope? Why not! TelescopeList actually extends from Telescope.
* Under MIT license
