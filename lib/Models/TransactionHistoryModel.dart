class TransactionHistoryModel {
  String? id;
  int? userId;
  String? type;
  String? date;
  String? bank;
  String? acNumber;
  String? acTitle;
  String? amount;
  int? balance;
  var remark;
  String? status;
  String? createdAt;
  String? updatedAt;

  TransactionHistoryModel(
  {this.id,
  this.userId,
  this.type,
  this.date,
  this.bank,
  this.acNumber,
  this.acTitle,
  this.amount,
  this.balance,
  this.remark,
  this.status,
  this.createdAt,
  this.updatedAt});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  userId = json['user_id'];
  type = json['type'];
  date = json['date'];
  bank = json['bank'];
  acNumber = json['ac_number'];
  acTitle = json['ac_title'];
  amount = json['amount'];
  balance = json['balance'];
  remark = json['remark'];
  status = json['status'];
  createdAt = json['created_at'];
  updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['user_id'] = this.userId;
  data['type'] = this.type;
  data['date'] = this.date;
  data['bank'] = this.bank;
  data['ac_number'] = this.acNumber;
  data['ac_title'] = this.acTitle;
  data['amount'] = this.amount;
  data['balance'] = this.balance;
  data['remark'] = this.remark;
  data['status'] = this.status;
  data['created_at'] = this.createdAt;
  data['updated_at'] = this.updatedAt;
  return data;
  }
  }