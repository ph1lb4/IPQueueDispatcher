//
//  Macros.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#ifndef Macros_h
#define Macros_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#define INVALIDATE_TIMER(t) [t invalidate]; t = nil;
#define EXECUTE_ON_MAIN_THREAD if (![NSThread isMainThread]) { dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return; };
#define EXECUTE_ON_BACKGROUND_THREAD if ([NSThread isMainThread]) { dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ [self performSelector:_cmd]; }); return; };
#define DEGREES_TO_RADIANS( degrees ) ( ( degrees ) / 180.0 * M_PI )
#define IOS_AT_LEAST(t) return floor(NSFoundationVersionNumber) >= t
#pragma clang diagnostic pop

#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")

#define SUPPRESS_UNDECLARED_SELECTOR_WARNING(code)                      \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"")           \
code;                                                                   \
_Pragma("clang diagnostic pop")

#endif /* Macros_h */