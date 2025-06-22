# luminosus-minimal
A minimal working example app using the luminosus-core framework to show its use.

The goal is that this compiles on all supported platforms desktop platforms without dependencies beside Qt in under 60s and results in a binary size under 3 MB. The code should also compile fine for mobile platforms, but additional files are required to run it there.

## Requirements

* latest Qt release (originally created with 5.11 but now updated to at least compile with Qt 6.9)
* Qt Creator or qmake
* Ubuntu: `libgl-dev`
* Generate OpenSSL certificate: `cd src/core/data && openssl req -x509 -newkey rsa:4096 -keyout luminosus_websocket.key -out luminosus_websocket.cert -days 3650 -sha256 -nodes && cd ../../..`
* see luminosus-core for details

## Build Instructions

* `git submodule update --init --recursive`
* open `src/luminosus-minimal.pro` in Qt Creator, configure and hit the green play button
