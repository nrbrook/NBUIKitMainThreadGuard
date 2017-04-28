# NBUIKitMainThreadGuard
Checks UIView methods are being called on the correct thread. Swift re-work of [PSPDFUIKitMainThreadGuard.m](https://gist.github.com/steipete/5664345).

## Installation
1. Drag into project
1. Select your project in the navigator, then the build settings tab
1. Filter with 'preprocessor macro', then expand the row with the arrow on the left
1. Double click in the debug row value, type `DEBUG=1`
1. Filter with 'other swift flags', expland, in the debug row type `-DDEBUG`
1. Add the following to the top of your App Delegate:

``` Swift
override init() {
    super.init()
    UIView.classInit
}
```

## License
MIT
