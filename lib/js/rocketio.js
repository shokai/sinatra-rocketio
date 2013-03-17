var RocketIO = function(opts){
  new EventEmitter().apply(this);
  this.type = null; // comet, websocket
  this.session = null;
  this.io = null;
  var self = this;

  this.connect = function(){
    self.io = function(){
      var io = new WebSocketIO();
      io.session = self.session;
      return io.connect();
    }() || function(){
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
    return self;
  };

  this.close = function(){
    self.io.close();
  };

  this.push = function(type, data){
    self.io.push(type, data);
  };
};
