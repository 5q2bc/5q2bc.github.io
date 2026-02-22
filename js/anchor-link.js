// Zola heading anchor ヘッダ全体クリックでアンカー付きURLをコピー
document.addEventListener('DOMContentLoaded', function() {
  function copyAnchorLink(e) {
    const heading = e.target.closest('h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]');
    if (!heading) return;
    const id = heading.id;
    if (!id) return;
    const url = location.origin + location.pathname + '#' + id;
    if (navigator.clipboard) {
      navigator.clipboard.writeText(url);
    }
    // URLを履歴にpush（オプション）
    if (history && history.replaceState) {
      history.replaceState(null, '', '#' + id);
    }
  }
  document.body.addEventListener('click', function(e) {
    if (e.target instanceof HTMLElement && e.target.matches('h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]')) {
      copyAnchorLink(e);
    }
  });
});
