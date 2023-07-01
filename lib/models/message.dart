class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    required this.value,
  });

  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  late final String value;


  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    data['value'] = value;
    return data;
  }
}

enum Type { text, image }
