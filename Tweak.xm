#import <libactivator.h>
#import <libdisplaystack/DSDisplayController.h>

static BOOL caffeineIsOn = NO;

%hook SpringBoard
- (void)autoLock {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/am.theiostre.caffeine2.plist"];
	SBApplication *topApp = [[[DSDisplayController sharedInstance] activeStack] topApplication];
	
	if (topApp) {
		BOOL cofa = [[dict objectForKey:[@"CaffeineIsOn-" stringByAppendingString:[topApp displayIdentifier]]] boolValue];
		if (cofa) return;
	}
	
	if (!caffeineIsOn) %orig;
}
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
}

+ (void)load {
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"am.theiostre.ios-caffeine"];
}
@end

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/DisplayStack.dylib", RTLD_LAZY);
}