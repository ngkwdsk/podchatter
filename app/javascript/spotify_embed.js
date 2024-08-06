document.addEventListener('DOMContentLoaded', () => {
  window.onSpotifyIframeApiReady = (IFrameAPI) => {
  const element = document.getElementById('embed-iframe');
  const options = {
    width: '100%',
    height: '100',
    allow: 'encrypted-media; autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture'
  };

  const callback = (EmbedController) => {
    document.querySelectorAll('.episode').forEach(episode => {
      episode.addEventListener('click', () => {
        EmbedController.loadUri(episode.dataset.spotifyId);
      });
    });
  };

  IFrameAPI.createController(element, options, callback);
};
});