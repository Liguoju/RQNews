# RQNews
![image](https://github.com/GreenTom/RQNews/blob/master/%E6%8E%8C%E4%B8%8A%E6%96%B0%E9%97%BB/%E6%8E%8C%E4%B8%8A%E6%96%B0%E9%97%BB/Source/ios/AppIcon.appiconset/Icon-40%402x.png)

## Contents
* [底层滑动实现](#底层滑动实现)
* [排序模块实现](#排序模块实现)
* [标题动画](#标题动画)
    
##<a id="底层滑动实现"></a>底层滑动实现
```objc
/** 添加子控制器 */
- (void)addController;
/** 滚动动画结束后调用（代码导致）*/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
/** 滚动结束（手势导致）*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
/** 滚动结束 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
```
##<a id="排序模块实现"></a>排序模块实现
```objc
/** 创建排序视图 */
@property (nonatomic, strong) UIView *sortItemView;
/** 创建排序按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

/** 存喜欢的栏目 */
@property (nonatomic) NSMutableArray *newsTitleArray;
/** 存不喜欢的栏目 */
@property (nonatomic) NSMutableArray *deleteTitleArray;

/** 初始化栏目视图 */
- (void)addSortItem;
/** 添加长按手势 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;
/** 解决长按手势和点击事件冲突 */
longPress.cancelsTouchesInView = NO;
```
##<a id="标题动画"></a>标题动画
```objc
/** 标题Label属性 */
- (void)setScale:(CGFloat)scale{
    _scale = scale;
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1.0];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}
/** 滚动结束改变Label属性*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSInteger leftIndex = (int)value;
    NSInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    TitleLabel *labelLeft = self.titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    
    if (rightIndex < self.titleScrollView.subviews.count) {
        TitleLabel *label = self.titleScrollView.subviews[rightIndex];
        label.scale = scaleRight;
    }
}
```
