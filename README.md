nyfiken
===========================================================

Simple yet powerful profiling for Node.js.

## Install

    npm install nyfiken --save

## Build

Compile CoffeeScript files in ./src into ./lib.

    $ make lib

## Use

	var nyfiken = require('nyfiken');

	var profiler = new nyfiken.Profiler();

	profiler.profile("Profile a block of code", function (endTimer) {
		for (var i = 0; i < 100; i++) {
			console.log("Yo yo! " + i);
		}
		endTimer();
	});

## API

	profile
	scope
	decorate
	