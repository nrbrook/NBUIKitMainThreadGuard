// Copyright (c) 2015 Nick Brook. All rights reserved.
// Inspired by PSPDFUIKitMainThreadGuard.m (https://gist.github.com/steipete/5664345 )
// Licensed under MIT (http://opensource.org/licenses/MIT)
//
// You should only use this in debug builds. It doesn't use private API, but I wouldn't ship it.

import UIKit

#if DEBUG
    
    extension UIView {
        public override class func initialize() {
            struct Static {
                static var token: dispatch_once_t = 0
            }
            
            // make sure this isn't a subclass
            if self !== UIView.self {
                return
            }
            
            dispatch_once(&Static.token) {
                let swizzle = { (cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) in
                    let originalMethod = class_getInstanceMethod(cls, originalSelector)
                    let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
                    
                    let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
                    
                    if didAddMethod {
                        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                    } else {
                        method_exchangeImplementations(originalMethod, swizzledMethod);
                    }
                }
                for method in ["setNeedsLayout", "setNeedsDisplay", "setNeedsDisplayInRect"] {
                    swizzle(self, Selector(method), Selector("nb_\(method)"))
                }
            }
        }
        
        // MARK: - Method Swizzling
        
        private func nb_mainThreadCheck() {
            // iOS 8 layouts the MFMailComposeController in a background thread on an UIKit queue.
            // https://github.com/PSPDFKit/PSPDFKit/issues/1423
            if !NSThread.isMainThread() && String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL))?.hasPrefix("UIKit") != true {
                let stack = NSThread.callStackSymbols().joinWithSeparator("\n")
                assert(false, "\nERROR: All calls to UIKit need to happen on the main thread. You have a bug in your code. Use dispatch_async(dispatch_get_main_queue()) { } if you're unsure what thread you're in.\n\nBreak on nb_mainThreadCheck to find out where.\n\nStacktrace:\n\(stack)")
            }
        }
        
        func nb_setNeedsLayout() {
            self.nb_mainThreadCheck()
            self.nb_setNeedsLayout()
        }
        
        func nb_setNeedsDisplay() {
            self.nb_mainThreadCheck()
            self.nb_setNeedsDisplay()
        }
        
        func nb_setNeedsDisplayInRect(rect: CGRect) {
            self.nb_mainThreadCheck()
            self.nb_setNeedsDisplayInRect(rect)
        }
    }
    
    
#endif // DEBUG
