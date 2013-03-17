var RocketIO = function(){
  new EventEmitter().apply(this);
  this.type = null; // "comet", "websocket"
  this.session = null;
  this.io = null;
  var self = this;
  var ws_close_timer = null;

  this.connect = function(){
    self.io = function(){
      if(self.type === "comet") return;
      if(typeof WebSocketIO === "undefined") return;
      var io = new WebSocketIO();
      io.session = self.session;
      return io.connect();
    }() || function(){
      if(typeof CometIO === "undefined") return;
      var io = new CometIO();
      io.session = self.session;
      return io.connect();
    }();
    if(self.io.url.match(/^ws:\/\/.+/)) self.type = "websocket";
    else if(self.io.url.match(/cometio/)) self.type = "comet";
    else self.type = "unknown";
    self.io.on("*", function(event_name, args){
      self.emit(event_name, args);
    });
    self.io.on("connect", function(session_id){
      self.session = session_id;
    });
    ws_close_timer = setTimeout(function(){
      self.close();
      self.type = "comet";
      self.connect();
    }, 3000);
    return self;
  };

  self.on("connect", function(){
    clearTimeout(ws_close_timer);
  });

  this.close = function(){
    self.io.close();
  };

  this.push = function(type, data){
    self.io.push(type, data);
  };
};
