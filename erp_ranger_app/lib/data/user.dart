
class User {

  String uid;

  String name;

  String number;

  String dob;

  constructor(String _uid) {
    if (uid != null) {
      this.uid = uid;
      getUserDetails();
    }
  }

  void getUserDetails() {
    //contact server and get user name, number and dob
  }

}