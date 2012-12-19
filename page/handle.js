// Generated by CoffeeScript 1.4.0
var h, l, p, w, world;

p = function(x, y) {
  return "" + x + "&" + y;
};

world = {};

w = 30;

h = 30;

l = 100;

window.onload = function() {
  var camera, height, kill, particleRender, renderer, scene, update, updateParticles, wake, width, _i, _results;
  width = window.innerWidth;
  height = window.innerHeight;
  camera = new THREE.PerspectiveCamera(80, width / height, 1, 4000);
  camera.position.z = l;
  scene = new THREE.Scene();
  scene.add(camera);
  renderer = new THREE.CanvasRenderer();
  renderer.setSize(width, height);
  document.body.appendChild(renderer.domElement);
  particleRender = function(context) {
    context.beginPath();
    context.arc(0, 0, 1, 0, Math.PI * 2, true);
    return context.fill();
  };
  (function() {
    _results = [];
    for (var _i = -w; -w <= w ? _i <= w : _i >= w; -w <= w ? _i++ : _i--){ _results.push(_i); }
    return _results;
  }).apply(this).forEach(function(x) {
    var _i, _results;
    return (function() {
      _results = [];
      for (var _i = -h; -h <= h ? _i <= h : _i >= h; -h <= h ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this).forEach(function(y) {
      var material, particle;
      material = new THREE.ParticleCanvasMaterial({
        color: 0x440000,
        program: particleRender
      });
      particle = new THREE.Particle(material);
      particle.position.x = x * 2;
      particle.position.y = y * 2;
      particle.position.z = 0;
      world[p(x, y)] = {
        x: x,
        y: y,
        particle: particle,
        life: Math.random() > 0.85
      };
      return scene.add(particle);
    });
  });
  wake = function(value) {
    value.nextLife = true;
    return value.particle.material.color.r = 1;
  };
  kill = function(value) {
    value.nextLife = false;
    return value.particle.material.color.r = 0.25;
  };
  updateParticles = function() {
    var a, b, count, key, me, value, x, y, _j, _k, _ref, _ref1, _ref2, _ref3, _results1;
    for (key in world) {
      value = world[key];
      count = 0;
      x = value.x;
      y = value.y;
      for (a = _j = _ref = x - 1, _ref1 = x + 1; _ref <= _ref1 ? _j <= _ref1 : _j >= _ref1; a = _ref <= _ref1 ? ++_j : --_j) {
        for (b = _k = _ref2 = y - 1, _ref3 = y + 1; _ref2 <= _ref3 ? _k <= _ref3 : _k >= _ref3; b = _ref2 <= _ref3 ? ++_k : --_k) {
          if (!((a === x) && (b === y))) {
            me = world[p(a, b)];
            if (me != null) {
              if (me.life) {
                count += 1;
              }
            } else {
              count += 1;
            }
          }
        }
      }
      if (count === 3 && (!value.life)) {
        wake(value);
      } else if ((count < 2) || (count > 3)) {
        if (value.life) {
          kill(value);
        } else if (Math.random() > 0.9996) {
          wake(value);
        }
      } else {
        value.nextLife = value.life;
      }
    }
    _results1 = [];
    for (key in world) {
      value = world[key];
      _results1.push(value.life = value.nextLife);
    }
    return _results1;
  };
  (update = function() {
    updateParticles();
    renderer.render(scene, camera);
    return requestAnimationFrame(update);
  })();
  return renderer.domElement.onmousemove = function(event) {
    var dx, dy;
    dx = event.clientX - (width / 2);
    dy = event.clientY - (height / 2);
    camera.position.x = (Math.sin(dx / 1000)) * l;
    camera.position.y = -(Math.sin(dy / 1000)) * l;
    return camera.lookAt(scene.position);
  };
};
