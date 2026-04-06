<script>
(function () {
  function retypeset() {
    if (window.MathJax && MathJax.typesetPromise) {
      MathJax.typesetPromise();
    }
  }
  // When the visible slide changes
  document.addEventListener('slidechanged', retypeset);
  // When device is rotated or viewport resized
  window.addEventListener('orientationchange', retypeset);
  window.addEventListener('resize', retypeset);
  // Also retypeset once on load (helps with fragments)
  document.addEventListener('DOMContentLoaded', retypeset);
})();
</script>

