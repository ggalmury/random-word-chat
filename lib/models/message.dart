class Message {
  final bool sender;
  final dynamic message;

  Message({required this.sender, required this.message});

  factory Message.init(bool sender, dynamic message) {
    return Message(sender: sender, message: message);
  }
}
