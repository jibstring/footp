class Msg {
  var eventId = 0;
  var userId = 0;
  String chat = "";
  String userNickName = "";
  String now = "";

  Msg(this.eventId,this.userId, this.chat, this.userNickName, this.now);

  Msg.fromJson(Map<String, dynamic> json) 
    : eventId = json['eventId'],
      userId = json['userId'],
      chat = json['chat'],
      userNickName = json['userNickName'],
      now = json['now']
  ;

  Map<String, dynamic> toJson() => {
    'eventId' : eventId,
    'userId' : userId,
    'chat' : chat,
    'userNickName' : userNickName,
    'now' : now
  };
}