part of ice;

class DefaultProject {
  static String get content => '''
<body></body>
<script src="http://gamingJS.com/Three.js"></script>
<script src="http://gamingJS.com/ChromeFixes.js"></script>
<script>
  var camera, scene, renderer;
  var geometry, material, mesh;

  init();
  animate();

  function init() {
    scene = new THREE.Scene();

    var aspect = window.innerWidth / window.innerHeight;
    camera = new THREE.PerspectiveCamera(75, aspect, 1, 1000);
    camera.position.z = 500;
    scene.add(camera);

    geometry = new THREE.IcosahedronGeometry(200, 1);
    material = new THREE.MeshBasicMaterial({
      color: 0x000000,
      wireframe: true,
      wireframeLinewidth: 2
    });

    mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    renderer = new THREE.CanvasRenderer();
    renderer.setClearColorHex(0xffffff);
    renderer.setSize(window.innerWidth, window.innerHeight);

    document.body.style.margin = 0;
    document.body.style.overflow = 'hidden';
    document.body.appendChild(renderer.domElement);
  }

  function animate() {
    requestAnimationFrame(animate);

    mesh.rotation.x = Date.now() * 0.0005;
    mesh.rotation.y = Date.now() * 0.001;

    renderer.render(scene, camera);
  }
</script>''';
}
