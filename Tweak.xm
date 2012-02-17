#import <UIKit/UIKit.h>
#import <objc/objc.h>
#import <objc/runtime.h>
#import <libactivator/libactivator.h>

#define SBWPreActivateDisplayStack        [displayStacks objectAtIndex:0]
#define SBWActiveDisplayStack             [displayStacks objectAtIndex:1]
#define SBWSuspendingDisplayStack         [displayStacks objectAtIndex:2]
#define SBWSuspendedEventOnlyDisplayStack [displayStacks objectAtIndex:3]

static NSMutableArray *displayStacks;
static NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/am.theiostre.caffeine2.plist"] autorelease];
static BOOL caffeineIsOn = NO;

@interface SBApplication : NSObject {}
-(id)displayIdentifier;
@end

@interface Caffeine2 : NSObject<LAListener> {}
@end

//======= thx conradev + thezimm
%hook SBDisplayStack

- (id)init {
  if ((self = %orig)) {
    [displayStacks addObject:self];
  }
  return self;
}

- (void)dealloc {
    [displayStacks removeObject:self];
    %orig;
}

%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    displayStacks = [[NSMutableArray arrayWithCapacity:4] retain];
    %orig;
}
//========
- (void)autoLock {
	%log;
	
	SBApplication *topApp = [SBWActiveDisplayStack topApplication];
	
	if (topApp) {
		BOOL cofa = [[dict objectForKey:[@"CaffeineIsOn-" stringByAppendingString:[topApp displayIdentifier]]] boolValue];
	
		if (!cofa) {
			if (!caffeineIsOn) %orig;
		}
	}
	
	// springboard crashes if I don't include this. It seems to return nil on -(id)topApplication;
	else {
		if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
			if (!caffeineIsOn) %orig;
	}
	
}
%end

@implementation Caffeine2
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Caffeine" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	
	caffeineIsOn = !caffeineIsOn;
	
	if (caffeineIsOn) theAlert.message = @"Caffeine is now on.";
	else theAlert.message = @"Caffeine is now off.";
	
	[theAlert show];
	[theAlert release];
}

+(void)load
{
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"am.theiostre.ios-caffeine"];
}
@end