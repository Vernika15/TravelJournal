class Profile {
  String? firstName;
  String? lastName;
  String? address;
  String? email;

  Profile({
    this.firstName,
    this.lastName,
    this.address,
    this.email,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (firstName != null) {
      map['firstName'] = firstName;
    }
    if (lastName != null) {
      map['lastName'] = lastName;
    }
    if (address != null) {
      map['address'] = address;
    }
    if (email != null) {
      map['email'] = email;
    }
    return map;
  }
}
