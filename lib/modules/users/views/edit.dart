import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserEdit extends GetView<UsersController> {
  UserEdit({super.key});
  
  final _formKey = GlobalKey<FormState>();  
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _avatarController = TextEditingController();

  // State variables using GetX reactive state

  @override
  Widget build(BuildContext context) {
    final User item = Get.arguments;

    // Initialize controllers and state with existing values
    _nameController.text = item.name?.toString() ?? '';
    _emailController.text = item.email?.toString() ?? '';
    _usernameController.text = item.username?.toString() ?? '';
    _avatarController.text = item.avatar?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarController,
                decoration: const InputDecoration(labelText: 'Avatar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter avatar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final Map<String, dynamic> data = {
                      'Name':_nameController.text,
                      'Email':_emailController.text,
                      'Username':_usernameController.text,
                      'Avatar':_avatarController.text,
                    };
                    
                    controller.updateUser(item.id, data);
                  }
                },
                child: const Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}