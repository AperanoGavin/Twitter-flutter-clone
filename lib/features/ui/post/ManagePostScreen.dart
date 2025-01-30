import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix/features/blocs/post/PostBloc.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/core/model/post/post.dart';

class ManagePostScreen extends StatefulWidget {
  final Post? post;

  ManagePostScreen({this.post});

  @override
  _ManagePostScreenState createState() => _ManagePostScreenState();
}

class _ManagePostScreenState extends State<ManagePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _contentController.text = widget.post!.content;
      _imageUrlController.text = widget.post!.imageUrl ?? '';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.post == null) {
        // Create new post
        context.read<PostBloc>().add(CreatePost(
          postCreate: PostCreate(
            content: _contentController.text,
            imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
          ),
        ));
      } else {
        // Update existing post
        context.read<PostBloc>().add(UpdatePost(
          postId: widget.post!.id,
          postCreate: PostCreate(
            content: _contentController.text,
            imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
          ),
        ));
      }
      Navigator.pop(context, true); // Pass a result back to the previous screen
    }
  }

  void _delete() {
    if (widget.post != null) {
      context.read<PostBloc>().add(DeletePost(postId: widget.post!.id));
      Navigator.pop(context, true); // Pass a result back to the previous screen
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0), // Adjust the value as needed
          child: AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this post?'),
            backgroundColor: const Color.fromARGB(255, 12, 11, 11),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _delete(); // Delete the post
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Update Post'),
        backgroundColor: Colors.black,
        actions: widget.post != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _showDeleteConfirmationDialog,
                ),
              ]
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildContentField(),
                  SizedBox(height: 16),
                  _buildImageUrlField(),
                  SizedBox(height: 24),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextFormField(
      controller: _contentController,
      decoration: InputDecoration(
        labelText: 'Content',
        prefixIcon: Icon(Icons.text_fields, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter content' : null,
    );
  }

  /* Widget _buildImageUrlField() {
    return TextFormField(
      controller: _imageUrlController,
      decoration: InputDecoration(
        labelText: 'Image URL',
        prefixIcon: Icon(Icons.image, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          final uri = Uri.tryParse(value);
          if (uri == null || !uri.hasAbsolutePath) {
            return 'Please enter a valid URL';
          }
        }
        return null;
      },
    );
  } */

   Widget _buildImageUrlField() {
    return TextFormField(
      controller: _imageUrlController,
      decoration: InputDecoration(
        labelText: 'Avatar URL',
        prefixIcon: Icon(Icons.image, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        widget.post == null ? 'Create' : 'Update',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}