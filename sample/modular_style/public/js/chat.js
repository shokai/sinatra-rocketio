var io = new RocketIO({channel: channel}).connect();

$(function(){
  $("#chat #btn_send").click(post);
  $("#chat #message").keydown(function(e){
    if(e.keyCode == 13) post();
  });
});

io.on("chat", function(data){
  var m = $("<li>").text(data.name + " : " +data.message);
  $("#chat #timeline").prepend(m);
});

io.on("connect", function(){
  console.log("connect!! "+io.session);
  $("#type").text("type : "+io.type);
});

io.on("disconnect", function(){
  console.log("disconnect!!");
});

io.on("*", function(event, data){ // catch all events
  console.log(event + " - " + JSON.stringify(data));
});

io.on("error", function(err){
  console.error(err);
});

var post = function(){
  var name = $("#chat #name").val();
  var message = $("#chat #message").val();
  if(message.length < 1) return;
  io.push("chat", {name: name, message: message});
  $("#chat #message").val("");
};
