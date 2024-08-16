#import "CGView.h"
#import <Foundation/Foundation.h>

@implementation CGView

unsigned int (*enemyboxes)[4];
unsigned int enemyboxesCount;
unsigned int (*enemylines)[2];
unsigned int enemylinesCount;
unsigned int (*enemyhbars)[5];
unsigned int enemyhbarsCount;

- (id)initWithFrame:(UIWindow *)drawWindow
{

    self = [super initWithFrame:drawWindow.frame];
    self.userInteractionEnabled = false;
    self.backgroundColor = [UIColor clearColor];
    
    if (self) {
    enemyboxes = (unsigned int (*)[4])malloc(0);
    enemyboxesCount = 0;
    enemylines = (unsigned int (*)[2])malloc(0);
    enemylinesCount = 0;
    enemyhbars = (unsigned int (*)[5])malloc(0);
    enemyhbarsCount = 0;
    }

    [drawWindow addSubview: self];
    return self;
}

-(void)drawRect:(CGRect)rect
{

CGContextRef context = UIGraphicsGetCurrentContext();
CGContextSetAlpha(context, 255);

for (int i = 0; i < enemyboxesCount; i++) {

    UIBezierPath *outline = [UIBezierPath bezierPathWithRect:CGRectMake(enemyboxes[i][0], enemyboxes[i][1], enemyboxes[i][2], enemyboxes[i][3])];
    outline.lineWidth = 2 * ([[UIScreen mainScreen] bounds].size.width * 1/600);
    [[UIColor blackColor] setStroke];
    [outline stroke];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(enemyboxes[i][0], enemyboxes[i][1], enemyboxes[i][2], enemyboxes[i][3])];
    path.lineWidth = ([[UIScreen mainScreen] bounds].size.width * 1/600);
    [[UIColor redColor] setStroke];
    [path stroke];
}

for (int i = 0; i < enemylinesCount; i++)
{

    UIBezierPath *outline = [UIBezierPath bezierPath];
    [outline moveToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height * 0)];
    [outline addLineToPoint:CGPointMake(enemylines[i][0], enemylines[i][1])];
    outline.lineWidth = 3;
    [[UIColor blackColor] setStroke];
    [outline stroke];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height * 0)];
    [path addLineToPoint:CGPointMake(enemylines[i][0], enemylines[i][1])];
    path.lineWidth = [[UIScreen mainScreen] bounds].size.width * 1/600;
    [[UIColor redColor] setStroke];
    [path stroke];
}

for (int i = 0; i < enemyhbarsCount; i++) {

    UIBezierPath *outline = [UIBezierPath bezierPathWithRect:CGRectMake(enemyhbars[i][0], enemyhbars[i][1], enemyhbars[i][2], enemyhbars[i][3])];
    outline.lineWidth = 3;
    [[UIColor blackColor] setStroke];
    [outline stroke];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(enemyhbars[i][0], enemyhbars[i][1], enemyhbars[i][2], enemyhbars[i][3] * enemyhbars[i][4] / 100.f)];
    path.lineWidth = [[UIScreen mainScreen] bounds].size.width * 1/600;
    [[UIColor greenColor] setFill];
    [path fill];
}
[self clearDraw];
}

-(void) addEnemyBox:(float)x y:(float)y w:(float)w h:(float)h {
enemyboxesCount++;
enemyboxes = (unsigned int (*)[4])realloc(enemyboxes, enemyboxesCount*sizeof(unsigned int[4]));
enemyboxes[enemyboxesCount-1][0] = x;
enemyboxes[enemyboxesCount-1][1] = y;
enemyboxes[enemyboxesCount-1][2] = w;
enemyboxes[enemyboxesCount-1][3] = h;
}

-(void) addEnemyLine:(float)x y:(float)y {
enemylinesCount++;
enemylines = (unsigned int (*)[2])realloc(enemylines, enemylinesCount*sizeof(unsigned int[2]));
enemylines[enemylinesCount-1][0] = x;
enemylines[enemylinesCount-1][1] = y;
}

-(void) addEnemyHealthbar:(float)x y:(float)y w:(float)w h:(float)h health:(float)health {
enemyhbarsCount++;
enemyhbars = (unsigned int (*)[5])realloc(enemyhbars, enemyhbarsCount*sizeof(unsigned int[5]));
enemyhbars[enemyhbarsCount-1][0] = x;
enemyhbars[enemyhbarsCount-1][1] = y;
enemyhbars[enemyhbarsCount-1][2] = w;
enemyhbars[enemyhbarsCount-1][3] = h;
enemyhbars[enemyhbarsCount-1][4] = health;
}

-(void)clearDraw {
enemyboxesCount = 0;
enemyboxes = (unsigned int (*)[4])realloc(enemyboxes, enemyboxesCount*sizeof(unsigned int[4]));
enemylinesCount = 0;
enemylines = (unsigned int (*)[2])realloc(enemylines, enemylinesCount*sizeof(unsigned int[2]));
enemyhbarsCount = 0;
enemyhbars = (unsigned int (*)[5])realloc(enemyhbars, enemyhbarsCount*sizeof(unsigned int[5]));
}

@end