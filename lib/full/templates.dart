part of ice;

class Templates {
  static get list => [
    '3D starter project',
    '3D starter project (with Animation)',
    '3D starter project (with Physics)',
    'BABYLON starter project',
    'BABYLON starter project (with Animation)',
    'BABYLON starter project (with Physics)',
    'Empty project'
  ];

  static String byTitle(title) {
    if (title == '3D starter project') return threeD;
    if (title == 'Empty project') return empty;
    if (title == '3D starter project (with Physics)') return physics;
    if (title == '3D starter project (with Animation)') return animation;
    if (title == 'BABYLON starter project') return bthreeD;
    if (title == 'BABYLON starter project (with Physics)') return bphysics;
    if (title == 'BABYLON starter project (with Animation)') return banimation;
    return '';
  }

  static String get threeD => '''
<body></body>
<script src="/three.js"></script>
<script>
  // The "scene" is where stuff in our game will happen:
  var scene = new THREE.Scene();
  var flat = {shading: THREE.FlatShading};
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
  var flat = {shading: THREE.FlatShading};
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
  var flat = {shading: THREE.FlatShading};
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

  /*** Babylon ***/
  static String get bthreeD => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/babylon.js"></script>
<script>
  // Start the 3D engine
  var canvas = document.createElement('canvas');
  document.body.appendChild(canvas);
  var engine = new BABYLON.Engine(canvas);
  window.addEventListener('resize', function(){ engine.resize(); });

  // This is where stuff in our game will happen:
  var scene = new BABYLON.Scene(engine);
  scene.useRightHandedSystem = true;

  // This is what sees the stuff:
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20));
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);
  //camera.attachPostProcess(new BABYLON.FxaaPostProcess("fxaa", 1.0, camera, BABYLON.Texture.BILINEAR_SAMPLINGMODE, engine, true));
  var light = new BABYLON.DirectionalLight("light1", new BABYLON.Vector3(-1, -2, -1));
  light.intensity = 1.4;

  // ******** START CODING ON THE NEXT LINE ********




  // Now, show what the camera sees on the screen:
  scene.render();
</script>''';

  static String get banimation => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/babylon.js"></script>
<script>
  // Start the 3D engine
  var canvas = document.createElement('canvas');
  document.body.appendChild(canvas);
  var engine = new BABYLON.Engine(canvas);
  window.addEventListener('resize', function(){ engine.resize(); });

  // This is where stuff in our game will happen:
  var scene = new BABYLON.Scene(engine);
  scene.useRightHandedSystem = true;

  // This is what sees the stuff:
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20));
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);
  //camera.attachPostProcess(new BABYLON.FxaaPostProcess("fxaa", 1.0, camera, BABYLON.Texture.BILINEAR_SAMPLINGMODE, engine, true));
  var light = new BABYLON.DirectionalLight("light1", new BABYLON.Vector3(-1, -2, -1));
  light.intensity = 1.4;

  // ******** START CODING ON THE NEXT LINE ********




  // Now, animate the scene:
  engine.runRenderLoop(function(){
    scene.render();
  });
</script>''';

  static String get bphysics => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/babylon.js"></script>
<script>
  // Start the 3D engine
  var canvas = document.createElement('canvas');
  document.body.appendChild(canvas);
  var engine = new BABYLON.Engine(canvas);
  window.addEventListener('resize', function(){ engine.resize(); });

  // This is where stuff in our game will happen:
  var scene = new BABYLON.Scene(engine);
  scene.useRightHandedSystem = true;

  // Enable Physics
  var gravityVector = new BABYLON.Vector3(0, -9.81, 0);
  var physicsPlugin = new BABYLON.CannonJSPlugin();
  scene.enablePhysics(gravityVector, physicsPlugin);

  // This is what sees the stuff:
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20));
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);
  //camera.attachPostProcess(new BABYLON.FxaaPostProcess("fxaa", 1.0, camera, BABYLON.Texture.BILINEAR_SAMPLINGMODE, engine, true));
  var light = new BABYLON.DirectionalLight("light1", new BABYLON.Vector3(-1, -2, -1));
  light.intensity = 1.4;

  // ******** START CODING ON THE NEXT LINE ********



  // Now, show what the camera sees on the screen:
  engine.runRenderLoop(function(){
    scene.render();
  });
</script>''';


}
