# Telescope
<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.png" height="200" width="200"> <br>
Easy to use <b>State manager</b> for flutter based on observer:eyes: design pattern.

``` Telescope is more than a normal observer. ```

Telescope:telescope:
<br>
0. Supports all platforms.
1. Easy to learn:book: 
   1. You can learn it in 5-10 min by reading README.
   2. Also see [examples](https://github.com/ali77gh/Telescope/tree/master/example/lib). 
   3. Full dart standard documentation [here](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
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
Put this in middle of you widget build function.<br>
```dart
@override
Widget build(BuildContext context) {
  return Material(
      child: SafeArea(
          child: Container(
            child: Column(children: [
              // watch like this ('this' is State that will automatically rebuild on data change)
              Text(textValue.watch(this)), 
              Text(textValue.watch(this)),
              Text(textValue.watch(this).length.toString()),
            ],),
          )
      )
  );
}
```

Note: You can watch one telescope instance from multiple widgets([example](https://github.com/ali77gh/Telescope/tree/master/example/lib/05_share_telescope_as_param)).

### 3. Update value:
You can update telescope.value from anywhere in your code:

```dart
onTap: (){
  textValue.value += "a";
}
```

### Boom:
And the widget will get update automatically without calling setState.

<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.gif"> <br>

You can also subscribe to observable by passing callback like a normal observable.
```dart
textValue.subscribe((newValue){
    // execute on value change
});
```

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
var human = Telescope<Human>(null);
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

<br>

#### Async way:
```dart
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
  return await calculateBMI(height.value, weight.value);
});
```

<br>

#### Caching:
```dart
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
   return await calculateBMI(height.value, weight.value);
}, enableCaching: true);
```
You can also set expire time by passing <b>cacheExpireTime</b>.

<br>

#### Debounce:
debounceTime: will call your async function only if a given time has passed without any changes on dependencies.<br>
```dart
var bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
   return await calculateBMI(height.value, weight.value);
}, debounceTime: Duration(milliseconds: 500));
```
It's useful when you want to run your async function when user stop typing or moving slider or...


<br>

#### Observable on loading state:
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
<br>

### TelescopeList
Telescope implementation for list
   * can be dependent
   * can save on disk
```dart
var items = TelescopeList(["ab", "abb", "bc", "bcc" , "c"]);
```

### Save non built in values on disk
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
<br><br>

This method also can use in TelescopeList in same way.

<br>

### New Features

- TelescopeList: list version of Telescope
   - Supports dependency on other telescopes
   - Can save/load on disk
   - Calls `notifyAll` only once per actual change to avoid double rebuilds
- TelescopeBuilder: widget to rebuild only the widget that depends on telescope value
- TelescopeProvider: provide telescopes down the widget tree for easy access
- Selection API: watch and update selected items in lists efficiently
- Example: [https://github.com/ali77gh/Telescope/tree/master/example/lib//08_selective_rebuild_sample]

<br>

# Last Words:
   * Plz:pray: star:star: repo.
   * [Full documentation](https://pub.dev/documentation/telescope/latest/telescope/telescope-library.html).
   * [Examples](https://github.com/ali77gh/Telescope/tree/master/example/lib).
   * Static instance of Telescopes? 
     * it's not recommend because it decreases re-usability of your code, but in some use-cases it's OK to do that.
   * Extends from Telescope?
     * Why not? TelescopeList actually extends from Telescope
   * Under MIT license 
