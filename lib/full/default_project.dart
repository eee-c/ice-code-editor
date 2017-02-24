part of ice;

class DefaultProject {
  static String get content => '''
<body></body>
<link rel="stylesheet" href="/full-screen.css"></link>
<script src="/three.js"></script>
<script>
                                                  // (1) TRY clicking the HIDE CODE button! -->
  // This is where stuff in our game will happen:
  var scene = new THREE.Scene();

  // This is what sees the stuff:
  var aspect_ratio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspect_ratio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  // This will draw what the camera sees onto the screen:
  var renderer = new THREE.WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  /*** (2) TRY changing the number! ***/

  var geometry = new THREE.IcosahedronGeometry(200);

  /*** (3) Try other colors like puce, vermillion, goldenrod! ***/

  material = new THREE.MeshBasicMaterial({ color: 'magenta' });

  mesh = new THREE.Mesh(geometry, material);
  scene.add(mesh);

  animate();

  function animate() {
    requestAnimationFrame(animate);

    /*** (4) Try changing the numbers! ***/
    mesh.rotation.x = Date.now() * 0.0005;
    mesh.rotation.y = Date.now() * 0.001;

    renderer.render(scene, camera);
  }
</script>''';
}
