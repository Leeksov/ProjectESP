#import "Macros.h"


struct Vector3 {
    float x, y, z;

    // Constructors
    inline Vector3() : x(0), y(0), z(0) {}

    inline Vector3(const float X, const float Y, const float Z) : x(X), y(Y), z(Z) {}

    // Operators
    inline Vector3 operator+(const Vector3& A) const { return Vector3(x + A.x, y + A.y, z + A.z); }
    inline Vector3 operator+(const float A) const { return Vector3(x + A, y + A, z + A); }
    inline Vector3 operator-(const Vector3& A) const { return Vector3(x - A.x, y - A.y, z - A.z); }
    inline Vector3 operator-(const float A) const { return Vector3(x - A, y - A, z - A); }
    inline Vector3 operator*(const Vector3& A) const { return Vector3(x * A.x, y * A.y, z * A.z); }
    inline Vector3 operator*(const float A) const { return Vector3(x * A, y * A, z * A); }
    inline Vector3 operator/(const Vector3& A) const { return Vector3(x / A.x, y / A.y, z / A.z); }
    inline Vector3 operator/(const float A) const { return Vector3(x / A, y / A, z / A); }
};

using vec3 = Vector3;

void *(*get_transform)(void *);
vec3 (*get_position)(void *);
int (*GetTeam)(void *);
int (*GetHealth)(void *);
bool (*get_IsLocal)(void *);
void *(*get_main)();
vec3 (*WorldToViewportPoint)(void *, vec3, int);
float (*get_fieldOfView)(void *);

vec3 GetObjectLocation(void *object) {
    return get_position(get_transform(object));
}

vec3 WorldToScreen(vec3 object) {
    vec3 position = WorldToViewportPoint(get_main(), object, 2);

    vec3 location;
    location.x = ScreenWidth * position.x;
    location.y = ScreenHeight - position.y * ScreenHeight;
    location.z = position.z;

    if (location.x > 0 && location.y > 0 && location.z > 0)
        return location;

    return {0, 0, 0};
}

struct me_t {
    void *object;
    vec3 position;
    float fov;
} *me;

struct enemy_t {
    void *object;
    vec3 position;
    vec3 w2sposition;
    int health;
} *enemy;

void (*old_player_update)(void *player);

void new_player_update(void *player) {
    [esp setNeedsDisplay];

    if (get_IsLocal(player)) {
        me->object = player;
        me->position = GetObjectLocation(me->object);
        me->fov = get_fieldOfView(get_main());
    }

    if (me->object != nullptr) {
        if (GetTeam(me->object) != GetTeam(player)) {
            enemy->object = player;
            enemy->position = GetObjectLocation(enemy->object);
            enemy->w2sposition = WorldToScreen(enemy->position);
            enemy->health = GetHealth(enemy->object);
        }

        if (enemy->w2sposition.x == 0 && enemy->w2sposition.y == 0 && enemy->w2sposition.z == 0)
            return;

        float EnemyHeight = 8400 / (enemy->w2sposition.z / 4) / (me->fov / 2);
        float EnemyWidth = 1680 / (enemy->w2sposition.z / 4) / (me->fov / 4);

        float EnemyCoordX = enemy->w2sposition.x - EnemyWidth / 2;
        float EnemyCoordY = enemy->w2sposition.y - EnemyHeight;

        if ([switches isSwitchOn:ObfuscateString("Enemy Line")]) {
            [esp addEnemyLine:(EnemyCoordX + EnemyWidth / 2) y:EnemyCoordY];
        }

        if ([switches isSwitchOn:ObfuscateString("Enemy Box")]) {
            [esp addEnemyBox:EnemyCoordX y:EnemyCoordY w:EnemyWidth h:EnemyHeight];
        }

        if ([switches isSwitchOn:ObfuscateString("Enemy Healthbar")]) {
            [esp addEnemyHealthbar:EnemyCoordX - 4.5f y:EnemyCoordY w:2.5 h:EnemyHeight health:enemy->health];
        }
    }
    old_player_update(player);
}

void setup() {
    me = new me_t();
    enemy = new enemy_t();

    *(void **)&get_transform = (void *)getRealOffset(ObfuscateOffset("0x346CF8C"));
    *(void **)&get_position = (void *)getRealOffset(ObfuscateOffset("0x3476B24"));
    *(void **)&GetTeam = (void *)getRealOffset(ObfuscateOffset("0x1B02D48"));
    *(void **)&GetHealth = (void *)getRealOffset(ObfuscateOffset("0x1B02BB8"));
    *(void **)&get_IsLocal = (void *)getRealOffset(ObfuscateOffset("0x1AFF570"));
    *(void **)&get_main = (void *)getRealOffset(ObfuscateOffset("0x344C6C4"));
    *(void **)&WorldToViewportPoint = (void *)getRealOffset(ObfuscateOffset("0x344C064"));
    *(void **)&get_fieldOfView = (void *)getRealOffset(ObfuscateOffset("0x344B488"));

    HOOK(ObfuscateOffset("0x1B01BE0"), new_player_update, old_player_update);

    [switches addSwitch:ObfuscateString("Enemy Line") description:nil];
    [switches addSwitch:ObfuscateString("Enemy Box") description:nil];
    [switches addSwitch:ObfuscateString("Enemy Healthbar") description:nil];
}

void setupMenu() {
    [menu setFrameworkName:"UnityFramework"];
    menu = [[Menu alloc]
        initWithTitle:ObfuscateString("t.me/leeksov_page")
        titleColor:[UIColor whiteColor]
        titleFont:ObfuscateString("Helvetica-Bold")
        credits:ObfuscateString("This code has been written by Leeksov.\n\nEnjoy!")
        headerColor:UIColorFromHex(0x5300EB)
        switchOffColor:[UIColor clearColor]
        switchOnColor:UIColorFromHex(0x5300EB)
        switchTitleFont:ObfuscateString("Helvetica-Bold")
        switchTitleColor:[UIColor whiteColor]
        infoButtonColor:UIColorFromHex(0x5300EB)
        maxVisibleSwitches:4
        menuWidth:200
        menuIcon:@""
        menuButton:@""];

    mainWindow = [UIApplication sharedApplication].keyWindow;
    TextFieldView *textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textFieldView.userInteractionEnabled = NO;
    textFieldView.backgroundColor = [UIColor clearColor];
    esp = [[CGView alloc] initWithFrame:mainWindow];
    
    // Check if the "Offscreen" switch is enabled
    if ([switches isSwitchOn:@"Offscreen"]) {
        [textFieldView addSubview:esp];
    }
    
    // Add textFieldView to the main window
    [mainWindow addSubview:textFieldView];

    setup();
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    timer(1) {
        setupMenu();
    });
}

__attribute__((constructor))
static void initialize() {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
