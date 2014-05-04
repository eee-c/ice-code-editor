part of ice;

class NewProjectDialog extends Dialog implements MenuAction {
  NewProjectDialog(Full f): super(f);

  get name => 'New';

  open() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30"></label>
      <button>Save</button>
      <button id=fake_enter_key></button>
      <div>
        <label>
          Template:
          <select>
            ${Templates.list.map((t)=> '<option>$t</option>').join()}
          </select>
        </label>
      </div>
      </div>
      '''
    );

    // Hack in lieu of KeyEvent tests
    dialog.query('button#fake_enter_key')
      ..onClick.listen((e)=> _create())
      ..style.display = 'none';

    dialog.query('button')
      ..onClick.listen((e)=> _create());

    dialog.query('input').onKeyDown.
      listen((e) {
        if (e.keyCode != KeyCode.ENTER) return;
        _create();
        e.preventDefault();
      });

    var input = dialog.query('input');

    js.context.callMethod('listenEvent', [input, (keycode){
      print('[dart] ${keycode}');
      if (keycode != KeyCode.ENTER) return;
      _create();
    }]);

    // var jsInput = new js.JsObject.fromBrowserObject(input);
    // jsInput.callMethod('addEventListener', ['keydown',
    //   new js.JsFunction.withThis(proxyEvent)
    // ]);

    // (KeyboardEvent e){
    //   print('[keydown] ${e.which}');
    //   _create();
    // }]);

    // .onKeyDown.
    //   listen((e) {
    //     print("[keydown]  ${e.keyCode} ${e.which}");
    //     if (e.keyCode != KeyCode.ENTER) return;
    //     _create();
    //   });

    parent.append(dialog);
    dialog.query('input').focus();
  }

  _create() {
    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    var template = _list.value,
        code = Templates.byTitle(template);

    store[title] = {'code': code};
    ice.content = code;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  SelectElement get _list => query('.ice-dialog').query('select');
}
