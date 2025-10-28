import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Telescope<int> counter = Telescope<int>(0);
  final TelescopeList<String> items = TelescopeList<String>([]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telescope Demo',
      home: TelescopeProvider(
        telescopes: {
          'counter': counter,
          'items': items,
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Telescope Example')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ---- Counter Section ----
                TelescopeSelector<int>(
                  keyName: 'counter',
                  builder: (context, value) {
                    print('Counter rebuilt');
                    return Text(
                      'Counter value: $value',
                      style: const TextStyle(fontSize: 24),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => counter.value++,
                      child: const Text('Increment'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => counter.value--,
                      child: const Text('Decrement'),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 2),
                // ---- List Section ----
                Expanded(
                  child: TelescopeSelector<List<String>>(
                    keyName: 'items',
                    builder: (context, list) {
                      print('List rebuilt');
                      if (list.isEmpty) {
                        return const Center(child: Text('No items yet'));
                      }
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                items.removeAt(index);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Add item',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            items.add(text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
