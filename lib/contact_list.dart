import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'contact_provider.dart';
import 'contact_model.dart';

class EditContactScreen extends StatelessWidget {
  final Contact? contact;

  const EditContactScreen({Key? key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    String? validatePhoneNumber(BuildContext context, String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a phone number';
      }

      String cleanedPhone = value.replaceAll(RegExp(r'\D'), '');
      if (cleanedPhone.length != 10) {
        return 'Phone number must be 10 digits';
      }

      final provider = Provider.of<ContactProvider>(context, listen: false);
      bool isDuplicate = provider.contacts.any((c) =>
          c.phone == cleanedPhone && c.id != contact?.id);
      if (isDuplicate) return 'This phone number is already in use';

      return null;
    }

    void saveContact(BuildContext context) {
      if (nameController.text.trim().isEmpty ||
          validatePhoneNumber(context, phoneController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please correct the errors'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      final provider = Provider.of<ContactProvider>(context, listen: false);
      String cleanedPhone =
          phoneController.text.replaceAll(RegExp(r'\D'), '');

      final newContact = Contact(
        id: contact?.id,
        name: nameController.text.trim(),
        phone: cleanedPhone,
      );

      if (contact == null) {
        provider.addContact(newContact);
      } else {
        provider.updateContact(newContact);
      }

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(contact != null ? 'Edit Contact' : 'Add Contact'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        contact == null
                            ? 'Create New Contact'
                            : 'Update Contact',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter full name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter 10-digit phone number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => saveContact(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          contact == null ? 'Add Contact' : 'Save Changes',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
