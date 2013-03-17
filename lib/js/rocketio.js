var RocketIO = function(opts){
  new EventEmitter().apply(this);
  this.type = null; // comet, websocket
  this.__defineGetter__("session", function(){
    return self.io.session;
  });
  this.io = null;
  var self = this;

  this.connect = function(){
    self.io = new WebSocketIO().connect() || new CometIO().connect();
    if(self.io.url.match(/^ws:\/\/.+/)) self.type = "websocket";
    else if(self.io.url.match(/cometio/)) self.type = "comet";
    else self.type = "unknown";
    self.io.on("*", function(event_name, args){
      self.emit(event_name, args);
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
