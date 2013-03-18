// event_emitter.js v0.0.7
// https://github.com/shokai/event_emitter.js
// (c) 2013 Sho Hashimoto <hashimoto@shokai.org>
// The MIT License
var EventEmitter = function(){
  var self = this;
  this.apply = function(target, prefix){
    if(!prefix) prefix = "";
    for(var func in self){
      if(self.hasOwnProperty(func) && func !== "apply"){
        target[prefix+func] = this[func];
      }
    }
  };
  this.__events = new Array();
  this.on = function(type, listener, opts){
    if(typeof listener !== "function") return;
    var event_id = self.__events.length > 0 ? 1 + self.__events[self.__events.length-1].id : 0
    var params = {
      id: event_id,
      type: type,
      listener: listener
    };
    for(i in opts){
      if(!params[i]) params[i] = opts[i];
    };
    self.__events.push(params);
    return event_id;
  };

  this.once = function(type, listener){
    self.on(type, listener, {once: true});
  };

  this.emit = function(type, data){
    for(var i = 0; i < self.__events.length; i++){
      var e = self.__events[i];
      switch(e.type){
      case type:
        e.listener(data);
        break
      case '*':
        e.listener(type, data);
        break
      }
      if(e.once) self.removeListener(e.id);
    }
  };

  this.removeListener = function(id_or_type){
    for(var i = self.__events.length-1; i >= 0; i--){
      var e = self.__events[i];
      switch(typeof id_or_type){
      case "number":
        if(e.id == id_or_type) self.__events.splice(i,1);
        break
      case "string":
        if(e.type == id_or_type) self.__events.splice(i,1);
        break
      }
    }
  };

};

if(typeof module !== 'undefined' && typeof module.exports !== 'undefined'){
  module.exports = EventEmitter;
}
