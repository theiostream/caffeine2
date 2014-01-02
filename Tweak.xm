#import <libactivator.h>
#import <libdisplaystack/DSDisplayController.h>

@interface SBApplication : NSObject
- (NSString *)displayIdentifier;
@end

@interface SBDisplayStack : NSObject
- (SBApplication *)topApplication;
@end

@interface BKSWorkspace : NSObject
- (NSString *)topApplication;
@end

@interface SBWorkspace : NSObject
- (BKSWorkspace *)bksWorkspace;
@end

static SBWorkspace *g_workspace = nil;
%group SBWorkspaceHooks
%hook SBWorkspace
- (id)init {
	if ((self = %orig)) {
		if (g_workspace == nil)
			g_workspace = [self retain];
	}
	
	return self;
}

- (void)dealloc {
	if (g_workspace == self) {
		[g_workspace release];
		g_workspace = nil;
	}
	
	%orig;
}
%end
%end

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 800.00
#endif

static BOOL caffeineIsOn = NO;

%group OS6Hooks
%hook SpringBoard
- (void)autoLock {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/am.theiostre.caffeine2.plist"];
	
	NSString *displayID;
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) {
		NSString *topApp = [[g_workspace bksWorkspace] topApplication];
		displayID = topApp ? topApp : @"com.apple.springboard";
	}
	else {
		SBApplication *topApp = [[(DSDisplayController *)[%c(DSDisplayController) sharedInstance] activeStack] topApplication];
		displayID = topApp ? [topApp displayIdentifier] : @"com.apple.springboard";
	}
	
	BOOL cofa = [[dict objectForKey:[@"CaffeineIsOn-" stringByAppendingString:displayID]] boolValue];
	if (cofa) return;
	
	if (!caffeineIsOn) %orig;
}
%end
%end

%group OS7Hooks
%hook SBBacklightController
- (void)_autoLockTimerFired:(id)sender {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/am.theiostre.caffeine2.plist"];
	
	NSString *displayID;
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) {
		NSString *topApp = [[g_workspace bksWorkspace] topApplication];
		displayID = topApp ? topApp : @"com.apple.springboard";
	}
	else {
		SBApplication *topApp = [[(DSDisplayController *)[%c(DSDisplayController) sharedInstance] activeStack] topApplication];
		displayID = topApp ? [topApp displayIdentifier] : @"com.apple.springboard";
	}
	
	BOOL cofa = [[dict objectForKey:[@"CaffeineIsOn-" stringByAppendingString:displayID]] boolValue];
	if (cofa) return;
	
	if (!caffeineIsOn) %orig;
}
%end
%end

@interface Caffeine2 : NSObject <LAListener>
@end

@implementation Caffeine2
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Caffeine" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	
	caffeineIsOn = !caffeineIsOn;
	
	if (caffeineIsOn) theAlert.message = @"Caffeine is now on.";
	else theAlert.message = @"Caffeine is now off.";
	
	[theAlert show];
	[theAlert release];
	
	[event setHandled:YES];
}

+ (void)load {
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"am.theiostre.ios-caffeine"];
}
@end

%ctor {
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0)
		%init(SBWorkspaceHooks);
	else
		dlopen("/Library/MobileSubstrate/DynamicLibraries/DisplayStack.dylib", RTLD_LAZY);
	
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
		%init(OS7Hooks);
	else
		%init(OS6Hooks);
	%init;
}
