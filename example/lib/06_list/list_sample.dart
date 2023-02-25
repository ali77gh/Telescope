import 'package:flutter/material.dart';
import 'package:telescope/src/telescope.dart';
import 'package:telescope/telescope.dart';


class ListSampleLayout extends StatefulWidget {
  @override
  State<ListSampleLayout> createState() => ListSampleLayoutState();
}

class ListSampleLayoutState extends State<ListSampleLayout> {

  late Telescope<String> searchText;
  late TelescopeList<String> items;
  late TelescopeList<String> showingItems;
  late TextEditingController textController = TextEditingController(text: "");

  @override
  void initState(){
    super.initState();
    searchText = Telescope<String>("");
    items = TelescopeList<String>(["ab", "abb", "bc", "bcc" , "c"]);

    showingItems = TelescopeList<String>([], dependsOn: DependsOnTelescope([items, searchText],(){
        return items.value.where((element) => element.contains(searchText.value)).toList();
    }));

  }

  @override
  Widget build(BuildContext context) {

    // TODO add fab to add item to list
    // TODO change a row
    print("build");
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                      itemCount: showingItems.watch(this).length,
                      itemBuilder: (context, index) {
                        return Card(
                            margin: const EdgeInsets.all(20),
                            child: Text(
                                "$index. ${showingItems[index]} (len:${showingItems[index]!.length})",
                                style: const TextStyle(fontSize: 40),
                            )
                        );
                      })
                  ),
                  TextField(
                    controller: textController,
                    style: const TextStyle(fontSize: 50),
                    onChanged: (content){
                      searchText.value = content;
                    },
                  )
                ],
              ),
            )
        )
    );
  }
}