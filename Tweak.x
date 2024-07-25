/**
 * Copyright (c) 2024 Nightwind
 */


#import <UIKit/UIKit.h>
#import "MediaRemoteUI.h"


extern UIColor *const colorForKey(NSString *const key);


%group NowPlayingHeaderSection
%hook MRUNowPlayingLabelView

- (void)updateVisualStyling {}

- (void)didMoveToSuperview {
	%orig;

	self.routeLabel.textColor = colorForKey(@"RouteLabelColor");
	self.titleMarqueeView.textColor = colorForKey(@"TitleColor");
	self.subtitleMarqueeView.textColor = colorForKey(@"SubtitleColor");
	self.placeholderMarqueeView.textColor = colorForKey(@"PlaceholderColor");
}

%end
%end // NowPlayingHeaderSection


%group NowPlayingButtonsSection
%hook MRUCAPackageView

- (void)layoutSubviews {
	%orig;

	NSString *const packageName = [self packageName];
	if (!packageName) return;

	UIColor *const playButtonColor = colorForKey(@"PlayButtonColor");
	UIColor *const backwardsButtonColor = colorForKey(@"BackwardsButtonColor");
	UIColor *const forwardsButtonColor = colorForKey(@"ForwardsButtonColor");

	if ([packageName isEqualToString:@"PlayPauseStop"]) {
		[self mru_applyVisualStylingWithColor:playButtonColor alpha:1.0f blendMode:kCGBlendModeNormal];
	} else if ([packageName isEqualToString:@"ForwardBackward"]) {
		const BOOL isBackwardsImage = self.permanentTransform.m11 == -1;

		if (isBackwardsImage) {
			[self mru_applyVisualStylingWithColor:backwardsButtonColor alpha:1.0f blendMode:kCGBlendModeNormal];
		} else {
			[self mru_applyVisualStylingWithColor:forwardsButtonColor alpha:1.0f blendMode:kCGBlendModeNormal];
		}
	}
}

%end
%end // NowPlayingButtonsSection


%group TransportButtonSection
%hook MRUTransportButton

- (void)updateVisualStyling {}

%end
%end // TransportButtonSection


%group RoutingButtonSection
%hook MRUNowPlayingTransportControlsView

- (void)updateVisualStyling {}
- (void)updateVisibility {}

- (MRUTransportButton *)routingButton {
	MRUTransportButton *const routingButton = %orig;
	routingButton.tintColor = colorForKey(@"RoutingButtonColor");
	routingButton.alpha = 1.0f;
	return routingButton;
}

%end

%hook MRUControlCenterView

- (MRUTransportButton *)routingButton {
	MRUTransportButton *const routingButton = %orig;
	routingButton.tintColor = colorForKey(@"RoutingButtonColor");
	routingButton.alpha = 1.0f;
	return routingButton;
}

%end
%end // RoutingButtonSection


%group WaveformSection
%hook MRUWaveformView

- (void)updateVisualStyle {}

- (void)didMoveToSuperview {
	%orig;

	for (UIView *bar in [self bars]) {
		bar.backgroundColor = colorForKey(@"WaveformColor");
		bar.alpha = 1.0f;
	}
}

- (void)applyContext:(NSUInteger)context {
	/**
	 * 0 = dynamic island (color depends on artwork)
	 * 1 = music player (custom color)
	 */
	%orig(1);
}

%end
%end // WaveformSection


%group SlidersSection
%hook MRUSlider

- (void)updateVisualStyling {}

%end
%end


%group TimeControlsSection
%hook MRUNowPlayingTimeControlsView

- (void)updateVisualStyling {}

- (void)didMoveToSuperview {
	%orig;

	self.slider.minTrack.backgroundColor = colorForKey(@"TimeMinTrackColor");
	self.slider.maxTrack.backgroundColor = colorForKey(@"TimeMaxTrackColor");
	self.elapsedTimeLabel.textColor = colorForKey(@"ElapsedTimeTextColor");
	self.remainingTimeLabel.textColor = colorForKey(@"RemainingTimeTextColor");
}

%end
%end // TimeControlsSection


%group VolumeControlsSection
%hook MRUNowPlayingVolumeControlsView

- (void)updateVisualStyling {}

- (void)didMoveToSuperview {
	%orig;

	self.slider.minTrack.backgroundColor = colorForKey(@"VolumeMinTrackColor");
	self.slider.maxTrack.backgroundColor = colorForKey(@"VolumeMaxTrackColor");
	self.maxImageView.tintColor = colorForKey(@"MinVolumeIconColor");
	self.minImageView.tintColor = colorForKey(@"MaxVolumeIconColor");
}

%end
%end // VolumeControlsSection


%ctor {
	NSDictionary *const prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nightwind.musicplayercontrolscolorsettings.plist"];

	const BOOL (^boolForKey)(NSString *) = ^BOOL(NSString *key) {
		return [prefs objectForKey:key] ? [[prefs objectForKey:key] boolValue] : YES;
	};

	if (!boolForKey(@"TweakEnabled")) return;

	const BOOL nowPlayingHeaderSectionEnabled = boolForKey(@"NowPlayingHeaderSectionEnabled");
	const BOOL nowPlayingButtonsSectionEnabled = boolForKey(@"NowPlayingButtonsSectionEnabled");
	const BOOL routingButtonSectionEnabled = boolForKey(@"RoutingButtonSectionEnabled");
	const BOOL waveformSectionEnabled = boolForKey(@"WaveformSectionEnabled");
	const BOOL timeControlsSectionEnabled = boolForKey(@"TimeControlsSectionEnabled");
	const BOOL volumeControlsSectionEnabled = boolForKey(@"VolumeControlsSectionEnabled");

	if (nowPlayingHeaderSectionEnabled || nowPlayingButtonsSectionEnabled || routingButtonSectionEnabled) {
		%init(TransportButtonSection);
	}

	if (timeControlsSectionEnabled || volumeControlsSectionEnabled) {
		%init(SlidersSection);
	}

	if (nowPlayingHeaderSectionEnabled) {
		%init(NowPlayingHeaderSection);
	}

	if (nowPlayingButtonsSectionEnabled) {
		%init(NowPlayingButtonsSection);
	}

	if (routingButtonSectionEnabled) {
		%init(RoutingButtonSection);
	}

	if (waveformSectionEnabled) {
		%init(WaveformSection);
	}

	if (timeControlsSectionEnabled) {
		%init(TimeControlsSection);
	}

	if (volumeControlsSectionEnabled) {
		%init(VolumeControlsSection);
	}
}