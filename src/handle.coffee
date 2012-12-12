
p = (x, y) -> "#{x}&#{y}"

world = {}

w = 30
h = 30
l = 100

window.onload = ->

  width = window.innerWidth
  height = window.innerHeight

  camera = new THREE.PerspectiveCamera 80, width/height, 1, 4000
  camera.position.z = l
  scene = new THREE.Scene()
  scene.add camera

  renderer = new THREE.CanvasRenderer()
  renderer.setSize width, height
  document.body.appendChild renderer.domElement

  particleRender = (context) ->
    context.beginPath()
    context.arc 0,0,1,0,(Math.PI * 2), true
    context.fill()

  [-w..w].forEach (x) ->
    [-h..h].forEach (y) ->
      material = new THREE.ParticleCanvasMaterial color: 0x440000, program: particleRender
      particle = new THREE.Particle material

      particle.position.x = x*2
      particle.position.y = y*2
      particle.position.z = 0

      world[p x,y] = {x, y, particle, life: (Math.random() > 0.85)}
      scene.add particle

  wake = (value) ->
    value.nextLife = yes
    value.particle.material.color.r = 1

  kill = (value) ->
    value.nextLife = no
    value.particle.material.color.r = 0.25

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
        wake value
      else if (count < 2) or (count > 3)
        if value.life
          kill value
        else if Math.random() > 0.999
          wake value
      else
        value.nextLife = value.life

    for key, value of world
      value.life = value.nextLife

  do update = ->
    updateParticles()
    renderer.render scene, camera
    requestAnimationFrame update

  do renderer.domElement.onmousemove = (event) ->
    dx = event.clientX - (width / 2)
    dy = event.clientY - (height / 2)
    camera.position.x = (Math.sin dx/1000) * l
    camera.position.y = (Math.sin dy/1000) * l
    camera.lookAt scene.position