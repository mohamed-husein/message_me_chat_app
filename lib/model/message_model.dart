class MessageModel {
  final String senderId;
  final String recieverId;
  final String textMessage;
  final String dateMessage;
  final String email;

  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.textMessage,
    required this.dateMessage,
    required this.email,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'],
      recieverId: json['reciever_id'],
      textMessage: json['text_message'],
      dateMessage: json['date_message'],
      email: json['email'],
    );
  }
}
