# ICE Code Editor

[![Build Status](https://drone.io/github.com/eee-c/ice-code-editor/status.png)](https://drone.io/github.com/eee-c/ice-code-editor/latest)

__*** [Try it now!](http://gamingjs.com/ice/) ***__

The Code Editor + Visualization Preview used in the book “[3D Game Programming for Kids](http://gamingjs.com).” Written in **[Dart](http://dartlang.org)**.

![ICE Code Editor Screenshot](https://raw.github.com/eee-c/ice-code-editor/master/ice_code_editor.png)

The old [JavaScript version](https://github.com/eee-c/code-editor) proved unmaintainable, hence the switch to **Dart**. This version leverages many of the benefits of **Dart**: cross-browser support, testing, documentation.

## Running the Example App

You'll need **[Dart](http://dartlang.org)** installed. To run the examples:

 1. Install dependencies with `pub install`
 2. Start the [pub](http://pub.dartlang.org) web server with `pub serve`
 3. Open the full-screen version of ICE at http://localhost:8080/full.html with Dartium

Examples are contained in the `web` directory.

## Features

 * Update button
 * Hide Code button
 * Main Menu button
   * Open
   * New
   * Make a Copy
   * Save
   * Rename
   * Share
   * Download
   * Remove
   * Help

## Build

Because ICE relies on [js-interop](http://dart-lang.github.io/js-interop/docs/js.html), not just `dart:js`, the build process requires that it is always built for development release (even in production):

````sh
$ pub build --mode=development
````

## Core Collaborators

 * [Santiago Arias](https://github.com/santiaago)
 * [Timothy King](https://github.com/lordzork)
 * [Srdjan Pejic](http://batasrki.github.io/)
 * [James Hurford](https://github.com/terrasea)

## Contributors

 * [Sangeet Agarwal](https://github.com/SangeetAgarwal)
 * [Robert Åkerblom-Andersson](https://github.com/scorpiion)
 * [Luke Barbuto](https://github.com/lexun)
 * [Kate Bladow](https://github.com/kbladow)
 * [Stephen Cagle](https://github.com/samedhi)
 * [Alex Chacon](https://github.com/alexgchacon)
 * [Jon Davison](https://github.com/jcdavison)
 * [Damon Douglas](https://github.com/damondouglas)
 * [William Estoque](https://github.com/westoque)
 * [Daniel Gempesaw](https://github.com/gempesaw)
 * [Richard Gould](https://github.com/rgould)
 * [Nik Graf](https://github.com/nikgraf)
 * [Marty Hines](https://github.com/martyhines)
 * [Jon Kirkman](https://github.com/jonkirkman)
 * [Anita Kuno](https://github.com/anteaya)
 * [Lindsey Miller](https://github.com/tech-bluenette)
 * [Morgan Nelson](https://github.com/korishev)
 * [Michael Reynolds](https://github.com/mr170)
 * [Michael Risse](https://github.com/rissem)
 * [Chris Sciolla](https://github.com/chrisski)
 * [Alper Sunar](https://github.com/asunar)

## Want to Help?

[![#pairwithme](http://www.pairprogramwith.me/badge.png)](https://www.google.com/calendar/selfsched?sstoken=UUNwdmNwR09IRm4wfGRlZmF1bHR8NmVjZjU2MGY0MzU4MTBlMjFkZTE0ZDgzYjdkMGU4ZjM)

Chris ([twitter](https://twitter.com/eee_c) / [blog](http://japhr.blogspot.com/)) runs nightly (1030pm EDT / 0230 UTC) pairing sessions. [Sign up for free](https://www.google.com/calendar/selfsched?sstoken=UUNwdmNwR09IRm4wfGRlZmF1bHR8NmVjZjU2MGY0MzU4MTBlMjFkZTE0ZDgzYjdkMGU4ZjM) to help out and learn some [Dart](http://dartlang.org)! _Absolutely no experience required. Really :)_
