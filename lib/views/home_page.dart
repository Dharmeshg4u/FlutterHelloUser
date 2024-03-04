import 'package:flutter/material.dart';
import 'package:flutter_hello_user/utils/routes.dart';
import 'package:flutter_hello_user/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../viewmodels/book_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  String? error;

  final _addBookFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<List<Book>>(
          stream: Provider.of<BookViewModel>(context, listen: true)
              .getBooksStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final books = snapshot.data ?? [];
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteBookDialog(context, book.id);
                        },
                      ),
                      // Add onTap functionality here if needed
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteBookDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Book"),
          content: const Text("Are you sure you want to delete book?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<BookViewModel>(context, listen: false)
                    .deleteBook(id)
                    .then((value) => {Navigator.of(context).pop()});
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Add functionality to logout
                Provider.of<AuthViewModel>(context, listen: false)
                    .signOut()
                    .then((value) => {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoute.loginRoute,
                              (Route<dynamic> route) => false)
                        });
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _showAddBookDialog(BuildContext context) {
    String title = '';
    String author = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Book'),
          content: Form(
            key: _addBookFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) => title = value,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Author'),
                  onChanged: (value) => author = value,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_addBookFormKey.currentState != null &&
                    _addBookFormKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  Provider.of<BookViewModel>(context, listen: false)
                      .addBook(Book(title: title, author: author, id: ''))
                      .then((value) => {Navigator.of(context).pop()})
                      .catchError((error) {
                    //display error
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
