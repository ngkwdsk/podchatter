import consumer from "./consumer"

if(location.pathname.match(/\/podcasts\/\d/)){

  consumer.subscriptions.create({
    channel: "CommentChannel",
    podcast_id: location.pathname.match(/\d+/)[0]
  }, {

    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const html = `
        <div class="chat">
      <img src="${data.icon_url}" />
      <div class="chat-content">
        <div>
          <span class="name">${data.user.nickname}</span>
          <span class="time">${data.created_at}</span>
        </div>
        <div class="text">${data.comment.text}</div>
      </div>
    </div>`;
      const comments = document.getElementById("comments")
      comments.insertAdjacentHTML('beforeend', html)
      const commentForm = document.getElementById("comment-form")
      commentForm.reset();
    }
  })
}
