#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIAlertController

- (void)viewDidLoad {
    %orig;

    NSString *title = self.title ?: @"";
    NSString *message = self.message ?: @"";

    NSString *lowerTitle = [title lowercaseString];
    NSString *lowerMessage = [message lowercaseString];

    if ([lowerTitle containsString:@"update"] || 
        [lowerMessage containsString:@"update is required"] || 
        [lowerMessage containsString:@"must update"] ||
        [lowerMessage containsString:@"update required to play"] ||
        [lowerMessage containsString:@"you must update"]) {

        // Dismiss the update prompt immediately
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    }
}

%end

%hook NSBundle

- (NSDictionary<NSString *, id> *)infoDictionary {
    NSDictionary *originalDict = %orig;

    if ([self.bundleIdentifier isEqualToString:@"com.roblox.robloxmobile"]) {
        NSMutableDictionary *modifiedDict = [originalDict mutableCopy];
        
        // Spoof to a high/recent version to potentially bypass local version checks
        // Update these numbers to match or exceed the latest Roblox version available
        modifiedDict[@"CFBundleShortVersionString"] = @"2.700.500";
        modifiedDict[@"CFBundleVersion"] = @"2700500";
        
        return [modifiedDict copy];
    }

    return originalDict;
}

%end

// Optional: Hook to prevent any forced redirects to App Store for updates
%hook UIApplication

- (BOOL)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^)(BOOL success))completion {
    if ([url.absoluteString containsString:@"itunes.apple.com"] || 
        [url.absoluteString containsString:@"apps.apple.com"] ||
        ([url.absoluteString containsString:@"roblox"] && [url.absoluteString containsString:@"update"])) {
        // Block App Store redirect for update
        if (completion) {
            completion(NO);
        }
        return NO;
    }
    return %orig;
}

%end
