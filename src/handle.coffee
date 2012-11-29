
coin = ->
  a = Math.random()
  a > 0.95

world = {}

camera = {}
scene = {}
renderer = {}
particles = []
mouseX = 0
mouseY = 0

p = (x, y) -> "#{x}&#{y}"
w = 70
h = 40
window.onload = ->

  init = ->
    camera = new THREE.PerspectiveCamera 80, window.innerWidth/window.innerHeight, 1, 4000
    camera.position.z = 1000
    scene = new THREE.Scene()
    scene.add camera

    renderer = new THREE.CanvasRenderer()
    renderer.setSize window.innerWidth, window.innerHeight
    document.body.appendChild renderer.domElement

    makePaticles()

    do update = ->
      updateParticles()
      renderer.render scene, camera
      requestAnimationFrame update

  makePaticles = ->
    [-w..w].forEach (x) ->
      [-h..h].forEach (y) ->
        material = new THREE.ParticleCanvasMaterial color: 0x000000, program: particleRender
        particle = new THREE.Particle material

        particle.position.x = x*2
        particle.position.y = y*2
        particle.position.z = 800

        world[p x,y] =
          position:
            x: x
            y: y
          particle: particle
          life: coin()

        scene.add particle
        particles.push particle

  particleRender = (context) ->
    context.beginPath()
    context.arc 0,0,1,0,(Math.PI * 2), true
    context.fill()

  updateParticles = ->
    for key, value of world
      count = 0
      x = value.position.x
      y = value.position.y
      for a in [(x-1)..(x+1)]
        if count > 3 then break
        for b in [(y-1)..(y+1)]
          me = world[p a,b]
          unless x is 0 and y is 0
            if me?
              if me.life
                count += 1
      point = world[key]
      if count in [3]
        unless point.life
          point.life = yes
          point.particle.material.color.r = 0.4
      else unless count is 2
        if point.life
          point.life = no
          point.particle.material.color.r = 0

  do init