part of ice;

class Templates {
  static get list => [
    '3D starter project',
    '3D starter project (with Animation)',
    '3D starter project (with Physics)',
    'Empty project'
  ];

  static String byTitle(title) {
    if (title == '3D starter project') return threeD;
    if (title == 'Empty project') return empty;
    if (title == '3D starter project (with Physics)') return physics;
    if (title == '3D starter project (with Animation)') return animation;
    return '';
  }

  static String get threeD => '''
<body></body>
<script src="/three.js"></script>
<script>
  // The "scene" is where stuff in our game will happen:
  var scene = new THREE.Scene();
  var flat = {flatShading: true};
  var light = new THREE.AmbientLight('white', 0.8);
  scene.add(light);

  // The "camera" is what sees the stuff:
  var aspectRatio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspectRatio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // The "renderer" draws what the camera sees onto the screen:
  var renderer = new THREE.WebGLRenderer({antialias: true});
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  // ******** START CODING ON THE NEXT LINE ********




  // Now, show what the camera sees on the screen:
  renderer.render(scene, camera);
</script>''';

  static String get animation => '''
<body></body>
<script src="/three.js"></script>
<script>
  // The "scene" is where stuff in our game will happen:
  var scene = new THREE.Scene();
  var flat = {flatShading: true};
  var light = new THREE.AmbientLight('white', 0.8);
  scene.add(light);

  // The "camera" is what sees the stuff:
  var aspectRatio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspectRatio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // The "renderer" draws what the camera sees onto the screen:
  var renderer = new THREE.WebGLRenderer({antialias: true});
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  // ******** START CODING ON THE NEXT LINE ********




  // Start Animation

  var clock = new THREE.Clock();
  function animate() {
    requestAnimationFrame(animate);
    var t = clock.getElapsedTime();

    // Animation code goes here...

    renderer.render(scene, camera);
  }

  animate();
</script>''';

  static String get empty => '''
<body></body>
<script src="/three.js"></script>
<script>
  // Your code goes here...
</script>''';

  static String get physics => '''
<body></body>
<script src="/three.js"></script>
<script src="/physi.js"></script>
<script>
  // Physics settings
  Physijs.scripts.ammo = '/ammo.js';
  Physijs.scripts.worker = '/physijs_worker.js';

  // The "scene" is where stuff in our game will happen:
  var scene = new Physijs.Scene();
  scene.setGravity(new THREE.Vector3( 0, -100, 0 ));
  var flat = {flatShading: true};
  var light = new THREE.AmbientLight('white', 0.8);
  scene.add(light);

  // The "camera" is what sees the stuff:
  var aspectRatio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspectRatio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // The "renderer" draws what the camera sees onto the screen:
  var renderer = new THREE.WebGLRenderer({antialias: true});
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  // ******** START CODING ON THE NEXT LINE ********



  // Animate motion in the game
  function animate() {
    requestAnimationFrame(animate);
    renderer.render(scene, camera);
  }
  animate();

  // Run physics
  function gameStep() {
    scene.simulate();
    // Update physics 60 times a second so that motion is smooth
    setTimeout(gameStep, 1000/60);
  }
  gameStep();
</script>''';

}
