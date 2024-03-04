import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookViewModel extends ChangeNotifier {
  final CollectionReference booksCollection =
  FirebaseFirestore.instance.collection('Books');

  Stream<List<Book>> getBooksStream() {
    return booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Book(
          id: doc.id,
          title: data['Title'] ?? '',
          author: data['Author'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addBook(Book book) async {
    await booksCollection.add({
      'Title': book.title,
      'Author': book.author,
    });
    notifyListeners(); // Notify listeners after adding a book
  }

  Future<void> deleteBook(String bookId) async {
    await booksCollection.doc(bookId).delete();
    notifyListeners(); // Notify listeners after deleting a book
  }
}