#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ============================================
// MyFirstDylib - ESign Compatible
// Shows a welcome alert when the app launches
// ============================================

static void showWelcomeAlert(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;

        // iOS 13+ support
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *w in windowScene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        }

        if (!window) {
            window = [UIApplication sharedApplication].keyWindow;
        }

        UIViewController *rootVC = window.rootViewController;
        while (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
        }

        if (!rootVC) return;

        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"ESign Success! 🎉"
            message:@"تم تحميل MyFirstDylib بنجاح!"
            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction
            actionWithTitle:@"حسناً"
            style:UIAlertActionStyleDefault
            handler:nil];

        [alert addAction:ok];
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

@interface MyTweakHook : NSObject
@end

@implementation MyTweakHook

+ (void)load {
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidBecomeActiveNotification
        object:nil
        queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification *note) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                dispatch_after(
                    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                    dispatch_get_main_queue(), ^{
                        showWelcomeAlert();
                    });
            });
        }];
}

@end
