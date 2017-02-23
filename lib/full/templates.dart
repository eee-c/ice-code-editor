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
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20), scene);
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);

  var light = new BABYLON.HemisphericLight("light1", new BABYLON.Vector3(1, 2, 0), scene);

  // ******** START CODING ON THE NEXT LINE ********




  // Now, show what the camera sees on the screen:
  scene.render();
</script>''';

  static String get animation => '''
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
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20), scene);
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);

  var light = new BABYLON.HemisphericLight("light1", new BABYLON.Vector3(1, 2, 0), scene);

  // ******** START CODING ON THE NEXT LINE ********




  // Now, animate the scene:
  engine.runRenderLoop(function(){
    scene.render();
  });
</script>''';

  static String get empty => '''
<body></body>
<script>
  // Your code goes here...
</script>''';

  static String get physics => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/babylon.js"></script>
<script src="/cannon.js"></script>
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
  var gravityVector = new BABYLON.Vector3(0,-9.81, 0);
  var physicsPlugin = new BABYLON.CannonJSPlugin();
  scene.enablePhysics(gravityVector, physicsPlugin);

  // This is what sees the stuff:
  var camera = new BABYLON.FreeCamera("camera1", new BABYLON.Vector3(0, 5, 20), scene);
  camera.setTarget(BABYLON.Vector3.Zero());
  camera.attachControl(canvas);

  var light = new BABYLON.HemisphericLight("light1", new BABYLON.Vector3(1, 2, 0), scene);

  // ******** START CODING ON THE NEXT LINE ********



  // Now, show what the camera sees on the screen:
  engine.runRenderLoop(function(){
    scene.render();
  });
</script>''';
}
