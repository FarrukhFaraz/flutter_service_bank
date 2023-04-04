class BankName {
  String? id;
  String? name;
  String? acTitle;
  String? acNumber;
  String? iconName;
  int? status;
  int? limits;
  var currentAmount;
  String? image;
  bool value = false;

  BankName(
  {this.id,
  this.name,
  this.acTitle,
  this.acNumber,
  this.iconName,
  this.status,
  this.limits,
  this.currentAmount,
  this.image});

  BankName.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  acTitle = json['ac_title'];
  acNumber = json['ac_number'];
  iconName = json['icon_name'];
  status = json['status'];
  limits = json['limits'];
  currentAmount = json['current_amount'];
  image = json['image'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['ac_title'] = this.acTitle;
  data['ac_number'] = this.acNumber;
  data['icon_name'] = this.iconName;
  data['status'] = this.status;
  data['limits'] = this.limits;
  data['current_amount'] = this.currentAmount;
  data['image'] = this.image;
  return data;
  }
  }