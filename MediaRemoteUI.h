/**
 * Copyright (c) 2024 Nightwind
 */

#import <UIKit/UIView.h>
#import <UIKit/UIColor.h>

API_AVAILABLE(ios(12.0))
@interface MPRouteLabel : UIView
@property (nonatomic, strong, readwrite) UIColor *textColor;
@end

API_AVAILABLE(ios(16.0))
@interface MRUMarqueeLabel : UIView
@property (nonatomic, strong, readwrite) UIColor *textColor;
@end

API_AVAILABLE(ios(14.0))
@interface MRUNowPlayingLabelView : UIView
@property (nonatomic, strong, readwrite) MPRouteLabel *routeLabel;
@property (nonatomic, strong, readwrite) MRUMarqueeLabel *titleMarqueeView;
@property (nonatomic, strong, readwrite) MRUMarqueeLabel *subtitleMarqueeView;
@property (nonatomic, strong, readwrite) MRUMarqueeLabel *placeholderMarqueeView API_AVAILABLE(ios(16.0));
@end

API_AVAILABLE(ios(16.0))
@interface MRUCAPackageView : UIView
@property (nonatomic, assign, readwrite) CATransform3D permanentTransform;
@property (nonatomic, strong, readwrite) CALayer *packageLayer;
@property (nonatomic, strong, readonly) NSString *packageName;
- (void)mru_applyVisualStylingWithColor:(UIColor *)color alpha:(CGFloat)alpha blendMode:(CGBlendMode)blendMode;
@end

API_AVAILABLE(ios(14.0))
@interface MRUTransportButton : UIView
@end

API_AVAILABLE(ios(16.0))
@interface MRUSlider : UIView
@property (nonatomic, strong, readwrite) UIView *minTrack __attribute__((availability(ios, introduced=16.0, obsoleted=17.0)));
@property (nonatomic, strong, readwrite) UIView *maxTrack __attribute__((availability(ios, introduced=16.0, obsoleted=17.0)));
@end

API_AVAILABLE(ios(14.0))
@interface MRUNowPlayingTimeControlsView : UIView
@property (nonatomic, strong, readwrite) MRUSlider *slider API_AVAILABLE(ios(16.0));
@property (nonatomic, strong, readwrite) UILabel *elapsedTimeLabel;
@property (nonatomic, strong, readwrite) UILabel *remainingTimeLabel;
@end

API_AVAILABLE(ios(14.0))
@interface MRUNowPlayingVolumeControlsView : UIView
@property (nonatomic, strong, readwrite) MRUSlider *slider;
@property (nonatomic, strong, readwrite) UIImageView *minImageView API_AVAILABLE(ios(16.0));
@property (nonatomic, strong, readwrite) UIImageView *maxImageView API_AVAILABLE(ios(16.0));
@end

API_AVAILABLE(ios(16.0))
@interface MRUWaveformView : UIView
@property (nonatomic, retain) NSArray<UIView *> *bars;
@end