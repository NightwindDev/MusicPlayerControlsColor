/**
 * Copyright (c) 2024 Nightwind
 */

#import <Foundation/Foundation.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>
#import <spawn.h>
#import "MPCCRootListController.h"

@implementation MPCCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIImage *const applyImage = [[UIImage systemImageNamed:@"checkmark.circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:applyImage style:UIBarButtonItemStylePlain target:self action:@selector(_performRespring)];
}

- (void)_performRespring {
	[self setNeedsStatusBarAppearanceUpdate];

	[UIView animateWithDuration:0.2 animations:^{
		NSArray<UIWindowScene *> *const connectedScenes = (NSArray<UIWindowScene *> *)UIApplication.sharedApplication.connectedScenes.allObjects;
		for (UIWindow *window in connectedScenes.firstObject.windows) {
			window.alpha = 0;
			window.transform = CGAffineTransformMakeScale(0.95, 0.95);
		}
	} completion:^(BOOL finished) {
		if (finished) {
			[self _killProcessWithName:@"MediaRemoteUI"];
			[self _killProcessWithName:@"SpringBoard"];
		}
	}];
}

- (void)_killProcessWithName:(NSString *)name {
	if (!name) return;

	extern char **environ;
	pid_t pid;

	const char *args[] = { "killall", [name UTF8String], NULL };
	posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char *const *)args, environ);
	waitpid(pid, NULL, 0);
}

@end
