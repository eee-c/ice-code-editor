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
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/three.js"></script>
<script>
  // This is where stuff in our game will happen:
  var scene = new THREE.Scene();

  // This is what sees the stuff:
  var aspect_ratio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspect_ratio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // This will draw what the camera sees onto the screen:
  var renderer = new THREE.CanvasRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  // ******** START CODING ON THE NEXT LINE ********




  // Now, show what the camera sees on the screen:
  renderer.render(scene, camera);
</script>''';

  static String get animation => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/three.js"></script>
<script>
  // This is where stuff in our game will happen:
  var scene = new THREE.Scene();

  // This is what sees the stuff:
  var aspect_ratio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspect_ratio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // This will draw what the camera sees onto the screen:
  var renderer = new THREE.CanvasRenderer();
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
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/three.js"></script>
<script>
  // Your code goes here...
</script>''';

  static String get physics => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/three.js"></script>
<script src="/physi.js"></script>

<script>
  // Physics settings
  Physijs.scripts.ammo = '/ammo.js';
  Physijs.scripts.worker = '/physijs_worker.js';

  // This is where stuff in our game will happen:
  var scene = new Physijs.Scene({ fixedTimeStep: 2 / 60 });
  scene.setGravity(new THREE.Vector3( 0, -100, 0 ));

  // This is what sees the stuff:
  var width = window.innerWidth,
      height = window.innerHeight,
      aspect_ratio = width / height;
  var camera = new THREE.PerspectiveCamera(75, aspect_ratio, 1, 10000);
  // var camera = new THREE.OrthographicCamera(
  //   -width/2, width/2, height/2, -height/2, 1, 10000
  // );

  camera.position.z = 500;
  scene.add(camera);

  // This will draw what the camera sees onto the screen:
  var renderer = new THREE.CanvasRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);
  document.body.style.backgroundColor = '#ffffff';

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
