#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Biến kiểm soát FPS
static BOOL isHighFPSEnabled = NO;

// ==========================================
// TẠO GIAO DIỆN THÔNG BÁO (UIVIEW)
// ==========================================
@interface PinkNoticeView : UIView
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *telegramBtn;
@property (nonatomic, strong) UIButton *fpsBtn;
@property (nonatomic, strong) UILabel *marqueeLabel;
@end

@implementation PinkNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Giao diện hồng phấn
        self.backgroundColor = [UIColor colorWithRed:1.00 green:0.80 blue:0.86 alpha:0.95];
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 3.0; // Tăng viền lên chút để nhìn LED rõ hơn
        self.clipsToBounds = YES;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 8;

        // ==========================================
        // TÍNH NĂNG 1: VIỀN LED RGB BẰNG CAKEYFRAMEANIMATION
        // ==========================================
        CAKeyframeAnimation *colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
        colorsAnimation.values = @[
            (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor, // Đỏ
            (id)[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0].CGColor, // Cam
            (id)[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0].CGColor, // Vàng
            (id)[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor, // Lục
            (id)[UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0].CGColor, // Lam
            (id)[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0].CGColor, // Tím
            (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor  // Trở lại Đỏ
        ];
        colorsAnimation.duration = 3.0; // Tốc độ chớp LED (3 giây cho 1 vòng)
        colorsAnimation.repeatCount = HUGE_VALF; // Lặp vô hạn
        [self.layer addAnimation:colorsAnimation forKey:@"rgbBorder"];

        // Icon 🎮
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        iconLabel.text = @"🎮"; 
        iconLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:iconLabel];

        // Tiêu đề
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 200, 25)];
        titleLabel.text = @"HỆ THỐNG MOD VIP";
        titleLabel.textColor = [UIColor colorWithRed:0.85 green:0.20 blue:0.45 alpha:1.0]; 
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLabel];

        // Nút X
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(frame.size.width - 35, 15, 25, 25);
        [self.closeBtn setTitle:@"✖" forState:UIControlStateNormal];
        [self.closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 50, frame.size.width - 30, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self addSubview:line];

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, frame.size.width - 30, 45)];
        contentLabel.text = @"Bản quyền Mod Private by Khổng Mạnh Yên. Mua hack hoặc Mod Liên hệ Yên nhé,Nhớ thêm vài từ 'Mình sẽ trả phí' là được !";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.numberOfLines = 0; 
        [self addSubview:contentLabel];

        CGFloat btnW = (frame.size.width - 40) / 2; 
        
        self.fpsBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 105, btnW, 35)];
        self.fpsBtn.backgroundColor = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0];
        [self.fpsBtn setTitle:@"FPS Cao" forState:UIControlStateNormal];
        self.fpsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.fpsBtn.layer.cornerRadius = 8;
        [self.fpsBtn addTarget:self action:@selector(fpsTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fpsBtn];

        self.telegramBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2 + 5, 105, btnW, 35)];
        self.telegramBtn.backgroundColor = [UIColor colorWithRed:0.85 green:0.20 blue:0.45 alpha:1.0];
        [self.telegramBtn setTitle:@"Telegram" forState:UIControlStateNormal];
        self.telegramBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.telegramBtn.layer.cornerRadius = 8;
        [self.telegramBtn addTarget:self action:@selector(telegramTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.telegramBtn];

        // ==========================================
        // TÍNH NĂNG 2: MARQUEE WATERMARK (CHỮ CHẠY)
        // ==========================================
        UIView *marqueeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 150, frame.size.width, 30)];
        marqueeContainer.backgroundColor = [UIColor colorWithRed:0.85 green:0.20 blue:0.45 alpha:0.2];
        marqueeContainer.clipsToBounds = YES;
        [self addSubview:marqueeContainer];

        self.marqueeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width, 5, 400, 20)];
        self.marqueeLabel.text = @"🔥 Bản quyền Mod thuộc về KHONG MANH YEN - Phiên bản Private 🔥";
        self.marqueeLabel.textColor = [UIColor colorWithRed:0.85 green:0.20 blue:0.45 alpha:1.0];
        self.marqueeLabel.font = [UIFont boldSystemFontOfSize:12];
        [marqueeContainer addSubview:self.marqueeLabel];

        // Lệnh chạy chữ (Loop vô hạn)
        [UIView animateWithDuration:8.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
            self.marqueeLabel.frame = CGRectMake(-400, 5, 400, 20); // Chạy từ phải qua trái
        } completion:nil];

        // ==========================================
        // TÍNH NĂNG 3: MENU KÉO THẢ (DRAGGABLE)
        // ==========================================
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];

        // Tự đóng sau 30s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.superview) [self closeTapped];
        });
    }
    return self;
}

// Xử lý kéo thả
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)closeTapped {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        // Nếu nằm trong UITextField ảo (tính năng tàng hình), xóa luôn field đó
        if ([self.superview isKindOfClass:[UITextField class]]) {
            [self.superview removeFromSuperview];
        } else {
            [self removeFromSuperview];
        }
    }];
}

- (void)telegramTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/bbi_150313"] options:@{} completionHandler:nil];
}

- (void)fpsTapped {
    if (!isHighFPSEnabled) {
        isHighFPSEnabled = YES;
        self.fpsBtn.backgroundColor = [UIColor grayColor];
        [self.fpsBtn setTitle:@"Đã Kích Hoạt" forState:UIControlStateNormal];
        self.fpsBtn.enabled = NO;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"THÀNH CÔNG"
                                                                       message:@"Đã ép xung hệ thống lên 120 FPS. Vui lòng vào game để trải nghiệm!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Tuyệt vời" style:UIAlertActionStyleDefault handler:nil]];

        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
    }
}
@end


// ==========================================
// HOOK VÀO APP ĐỂ HIỂN THỊ (VÀ TÀNG HÌNH)
// ==========================================
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    UIWindow *win = self;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGFloat width = 320;
            CGFloat height = 185; // Tăng chiều cao chứa dòng chữ chạy
            CGRect frame = CGRectMake((win.bounds.size.width - width) / 2, 60, width, height);

            // ==========================================
            // TÍNH NĂNG 4: BYPASS SCREEN RECORD (TÀNG HÌNH)
            // ==========================================
            // Lợi dụng tính năng giấu mật khẩu (secureTextEntry) của UITextField
            // Hệ điều hành tự động bôi đen hoặc làm tàng hình các View nằm trong SecureTextField khi quay màn hình.
            UITextField *secureContainer = [[UITextField alloc] initWithFrame:frame];
            secureContainer.secureTextEntry = YES;
            secureContainer.userInteractionEnabled = YES; // Cho phép bấm xuyên qua
            [win addSubview:secureContainer];

            // Thêm Menu vào trong Container Tàng Hình
            // Fix frame về (0,0) vì nó nằm trong Container rồi
            PinkNoticeView *notice = [[PinkNoticeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            notice.alpha = 0;
            
            // Xóa background của textfield để không bị lộ
            secureContainer.backgroundColor = [UIColor clearColor];
            [secureContainer addSubview:notice];

            [UIView animateWithDuration:0.5 animations:^{ notice.alpha = 1.0; }];
        });
    });
}
%end

// Hook ép FPS
%hook CADisplayLink
- (void)setPreferredFrameRateRange:(CAFrameRateRange)range {
    if (isHighFPSEnabled) {
        %orig(CAFrameRateRangeMake(80, 120, 120));
    } else {
        %orig(range);
    }
}
%end
