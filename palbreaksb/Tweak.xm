@interface FBBundleInfo : NSObject
@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,copy) NSString * bundleIdentifier;
@end

@interface FBApplicationInfo : FBBundleInfo
@end
NSMutableDictionary *blacklist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.skylerk99.nosub.plist"];

static NSString *libPath = @"/usr/lib/PalBreak.dylib";

%hook FBApplicationInfo

- (NSDictionary *)environmentVariables {
	NSDictionary *originalEnv = %orig;
	if ([[blacklist objectForKey:self.bundleIdentifier] boolValue]) {
		NSMutableDictionary *env = [originalEnv mutableCopy] ?: [NSMutableDictionary dictionary];
		NSString *oldDylibs = env[@"DYLD_INSERT_LIBRARIES"];
		NSString *newDylibs = oldDylibs ? [NSString stringWithFormat:@"%@:%@", libPath, oldDylibs] : libPath;
		[env setObject:newDylibs forKey:@"DYLD_INSERT_LIBRARIES"];
		[env setObject:@"1" forKey:@"_MSSafeMode"];
		return env;
	}
	return originalEnv;
}

%end

