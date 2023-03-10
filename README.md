# Telescope
<img src="telescope.png"> <br>
Just another state manager for flutter based on observable design pattern.

Telescope tries to be:
1. Easy to learn (You can learn it in 5-10 min by reading README.md file).
2. Easy to use (with dependsOn and saveOnDisk features).
3. Flexible 
   1. Can be used beside other state managers.
   2. It lets you do it in your way.
4. Make it harder to make bugs
   1. With separation of concerns.
   2. No setState() needed.
5. Performance (just rebuild widgets that need to rebuild).


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

<img src="telescope.gif"> <br>

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

### Save On Disk
You can save telescope data on disk easily like this:
```dart
static var height = Telescope.saveOnDiskForBuiltInType(187, "bmi_height_input");
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

# License GPL3