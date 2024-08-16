#import <UIKit/UIKit.h>

@interface CGView : UIView

-(id)initWithFrame:(UIWindow *)drawWindow;
-(void)drawRect:(CGRect)rect;
-(void) addEnemyBox:(float)x y:(float)y w:(float)w h:(float)h;
-(void) addEnemyLine:(float)x y:(float)y;
-(void) addEnemyHealthbar:(float)x y:(float)y w:(float)w h:(float)h health:(float)health;
-(void) clearDraw;

@end 