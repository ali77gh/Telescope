import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';
import 'dart:math';


class ListSampleLayout extends StatefulWidget {
  const ListSampleLayout({Key? key}) : super(key: key);

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

    showingItems = TelescopeList.dependsOn([items, searchText],(){
        return items.value.where((element) => element.contains(searchText.value)).toList();
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
                    onChanged: (content){
                      searchText.value = content;
                    },
                  ),
                  Expanded(
                      child: ListView.builder(
                      itemCount: showingItems.watch(this).length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: GestureDetector(
                              onTap: (){
                                var name = showingItems[index]!;
                                var itemIndex = items.value.indexOf(name);
                                items[itemIndex] = "${items[itemIndex]}a";
                                // items.notifyAll();
                              },
                              child: Text(
                              "${index+1}. ${showingItems[index]} (len:${showingItems[index]!.length})",
                              style: const TextStyle(fontSize: 40),
                            ),
                            )
                        );
                      })
                  ),
                  FloatingActionButton(
                      onPressed: (){ items.add(randomText()); },
                      child: const Text("Add"))
                ],
              ),
            )
        )
    );

  }
  final _chars = 'abcdefg';
  String randomText() => String.fromCharCodes(Iterable.generate(
      5, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))
  ));
}