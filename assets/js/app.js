// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// From lecture notes
let handlebars = require("handlebars");

$(function() {
  if (!$("#likes-template").length > 0) {
    // Wrong page.
    return;
  }

  let tt = $($("#likes-template")[0]);
  let code = tt.html();
  let tmpl = handlebars.compile(code);

  let dd = $($("#message-likes")[0]);
  let path = dd.data('path');
  let m_id = dd.data('message_id');

  let bb = $($("#like-button")[0]);
  let ulb = $($("#unlike-button")[0]);

  let u_id = (bb == null) ? ulb.data('user-id') : bb.data('user-id')

  function fetch_likes() {
    function got_likes(data) {
      console.log(data);
      let html = tmpl(data);
      dd.html(html);
    }

    $.ajax({
      url: path,
      data: {message_id: m_id},
      contentType: "application/json",
      dataType: "json",
      method: "GET",
      success: got_likes,
    });
  }

  function add_like() {
    let data = {like: {message_id: m_id, user_id: u_id}};

    $.ajax({
      url: path,
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json",
      method: "POST",
      success: fetch_likes,
    });

    $("#like-button").remove();
  }

  // function remove_like() {
  //   let data = {like: {message_id: m_id, user_id: u_id}};

  //   $.ajax({
  //     url: path,
  //     data: JSON.stringify(data),
  //     contentType: "application/json",
  //     dataType: "json",
  //     method: "De",
  //     success: fetch_likes,
  //   });
  // }

  bb.click(add_like);
  // ulb.click(remove_like);

  fetch_likes();
});
