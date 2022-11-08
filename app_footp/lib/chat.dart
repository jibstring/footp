class Chat {
  var userId = 0;
  String msg = "";
  String userNickName = "";
  String time = "";

  Chat(var i, String m, String u, String t) {
    userId = i;
    msg = m;
    userNickName = u;
    time = t;
  }

  Chat getChat() {
    return this;
  }
}