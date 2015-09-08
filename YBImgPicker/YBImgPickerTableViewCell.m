//
//  YBImgPickerTableViewCell.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "YBImgPickerTableViewCell.h"
@interface YBImgPickerTableViewCell ()
@property (nonatomic , strong) IBOutlet UIImageView * albumImageView;
@property (nonatomic , strong) IBOutlet UILabel * titleLabel;
@property (nonatomic , strong) IBOutlet UILabel * numLabel;
@end
@implementation YBImgPickerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews {
    [self.titleLabel sizeToFit];
    [self.numLabel sizeToFit];
    [super layoutSubviews];
}
- (void)setAlbumImg:(UIImage *)albumImg {
    if (albumImg) {
        _albumImg = albumImg;
        self.albumImageView.image = _albumImg;
    }
}
- (void)setAlbumTitle:(NSString *)albumTitle {
    if (albumTitle.length) {
        _albumTitle = albumTitle;
        self.titleLabel.text = _albumTitle;
    }
}
- (void)setPhotoNum:(NSInteger)photoNum {
    _photoNum = photoNum;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)_photoNum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
