import 'package:flutter/material.dart';
import 'package:to_do/Models/Note.dart';

class NoteNotifier with ChangeNotifier {
  List<Note> noteList = [];

  List<Note> get getNotes => noteList;

  void addNote(Note note) {
    noteList.add(note);
    notifyListeners();
  }

  void removeNote(int index) {
    noteList.removeAt(index);
    notifyListeners();
  }
}
