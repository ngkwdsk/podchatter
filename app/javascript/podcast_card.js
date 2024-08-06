function adjustDescriptions() {
  const cards = document.querySelectorAll('#podcast-cards .card');
  let maxCardHeight = 0;

  cards.forEach(card => {
    const height = card.offsetHeight;
    if (height > maxCardHeight) {
      maxCardHeight = height;
    }
  });

  cards.forEach(card => {
    const description = card.querySelector('.description-text');
    
    if (!description) return;

    const fullText = description.dataset.fullText;
    description.textContent = fullText;

    const lineHeight = parseInt(window.getComputedStyle(description).lineHeight);
    const maxHeight = lineHeight * 2;

    while (description.offsetHeight > maxHeight && description.textContent.length > 0) {
      description.textContent = description.textContent.slice(0, -1);
    }

    if (description.textContent !== fullText) {
      description.textContent = description.textContent.slice(0, -3) + '...';
    }

    card.style.height = `${maxCardHeight}px`;
  });
}
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

const debouncedAdjustDescriptions = debounce(adjustDescriptions, 250);

window.addEventListener('resize', debouncedAdjustDescriptions);
document.addEventListener('turbo:load', adjustDescriptions);

export { adjustDescriptions };