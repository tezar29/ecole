(() => {
  const button = document.querySelector('.menu-toggle');
  const nav = document.querySelector('#navigation-principale');
  if (!button || !nav) return;

  const closeMenu = () => {
    button.setAttribute('aria-expanded', 'false');
    button.setAttribute('aria-label', 'Ouvrir le menu');
    nav.classList.remove('is-open');
  };

  button.addEventListener('click', () => {
    const isOpen = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', String(!isOpen));
    button.setAttribute('aria-label', isOpen ? 'Ouvrir le menu' : 'Fermer le menu');
    nav.classList.toggle('is-open', !isOpen);
  });

  nav.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeMenu));
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') closeMenu();
  });
})();
