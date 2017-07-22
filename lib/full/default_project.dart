part of ice;

class DefaultProject {
  static String get content => '''
<body></body>
<script src="/three.js"></script>
<script src="/controls/OrbitControls.js"></script>
<script>
                                                      // (1) TRY clicking the HIDE CODE button! -->

  // The "scene" is where stuff in our game will happen:
  var scene = new THREE.Scene();

  // The "camera" is what sees the stuff:
  var aspect_ratio = window.innerWidth / window.innerHeight;
  var camera = new THREE.PerspectiveCamera(75, aspect_ratio, 1, 10000);
  camera.position.z = 500;
  scene.add(camera);

  var light = new THREE.HemisphereLight('white', 'grey', 0.5);
  scene.add( light );

  // The "renderer" draws what the camera sees onto the screen:
  var renderer = new THREE.WebGLRenderer({antialias: true});
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  var orbit = new THREE.OrbitControls( camera, renderer.domElement );
	orbit.enableZoom = false;

  /****** (2) PLAY with the numbers!! ******/
  var geometry = new THREE.IcosahedronGeometry(200, 1);

  var material = new THREE.MeshPhongMaterial({

    /*** (3) Try other COLORS like lime, magenta, or blue!! ***/
    color: 'goldenrod',

    shininess: 20,
    specular: 'lightgrey',
    side: THREE.DoubleSide,
		shading: THREE.FlatShading
  });

  var mesh = new THREE.Object3D();
	mesh.add(new THREE.Mesh(geometry,  material));
  scene.add(mesh);

  animate();
  function animate() {
    requestAnimationFrame(animate);
    var t = Date.now() * 0.0001;

    /*** (4) PLAY with the numbers!! ***/
    mesh.rotation.x = 2*t;
    mesh.rotation.y = 5*t;

    renderer.render(scene, camera);
  }

  // Light up the scene
  var light = new THREE.PointLight('white', 0.75);
  light.position.set(400, 400, 600);
  scene.add( light );

  // Highlight the lines in the shape
	mesh.add(
	  new THREE.LineSegments(
		  geometry,
		  new THREE.LineBasicMaterial({
			  color: 'white',
			  transparent: true,
			  opacity: 0.5
		  })
	  )
	);
</script>''';
}
