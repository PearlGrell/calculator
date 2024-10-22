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
      ),
      body: history.isNotEmpty
          ? ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                var item = history[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onLongPress: (){
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
                      subtitle: Text(item['output'],style: Theme.of(context).textTheme.headlineMedium,),
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
