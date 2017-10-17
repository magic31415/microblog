import socket from "./socket";

var chan;

function message_init() {
	chan = socket.channel("updates:all");

	chan.join()
    .receive("ok", resp => { console.log("Joined successfully", resp); })
    .receive("error", resp => { console.log("Unable to join", resp); });

	chan.on("message", got_message);
  
  // From class notes
  if ($('body').data('page') != "MessageView/index") {
		return;
	}
}

$(message_init)

function got_message(msg) {
	$('#new-messages').prepend(' \
		<div class="media row mb-3 pb-5 pl-3"> \
			<img class="profile-picture" src="/images/northeastern-logo.jpg"> \
			<span class="message-text ml-3"> \
	  		<a href="/users/' + msg.user_id + '">' + msg.user_name + '</a> \
	  		<div>' + msg.content + '</div> \
	  		<a class="btn btn-primary" href="/messages/' + msg.id + '">View Message</a> \
			</span> \
		</div>'
		); 
}