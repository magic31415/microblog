import socket from "./socket";

var chan;

function message_init() {
	chan = socket.channel("updates:all");
	chan.on("message", got_message);
  // $('#post-msg-btn').click(send_message);
  
  if ($('body').data('page') == "MessageView/index") {
		console.log("this is the messages index");
	}
}

$(message_init)

// function join_channel() {
// 	chan.join()
//     .receive("ok", resp => { console.log("Joined successfully", resp); })
//     .receive("error", resp => { console.log("Unable to join", resp); });
// }

// function send_message(evt) {
// 	chan.push("message", {content: content})
// 	  .receive("ok", got_message_response);
// 	console.log("Send Message");
// }

function got_message(msg) {
  console.log("Got Message");
}

function got_message_response(msg) {
  console.log("Got Message Response");
}
