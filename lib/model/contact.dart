  class Contact {
  String contactUid;
  String dateTime;
  bool positive;

  Contact({ this.contactUid, this.dateTime, this.positive });
  
  static bool contains(List<Contact> list, Contact searchEl) {
    for (Contact doc in list) {
      if (doc.contactUid == searchEl.contactUid && doc.dateTime == searchEl.dateTime) {
        return true;
      }
    }
    return false;
  }
}