# NBUIKitMainThreadGuard
Checks UIView methods are being called on the correct thread. Swift re-work of [PSPDFUIKitMainThreadGuard.m](https://gist.github.com/steipete/5664345).

## Installation
Drag into project. Add a preprocessor macro in build settings for the debug build: `DEBUG=1` and in Other Swift Flags: `-DDEBUG`

## License
MIT