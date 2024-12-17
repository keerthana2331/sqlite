import 'package:flutter/material.dart';
import 'package:sqlite/helper.dart';
import 'contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [];

  List<Contact> get contactss => contacts;

  bool? get isContactsLoaded => null;

  Future<void> initDb() async {
    contacts = await DbHelper.instance.getContacts();
    notifyListeners();
  }

  void addContact(Contact contact) {
    DbHelper.instance.addContact(contact);
    contacts.add(contact);
    notifyListeners();
  }

  void updateContact(Contact contact) {
    DbHelper.instance.updateContact(contact);
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      notifyListeners();
    }
  }

  void deleteContact(int id) {
    DbHelper.instance.deleteContact(id);
    contacts.removeWhere((contact) => contact.id == id);
    notifyListeners();
  }

  bool phoneExists(String phone, int? excludeId) {
    return contacts
        .any((contact) => contact.phone == phone && contact.id != excludeId);
  }
}
