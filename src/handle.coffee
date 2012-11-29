
coin = ->
  a = Math.random()
  a > 0.7

world = {}

camera = {}
scene = {}
renderer = {}
particles = []
mouseX = 0
mouseY = 0

p = (x, y) -> "#{x}&#{y}"
w = 50
h = 50
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
      console.log "update"

  makePaticles = ->
    [-w..w].forEach (x) ->
      [-h..h].forEach (y) ->
        material = new THREE.ParticleCanvasMaterial color: 0x000000, program: particleRender
        particle = new THREE.Particle material

        particle.position.x = x*2
        particle.position.y = y*2
        particle.position.z = 800

        world[p x,y] =
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
      x = value.x
      y = value.y
      for a in [(x-1)..(x+1)]
        for b in [(y-1)..(y+1)]
          unless (a is x) and (b is y)
            me = world[p a,b]
            if me?
              if me.life
                count += 1
            else
              count += 1
      if count is 3 and (not value.life)
        value.nextLife = yes
        value.particle.material.color.r = 0.4
      else if (count < 2) or (count > 3)
        if value.life
          value.nextLife = no
          value.particle.material.color.r = 0
      else
        value.nextLife = value.life

    for key, value of world
      value.life = value.nextLife

  do init