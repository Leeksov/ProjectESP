#include "CGView/CGView.h"
#include "TextFieldView/TextFieldView.h"
#include "Menu.h"

#import "obfuscate.h"
#import "KittyMemory/writeData.hpp"

#include <substrate.h>
#include <mach-o/dyld.h>

#include <iostream>
#include <thread>
#include <map>

extern Menu *menu;
extern Switches *switches;

static CGView *esp;

UIWindow *mainWindow;

#define ScreenWidth mainWindow.frame.size.width
#define ScreenHeight mainWindow.frame.size.height

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
#define HOOK(offset, ptr, orig) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, (void **)&orig)
#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]

uint64_t getRealOffset(uint64_t offset){
	return KittyMemory::getAbsoluteAddress([menu getFrameworkName], offset);
}
