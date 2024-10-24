import 'package:calculator/provider/history_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Clear History"),
                    content: const Text(
                        "Do you really want to clear all the history?"),
                    actions: [
                      ActionChip(
                        label: const Text("Yes"),
                        onPressed: () async {
                          await HistoryDatabase.instance.deleteHistory().then(
                            (value) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("History Cleared"),
                                ),
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      ActionChip(
                        label: const Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
        ],
      ),
      body: history.isNotEmpty
          ? ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                var item = history[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onLongPress: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: "${item['output']}",
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied to clipboard!"),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(item['input']),
                      subtitle: Text(
                        item['output'],
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      trailing: Text(item['date']),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No history available'),
            ),
    );
  }
}
