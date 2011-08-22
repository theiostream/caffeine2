# Caffeine 2 #

## QA ##
### How it differs from Caffeine 1? ###
It adds a main new feature: the capability to use <a 
href="http://github.com/rpetrich/applist>the AppList framework</a> in 
order to select which apps have autolock triggered.

### I still don't get it ###
Think of it this way. You have the apps <b>Cut the Rope</b> and 
<b>Cydia</b>. Maybe you want Cydia not to autolock (to see a long 
installation maybe) and you are always moving Cut the Rope!

So instead of using a global autolock which covers apps you don't need 
(such as Cut the Rope) and leaves you with the possibility of leaving it 
unlocked (wasting a lot of battery), or you can set it to lock in a 
quite long time, which is still annoying as you might be downloading, 
for instance, a huge theme on Cydia and it might lock.

### OK, so with Caffeine 1 I can trigger it on/off, why select apps? ###
MobileTerminal. You can run tons of long commands and be annoyed with it 
locking. OK, use Caffeine 1! But it's tiring to keep using it (or 
SleepDepriver) everytime; and also you <i>always</i> want MobileTerminal 
to stop the autolocking.

This is the purpose of Caffeine 2: Via AppList you can choose which apps 
never autolock.

### What is AppList? ###
AppList is a framework made by the mighty Ryan Petrich, which allows you 
to list all current applications inside a PreferenceLoader PLIST or in 
other places.

If you ever used FullForce on the iPad, you certainly know how AppList 
works (same with RetinaPad). On an iPhone I never really saw anything 
using AppList, but anyways it's not anything special... It will just get 
installed automatically with the package and you will be able to use 
Caffeine 2 amazingly.

### Why does it conflict with SleepDepriver? ###
Oh, it's because the developer stole my idea and made it better. ;p

Joking. The deal is, we both <i>hook</i> the same methods, which means 
if you have both installed you will most likely get a safemode crash 
when the <code>- (void)autoLock;</code> method is called (everytime your 
device autolocks).

### I do't want my screen to dim!!! ###
I'm working on it. Calm down. If you want it so badly get SleepDepriver 
from Cydia, but you cannot get the amazing benefits of Caffeine 2, only 
an improved version of Caffeine 1.


### Amazing, how to get it? ###
It's just on github for now (the deb), but it will be soon on the 
BigBoss repo.


## Dev details ##

### How to use AppList? ###
Caffeine 2, in my opinion, is a pretty nice example of AppList usage. 
But for a more complete variety of options I'd check out <a 
href="http://github.com/rpetrich/applist">applist</a>'s source and <a 
href="http://github.com/rpetrich/fullforce">FullForce</a>'s.

### Display Stacks? ###
Thanks to <a href="http://kramerapps.com"Conrad Kramer (conradev)</a> I 
managed to implement something called <b>Display Stacks</b> on my code. 
It means you can get some info on the applications running on your 
device, such as the topApplication, which can be retrieved with <code>- 
(id)topApplication;</code>.

You can check out <b>SBDisplayStack.h</b> on a SpringBoard dump, it will 
contain pretty much basic methods on what you need.

### Why do you need that <code>if(!topApp)</code>? ###
For an odd reason, SpringBoard returns nil when I call 
<code>-topApplication</code>, so an exception is thrown when I try to 
make the <code>-stringByAppendingString:</code> thing, which gives me 
the safemode crash.

Of course, topApplication is nil when SpringBoard is the top app, so I 
did that statetement because no other app returned nil there... 
<code>[[NSBundle mainBundle] bundleIdentifier]</code> was used just to 
make sure main bundle was SpringBoard, and then I checked for the 
<code>caffeineIsOn</code> BOOL, as the <code>cofa</code> one could never 
be declared in these conditions.

## Credits: ##
<b>Maximus</b> for all the support
<b>conradev & TheZimm</b> for display stacks
<b>rpetrich</b> for AppList support
<b>ComingWinter</b> for hacking my site and annoying me like hell.
