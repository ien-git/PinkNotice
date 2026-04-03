#import <UIKit/UIKit.h>

// ==========================================
// TẠO GIAO DIỆN THÔNG BÁO (UIVIEW)
// ==========================================
@interface PinkNoticeView : UIView
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation PinkNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Cài đặt màu nền hồng phấn (Pastel Pink)
        self.backgroundColor = [UIColor colorWithRed:1.00 green:0.80 blue:0.86 alpha:0.95];
        
        // Bo góc và viền
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.clipsToBounds = YES;

        // Thêm hiệu ứng đổ bóng (Shadow)
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 5;
        self.layer.masksToBounds = NO;

        // Icon khiên xanh (Dùng Emoji hoặc có thể thay bằng UIImageView)
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        iconLabel.text = @"🛡️"; 
        iconLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:iconLabel];

        // Tiêu đề
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 200, 25)];
        titleLabel.text = @"THÔNG BÁO HỆ THỐNG";
        titleLabel.textColor = [UIColor colorWithRed:0.85 green:0.20 blue:0.45 alpha:1.0]; // Chữ hồng đậm
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLabel];

        // Nút tắt (Close Button)
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(frame.size.width - 35, 15, 25, 25);
        [self.closeBtn setTitle:@"✖" forState:UIControlStateNormal];
        [self.closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];

        // Dòng kẻ ngang (Separator)
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 50, frame.size.width - 30, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self addSubview:line];

        // Nội dung thông báo
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, frame.size.width - 30, 60)];
        contentLabel.text = @"Chào mừng bạn đến với Liên Quân Mobile!\nLiên hệ Admin: Telegram @your_id";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 0; // Tự động xuống dòng
        [self addSubview:contentLabel];
    }
    return self;
}

// Xử lý sự kiện khi bấm nút tắt
- (void)closeTapped {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0; // Mờ dần
        self.transform = CGAffineTransformMakeScale(0.8, 0.8); // Thu nhỏ lại
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; // Xóa khỏi màn hình
    }];
}
@end


// ==========================================
// HOOK VÀO APP ĐỂ HIỂN THỊ
// ==========================================
%hook UIWindow

// Can thiệp vào lúc Cửa sổ (Window) của App được tạo và hiển thị
- (void)makeKeyAndVisible {
    %orig; // Gọi lại hàm gốc để app hoạt động bình thường

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Delay 3 giây sau khi mở app để hiện thông báo (đợi qua màn hình loading đen)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
            if (mainWindow) {
                CGFloat width = 320;
                CGFloat height = 130;
                // Đặt vị trí ở giữa phía trên màn hình
                CGRect frame = CGRectMake((mainWindow.bounds.size.width - width) / 2, 50, width, height);

                PinkNoticeView *noticeView = [[PinkNoticeView alloc] initWithFrame:frame];
                noticeView.alpha = 0;
                noticeView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
                [mainWindow addSubview:noticeView];

                // Hiệu ứng Animation hiện ra (Phóng to -> Trở về bình thường)
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    noticeView.alpha = 1.0;
                    noticeView.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        });
    });
}

%end
