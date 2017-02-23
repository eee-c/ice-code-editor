part of ice;

class DefaultProject {
  static String get content => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/babylon.js"></script>
<script>
                                                                            // (1) TRY clicking the HIDE CODE button! -->
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

  /*** (2) TRY changing the number after radius! ***/

  var sphere = BABYLON.MeshBuilder.CreateIcoSphere("isosphere1", {radius: 5}, scene);

  var cover = new BABYLON.StandardMaterial("texture1", scene);

  /*** (3) Try other colors like Blue, Red, Yellow! ***/

  cover.diffuseColor = BABYLON.Color3.Magenta();
  sphere.material = cover;

  // Now, animate the scene:
  engine.runRenderLoop(function(){
    scene.render();

    /*** (4) Try changing the numbers! ***/

    sphere.rotation.x = Date.now() * 0.0005;
    sphere.rotation.y = Date.now() * 0.001;
  });
</script>''';
}
