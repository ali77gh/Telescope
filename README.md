# Telescope
<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.png" height="200" width="200"> <br>
Just another state manager for flutter based on observable:eyes: design pattern.

Telescope:telescope: tries to be:
1. Easy to learn:book: (You can learn it in 5-10 min by reading README.md file).
2. Easy to use:hearts: (with dependsOn and saveOnDisk features).
3. Flexible:ocean:
   1. Can be used beside other state managers:couple:.
   2. It lets you do it in your way:muscle:.
4. Make it harder to make bugs:beetle::no_entry:.
   1. With separation of concerns:raised_hands:.
   2. No setState() needed:no_good:.
5. Performance:zap: (just rebuild widgets that need to rebuild).
6. Lightweight:hatched_chick: (less then 900KB)

### Installation
```bash
flutter pub add telescope
```

### Import:
```dart
import 'package:telescope/telescope.dart';
```

# How to use
In 3 easy steps.

### 1. Make a telescope :
```dart
  var textValue = Telescope("default value");
```

### 2. Watch(this):
Put this in middle of you widget build function.<br>
You can watch single telescope in multiple widget
```dart
@override
Widget build(BuildContext context) {
  return Material(
      child: SafeArea(
          child: Container(
            child: Column(children: [
              // watch like this ('this' is State that will automatically rebuild on data change )
              Text(textValue.watch(this)), 
              Text(textValue.watch(this)),
              Text(textValue.watch(this).length.toString()),
            ],),
          )
      )
  );
}
```

### 3. Update value:
You can update telescope.value from anywhere from your code:

```dart
onTap: (){
  textValue.value += "a";
}
```

### Boom:
And state will get update automatically without calling setState

<img src="https://raw.githubusercontent.com/ali77gh/Telescope/master/telescope.gif"> <br>

# Other features:

### Depends on:
Telescopes can be depended on other telescopes

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

#### Observable on loading state
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

This  method also can use in TelescopeList in same way.

# Examples
   Checkout telescope/examples 

# License
MIT
