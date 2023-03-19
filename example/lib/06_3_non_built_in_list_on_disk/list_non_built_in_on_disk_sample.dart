import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class Contact {
  String name;
  String phone;
  Contact(this.name, this.phone);

  @override
  int get hashCode => name.hashCode * phone.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

class ContactOnDiskAbility implements OnDiskSaveAbility<Contact> {
  @override
  Contact parseOnDiskString(String data) {
    var sp = data.split(":");
    return Contact(sp[0], sp[1]);
  }

  @override
  String toOnDiskString(Contact instance) =>
      "${instance.name}:${instance.phone}";
}

class ListNonBuiltInOnDiskSample extends StatefulWidget {
  const ListNonBuiltInOnDiskSample({Key? key}) : super(key: key);

  @override
  State<ListNonBuiltInOnDiskSample> createState() =>
      ListNonBuiltInOnDiskSampleState();
}

class ListNonBuiltInOnDiskSampleState
    extends State<ListNonBuiltInOnDiskSample> {
  late Telescope<String> searchText;
  late TelescopeList<Contact> items;
  late TelescopeList<Contact> showingItems;
  late TextEditingController textController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    searchText = Telescope<String>("");
    items = TelescopeList<Contact>.saveOnDiskForNonBuiltInType(
        [Contact("Ali", "+98111"), Contact("Hasan", "+98222")],
        "contacts_list_test2",
        ContactOnDiskAbility());

    showingItems = TelescopeList.dependsOn([items, searchText], () {
      return items.value
          .where((element) => element.name.contains(searchText.value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'search'),
                controller: textController,
                style: const TextStyle(fontSize: 50),
                onChanged: (content) {
                  searchText.value = content;
                },
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: showingItems.watch(this).length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: GestureDetector(
                          onTap: () {
                            var name = showingItems[index]!;
                            var itemIndex = items.value.indexOf(name);
                            items[itemIndex]!.phone =
                                "${items[itemIndex]!.phone}0";
                            // items.notifyAll();
                          },
                          child: Text(
                            "${index + 1}. ${showingItems[index]!.name} (phone:${showingItems[index]!.phone})",
                            style: const TextStyle(fontSize: 40),
                          ),
                        ));
                      })),
              FloatingActionButton(
                  onPressed: () {
                    items.add(getNewContact());
                  },
                  child: const Text("Add"))
            ],
          ),
        )));
  }

  var others = [
    Contact("Majid0", "+983330"),
    Contact("Majid1", "+983331"),
    Contact("Majid2", "+983332"),
    Contact("Majid3", "+983333"),
  ];
  Contact getNewContact() => others.removeAt(0);
}
