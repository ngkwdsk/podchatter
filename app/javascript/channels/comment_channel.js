import consumer from "./consumer"

if(location.pathname.match(/\/podcasts\/\d/)){

  consumer.subscriptions.create({
    channel: "CommentChannel",
    podcast_id: location.pathname.match(/\d+/)[0]
  }, {

    connected() {
    },

    disconnected() {
    },

    received(data) {
      const html = `
        <div class="slack-message">
          <div class="slack-message-avatar">
            <img src="${data.icon_url}" alt="ユーザーアイコン">
          </div>
          <div class="slack-message-content">
            <div class="slack-message-header">
              <span class="slack-message-name">${data.user.nickname}</span>
              <span class="slack-message-time">${data.created_at}</span>
            </div>
            <div class="slack-message-text">${data.comment.text}</div>
          </div>
        </div>`;
      const comments = document.getElementById("comments")
      comments.insertAdjacentHTML('beforeend', html)
      const commentForm = document.getElementById("comment-form")
      commentForm.reset();

      comments.scrollTop = comments.scrollHeight;
    }
  })
}