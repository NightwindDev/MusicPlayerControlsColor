/**
 * Copyright (c) 2024 Nightwind
 */

#import <UIKit/UIColor.h>
#import <GcUniversal/GcColorPickerUtils.h>

UIColor *const colorForKey(NSString *const key) {
	NSDictionary *const prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nightwind.musicplayercontrolscolorsettings.plist"];
	NSString *const hexString = [prefs objectForKey:key];

	if (!hexString) return [UIColor whiteColor];

	unsigned rgbValue = 0;
	NSScanner *const scanner = [NSScanner scannerWithString:hexString];
	if ([hexString hasPrefix:@"#"]) {
		scanner.scanLocation = 1;
	}
	[scanner scanHexInt:&rgbValue];

	return [UIColor
		colorWithRed:((rgbValue >> 24) & 0xFF) / 255.0
		green:((rgbValue >> 16) & 0xFF) / 255.0
		blue:((rgbValue >> 8) & 0xFF) / 255.0
		alpha:(rgbValue & 0xFF) / 255.0
	];
}