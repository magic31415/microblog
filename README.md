# microblog

http://microblog.cs4550max.xyz
https://github.com/magic31415/cs4550

Logging in allows you to post messages, edit and delete your messages, and follow other people. Without logging in you can only view messages and users.

Users can post messages as well as edit and delete their own messages. Everyone can see every message by going to the messages index page. You can also see a message by going to the show page for that message, although this page will likely be removed before the app is complete.

Users can visit another user's page and hit a button to follow that user. You can follow a user multiple times, but cannot follow yourself. You can also unfollow a user by clicking the button next to their name in the list of your followers. You cannot make anyone follow or unfollow you. Before the app is complete, users will only be able to follow someone once and you will only see messages of people you follow.

# LIKES: Users that are logged in can like messages. By clicking "View Message" next to a message, you are brought to the show page for that message. On this page, you can click the "Like" button to like a message. Once you like a message, the button will go away. There is currently no way to unlike a message. On this show page, you will see who liked the message The list of people who have liked the message is rendered via JavaScript. This information is also available on the index page, but since there is no way to like a message from the index page yet, this will not be changing in real time, so this information is rendered on the server.
