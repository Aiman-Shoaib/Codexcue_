import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/Models/Note.dart';
import 'package:to_do/Note_Notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return NoteNotifier();
          },
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<NoteNotifier>(
              builder: (context, noteNotifier, _) {
                return ListView.builder(
                  itemCount: noteNotifier.getNotes.length,
                  itemBuilder: (context, index) {
                    Note note = noteNotifier.getNotes[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(note.content),
                        onTap: () {
                          // Implement navigation to note detail screen
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            noteNotifier.removeNote(index);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(labelText: 'Content'),
                      maxLines: 3,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Note note = Note(
                        title: titleController.text,
                        content: contentController.text,
                      );
                      Provider.of<NoteNotifier>(context, listen: false)
                          .addNote(note);
                      // Clear the text fields
                      titleController.clear();
                      contentController.clear();

                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
