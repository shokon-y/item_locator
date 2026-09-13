import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 保存するデータの構造
class Item {
  final String name;
  final String location;
  final DateTime date;

  Item({
    required this.name,
    required this.location,
    required this.date,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '物置き場所管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ItemTrackerPage(),
    );
  }
}

class ItemTrackerPage extends StatefulWidget {
  const ItemTrackerPage({super.key});

  @override
  State<ItemTrackerPage> createState() => _ItemTrackerPageState();
}

class _ItemTrackerPageState extends State<ItemTrackerPage> {
  // 入力を読み取るコントローラー
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // 保存した物のリスト
  final List<Item> _items = [];

  // 保存処理
  void _addItem() {
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || location.isEmpty) return;

    setState(() {
      _items.insert(
        0,
        Item(
          name: name,
          location: location,
          date: DateTime.now(),
        ),
      );
    });

    // 入力欄をクリア
    _nameController.clear();
    _locationController.clear();

    // キーボードを閉じる
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('物置き場所管理'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 入力フォーム
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '物の名前',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '保管場所',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('保存する'),
              ),
            ),
            const SizedBox(height: 24),

            // 一覧表示エリア
            Expanded(
              child: _items.isEmpty
                  ? const Center(
                child: Text(
                  'まだ登録された物がありません',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final formattedDate =
                      '${item.date.month}/${item.date.day} ${item.date.hour}:${item.date.minute.toString().padLeft(2, '0')}';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.inventory_2),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('場所: ${item.location}'),
                      trailing: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}