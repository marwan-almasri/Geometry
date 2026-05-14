(function () {
  'use strict';

  // =========================================================================
  // Starfield canvas
  // =========================================================================

  var canvas = document.getElementById('space-canvas');
  if (!canvas) return;

  var ctx = canvas.getContext('2d');
  var mouse = { x: -9999, y: -9999 };
  var stars = [];
  var tick = 0;
  var raf;

  function resize() {
    canvas.width  = window.innerWidth;
    canvas.height = window.innerHeight;
    buildStars();
  }

  function rnd(min, max) {
    return min + Math.random() * (max - min);
  }

  function buildStars() {
    var density = 5500;
    var count = Math.min(320, Math.floor((canvas.width * canvas.height) / density));
    stars = [];
    for (var i = 0; i < count; i++) {
      // Three rough "layers" — far, mid, close — for depth
      var layer = Math.floor(Math.random() * 3);
      var r = layer === 0 ? rnd(0.2, 0.6)
            : layer === 1 ? rnd(0.5, 1.1)
            :                rnd(0.9, 1.8);
      var baseOpacity = layer === 0 ? rnd(0.15, 0.45)
                      : layer === 1 ? rnd(0.35, 0.65)
                      :               rnd(0.55, 0.9);
      // Mostly cool-white/blue; small fraction warm
      var hue = Math.random() < 0.88 ? rnd(200, 240) : rnd(30, 50);
      stars.push({
        x: rnd(0, canvas.width),
        y: rnd(0, canvas.height),
        r: r,
        vx: rnd(-0.08, 0.08),
        vy: rnd(-0.08, 0.08),
        baseOpacity: baseOpacity,
        twinkleSpeed: rnd(0.004, 0.018),
        twinkleOffset: rnd(0, Math.PI * 2),
        hue: hue,
        layer: layer,
      });
    }
  }

  function drawStars() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    tick++;

    for (var i = 0; i < stars.length; i++) {
      var s = stars[i];

      // Twinkle
      var tw = Math.sin(tick * s.twinkleSpeed + s.twinkleOffset) * 0.22;
      var opacity = Math.max(0, Math.min(1, s.baseOpacity + tw));

      // Mouse gravity — close stars pulled gently toward cursor
      var dx = mouse.x - s.x;
      var dy = mouse.y - s.y;
      var dist2 = dx * dx + dy * dy;
      var pullRadius = 180 + s.layer * 40;
      if (dist2 < pullRadius * pullRadius) {
        var dist = Math.sqrt(dist2);
        var strength = ((pullRadius - dist) / pullRadius) * 0.006 * (s.layer + 1);
        s.vx += (dx / dist) * strength;
        s.vy += (dy / dist) * strength;
      }

      // Friction damps velocity back to near-zero
      s.vx *= 0.975;
      s.vy *= 0.975;

      s.x += s.vx;
      s.y += s.vy;

      // Wrap edges
      if (s.x < 0)            s.x += canvas.width;
      if (s.x > canvas.width) s.x -= canvas.width;
      if (s.y < 0)            s.y += canvas.height;
      if (s.y > canvas.height) s.y -= canvas.height;

      // Draw core
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
      ctx.fillStyle = 'hsla(' + s.hue + ', 80%, 92%, ' + opacity + ')';
      ctx.fill();

      // Soft glow halo for brighter stars
      if (s.r > 0.9 && opacity > 0.4) {
        ctx.beginPath();
        ctx.arc(s.x, s.y, s.r * 2.8, 0, Math.PI * 2);
        ctx.fillStyle = 'hsla(' + s.hue + ', 80%, 92%, ' + (opacity * 0.12) + ')';
        ctx.fill();
      }
    }

    raf = requestAnimationFrame(drawStars);
  }


  // =========================================================================
  // Nebula parallax on scroll
  // =========================================================================

  var blobs = [];

  function initNebulas() {
    var els = document.querySelectorAll('.nebula-blob');
    for (var i = 0; i < els.length; i++) {
      var el = els[i];
      var speeds = [0.04, 0.07, 0.03, 0.06];
      var targetOpacities = [0.65, 0.55, 0.50, 0.60];
      blobs.push({
        el: el,
        speed: speeds[i] || 0.05,
        targetOpacity: targetOpacities[i] || 0.5,
      });
    }

    // Reveal nebulas after brief paint delay
    setTimeout(function () {
      for (var j = 0; j < blobs.length; j++) {
        blobs[j].el.style.opacity = blobs[j].targetOpacity;
      }
    }, 400);
  }

  function updateNebulas() {
    var sy = window.scrollY;
    for (var i = 0; i < blobs.length; i++) {
      var b = blobs[i];
      var shift = -(sy * b.speed);
      b.el.style.transform = b.el.style.transform
        ? b.el.style.transform.replace(/translateY\([^)]+\)/, 'translateY(' + shift + 'px)')
        : b.el.style.transform = 'translateY(' + shift + 'px)';
    }
  }

  // blob-3 uses translateX(-50%) from CSS; keep that when shifting Y
  function patchBlob3() {
    var b3 = document.querySelector('.nebula-blob-3');
    if (!b3) return;
    for (var i = 0; i < blobs.length; i++) {
      if (blobs[i].el === b3) {
        blobs[i].scrollHandler = function (b) {
          return function () {
            var sy = window.scrollY;
            b.el.style.transform = 'translateX(-50%) translateY(' + -(sy * b.speed) + 'px)';
          };
        }(blobs[i]);

        window.removeEventListener('scroll', updateNebulas);
        window.addEventListener('scroll', (function (origUpdate, b3h) {
          return function () {
            origUpdate();
            b3h();
          };
        }(updateNebulas, blobs[i].scrollHandler)), { passive: true });
        break;
      }
    }
  }


  // =========================================================================
  // Section glow on scroll — IntersectionObserver
  // =========================================================================

  function initSectionGlow() {
    if (!window.IntersectionObserver) return;

    var sections = document.querySelectorAll('.section');
    var obs = new IntersectionObserver(function (entries) {
      for (var i = 0; i < entries.length; i++) {
        var e = entries[i];
        if (e.isIntersecting) {
          e.target.classList.add('section-in-view');
        } else {
          e.target.classList.remove('section-in-view');
        }
      }
    }, {
      threshold: 0.08,
      rootMargin: '0px 0px -60px 0px',
    });

    for (var j = 0; j < sections.length; j++) {
      obs.observe(sections[j]);
    }
  }


  // =========================================================================
  // Nav active link highlight
  // =========================================================================

  function initNavHighlight() {
    var links = document.querySelectorAll('.nav-group-task-link');
    var current = window.location.pathname + window.location.hash;
    for (var i = 0; i < links.length; i++) {
      var href = links[i].getAttribute('href');
      if (href && current.indexOf(href) !== -1) {
        links[i].style.color = '#a855f7';
        links[i].style.borderLeftColor = '#7c3aed';
        links[i].style.background = 'rgba(124,58,237,0.10)';
        break;
      }
    }
  }


  // =========================================================================
  // Boot
  // =========================================================================

  window.addEventListener('resize', resize, { passive: true });

  window.addEventListener('mousemove', function (e) {
    mouse.x = e.clientX;
    mouse.y = e.clientY;
  }, { passive: true });

  window.addEventListener('scroll', updateNebulas, { passive: true });

  resize();
  drawStars();
  initNebulas();
  patchBlob3();
  initSectionGlow();
  initNavHighlight();

}());
