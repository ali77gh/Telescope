# Telescope
<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.png" height="200" width="200"> <br>
Easy to use <b>State manager</b> for flutter based on observer👀 design pattern.

Note: There is a `1.x.x` branch for old friends [here](https://github.com/ali77gh/Telescope/tree/1.x.x) but version `2.x.x` is much better and I suggest a refactor.

``` Telescope is more than a normal observer. ```

Telescope🔭
<br>

0. Supports all platforms.
1. Easy to learn 📖 
   1. You can learn it in 5-10 min by reading README.
   2. Also see [examples](https://github.com/ali77gh/Telescope/tree/master/example/lib). 
   3. Full dart standard documentation [here](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
2. Easy to use 🫶:
   1. You can create an Automatically updatable Widget with a single `liveWidget` call.
   2. Works with StateLessWidgets.
   3. It Does call `setState()` for you on value change detection.
3. Efficient 🏎️:
   1. It only rebuilds small parts of page🪶.
   2. Only rebuilds when needed.
   3. Smart Disposal🗑️.
   4. less then 900KB 🐣.
4. Feature rich ♥️: 
   1. It can save your states on disk if you want (good for user settings).
   2. Telescopes can depends on each other by using `dependsOn()` constructor.
   3. Depends on can be async.
   4. Caching ability with `expireTime` option.
   5. `debounceTime` option (something like rx-js debounceTime).
   6. Request a feature [here](https://github.com/ali77gh/Telescope/issues).
6. Flexible 🌊
   1. It lets you do it in your way as a library (not a framework) 🗽.
   2. Can be used beside other state managers 🤝.

### Installation:
```bash
flutter pub add telescope
```

# How to use
3 simple steps.
1. Create a Telescope instance
2. Make a live widget with `liveWidget()` call.
3. Update state
4. Boom widget automatically got updated without `setState` call.

### Example

```dart
import 'package:telescope/telescope.dart';

@override
class TextSample extends StatelessWidget {
  final textValue = Telescope(""); // Telescope instance with default empty string
  final style = const TextStyle(fontSize: 60); 

  TextSample({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => textValue.value += "a", // updating telescope value
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // multiple update subscribers connected to single Telescope
            textValue.liveWidget((context, value) => Text(value, style: style)), // automatic updates
            textValue.liveWidget((context, value) => Text(value, style: style)), // automatic updates
            textValue.liveWidget((context, value) => Text(value.length.toString(), style: style)), // automatic updates
          ],
        ),
      ),
    );
  }
}
```
### Result:
<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.gif"> <br>

Note: You can also subscribe to observable by passing callback like a normal observable.
(Just in case) 🤷🏻
```dart
textValue.subscribe((newValue){
    // execute on value change
});
```

### Parent/Child relation 

You can pass telescopes around freely,\
See ([example](https://github.com/ali77gh/Telescope/tree/master/example/lib/05_share_telescope_as_param)).

### Non Builtin Types

Just implement hashCode getter:
```dart
class Human{
   int height;
   int weight;
   Human(this.height,this.weight);

   @override
   int get hashCode => height*weight;
}
```

And you are good to go:

```dart
var human = Telescope<Human?>(null);
```

Smart change detection needs `hashCode()` function to detect change (so that's why).

But if you don't want to do this for some reason there is a way out:

You can pass `iWillCallNotifyAll = true` and disable smart change detection:

```dart
var human = Telescope<Human>(Human("Ali", 24), iWillCallNotifyAll: true);
```

And make sure you call `notifyAll()` function manually after a change.

```dart
human.age = 30;
human.notifyAll();
```

# Other features:

### Depends on:
Telescopes can be depended on other telescopes.

```dart
var height = Telescope(186);
var weight = Telescope(72);

var bmi = Telescope.dependsOn([height,weight], () {
  return weight.value / ((height.value/100) * (height.value/100));
});

var showingText  = Telescope.dependsOn([bmi], () {
  return "weight is ${weight.value} and height is ${height.value} so bmi will be ${bmi.value.toString().substring(0,5)}";
});
```

So when ever height or weight value get changes, the bmi will calculate itself because it depends on height and weight.<br>
And showingText will calculate itself too, because it depends on bmi.

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
}, enableCaching: true);
```
You can also set expire time by passing <b>cacheExpireTime</b>.

#### Debounce:

debounceTime: will call your async function only if a given time has passed without any changes on dependencies.<br>
```dart
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
   return await calculateBMI(height.value, weight.value);
}, debounceTime: Duration(milliseconds: 500));
```

It's useful when you want to run your async function when user stop typing or moving slider or...

<br>

#### Observable on calculating/loading state:

This will make <b>isCalculatingBMI</b> true on loading and false when loaded, you may need this to show loading animation.
```dart
var isCalculatingBMI = Telescope<bool>(false);
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
   return await calculateBMI(height.value, weight.value);
}, isCalculating: isCalculatingBMI);
```

### Save On Disk

You can save telescope data on disk easily like this:
```dart
var height = Telescope.saveOnDiskForBuiltInType(187, "bmi_height_input");
```
So if user close the app and open it again it will load last value of telescope for You.

### Save non built-in values on disk

You need to implement OnDiskSaveAbility for your object:<br>
For example you have Human class:
```dart
class Human{
   int height;
   int weight;
   Human(this.height,this.weight);

   @override
   int get hashCode => height*weight;
}
```

Then you need to make other class like this for Human:
```dart
class HumanOnDiskAbility implements OnDiskSaveAbility<Human>{
   @override
   Human parseOnDiskString(String data) {
      var sp = data.split(":");
      return Human(int.parse(sp[0]), int.parse(sp[1]));
   }

   @override
   String toOnDiskString(Human instance) => "${instance.height}:${instance.weight}";
}
```

And pass instance of HumanOnDiskAbility to Telescope:
```dart
var human = Telescope.saveOnDiskForNonBuiltInType(
        Human(187, 72),
        "human_for_bmi",
        HumanOnDiskAbility()
);
```

Telescope will use 'parseOnDiskString' and 'toOnDiskString' to serialize and deserialize your object.

# Last Words:
   * Plz🙏 star ⭐repo.
   * [Full documentation](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
   * [Examples](https://github.com/ali77gh/Telescope/tree/master/example/lib).
   * Static instance of Telescopes? 
     * it's not recommend because it decreases re-usability of your code, but in some use-cases it's OK to do that🤷🏻.
   * Extends from Telescope?
     * Why not? TelescopeList actually extends from Telescope
   * Under MIT license 
