var RocketIO = function(opts){
  new EventEmitter().apply(this);
  this.type = null; // "comet", "websocket"
  this.session = null;
  this.channel = null;
  this.io = null;
  var self = this;
  var ws_close_timer = null;
  if(typeof opts === "object"){
    this.channel = ""+opts.channel;
  }
  self.on("__connect", function(session_id){
    self.session = session_id;
    self.io.push("__channel_id", self.channel);
    self.emit("connect");
  });

  this.connect = function(){
    self.io = function(){
      if(self.type === "comet") return;
      if(typeof WebSocketIO !== "function") return;
      var io = new WebSocketIO();
      io.session = self.session;
      return io.connect();
    }() || function(){
      if(typeof CometIO !== "function") return;
      var io = new CometIO();
      io.session = self.session;
      return io.connect();
    }();
    if(typeof self.io === "undefined"){
      setTimeout(function(){
        self.emit("error", "WebSocketIO and CometIO are not available");
      }, 100);
      return self;
    };
    if(self.io.url.match(/^ws:\/\/.+/)) self.type = "websocket";
    else if(self.io.url.match(/cometio/)) self.type = "comet";
    else self.type = "unknown";
    self.io.on("*", function(event_name, args){
      if(event_name === "connect") event_name = "__connect";
      self.emit(event_name, args);
    });
    ws_close_timer = setTimeout(function(){
      self.close();
      self.type = "comet";
      self.connect();
    }, 3000);
    self.once("connect", function(){
      if(ws_close_timer) clearTimeout(ws_close_timer);
      ws_close_timer = null;
    });
    return self;
  };

  this.close = function(){
    self.io.close();
  };

  this.push = function(type, data){
    self.io.push(type, data);
  };
};
