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
      bool isDuplicate = provider.contacts
          .any((c) => c.phone == cleanedPhone && c.id != contact?.id);
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
      String cleanedPhone = phoneController.text.replaceAll(RegExp(r'\D'), '');

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(contact != null ? 'Edit Contact' : 'Add Contact'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.person_add,
                              size: 80, color: Colors.blueAccent),
                          const SizedBox(height: 16),
                          Text(
                            contact == null
                                ? 'Create New Contact'
                                : 'Update Contact',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter full name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => saveContact(context),
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlue,
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: Text(
                              contact == null ? 'Add Contact' : 'Save Changes',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}