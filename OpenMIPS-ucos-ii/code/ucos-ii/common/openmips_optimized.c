#include "includes.h"

#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE)
#define WAIT_FOR_XMITR \
    do { \
        lsr = REG8(UART_BASE + UART_LS_REG); \
    } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)
#define WAIT_FOR_THRE \
    do { \
        lsr = REG8(UART_BASE + UART_LS_REG); \
    } while ((lsr & UART_LS_THRE) != UART_LS_THRE)

#define TASK_STK_SIZE 512
OS_STK TaskStartStk[TASK_STK_SIZE];

// 精简的动作定义 - 使用2位表示3种动作
#define ACTION_BREATH  0x00  // 00
#define ACTION_DEFEND  0x01  // 01  
#define ACTION_ATTACK  0x02  // 10

// 精简的玩家状态 - 每个玩家用6位表示：高3位是生命值(0-7)，低3位是气息值(0-7)
// 初始状态：生命值3，气息值0 = 0x18
#define INITIAL_LIFE    3
#define INITIAL_BREATH  0
#define PLAYER_INIT     ((INITIAL_LIFE << 3) | INITIAL_BREATH)

// 游戏状态 - 用12位表示：高6位是玩家1状态，低6位是玩家2状态
#define GAME_INIT       ((PLAYER_INIT << 6) | PLAYER_INIT)

// 动作名称数组 - 减少重复代码
static const char* action_names[] = {"Breath", "Defend", "Attack"};

void uart_init(void) {
    INT32U divisor = (INT32U)IN_CLK / (16 * UART_BAUD_RATE);
    REG8(UART_BASE + UART_LC_REG) = 0x80;
    REG8(UART_BASE + UART_DLB1_REG) = divisor & 0xFF;
    REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0xFF;
    REG8(UART_BASE + UART_LC_REG) = 0x00;
    REG8(UART_BASE + UART_IE_REG) = 0x00;
    REG8(UART_BASE + UART_LC_REG) = UART_LC_WLEN8 | UART_LC_ONE_STOP | UART_LC_NO_PARITY;
}

void uart_putc(char c) {
    unsigned char lsr;
    WAIT_FOR_THRE;
    REG8(UART_BASE + UART_TH_REG) = c;
    if (c == '\n') {
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = '\r';
    }
    WAIT_FOR_XMITR;  
}

void uart_print_str(char* str) {
    INT32U i = 0;
    OS_CPU_SR cpu_sr;
    OS_ENTER_CRITICAL();
    while (str[i] != 0) {
        uart_putc(str[i]);
        i++;
    }
    OS_EXIT_CRITICAL();
}

void gpio_init() {
    REG32(GPIO_BASE + GPIO_OE_REG) = 0xFFFFFFFF;
    REG32(GPIO_BASE + GPIO_INTE_REG) = 0x00000000;
    gpio_out(0x0f0f0f0f);
}

void gpio_out(INT32U number) {
    REG32(GPIO_BASE + GPIO_OUT_REG) = number;
}

INT32U gpio_in() {
    return REG32(GPIO_BASE + GPIO_IN_REG);
}

void OSInitTick(void) {
    INT32U compare = (INT32U)(IN_CLK / OS_TICKS_PER_SEC);
    asm volatile("mtc0 %0, $9" : :"r"(0x0));
    asm volatile("mtc0 %0, $11" : :"r"(compare));
    asm volatile("mtc0 %0, $12" : :"r"(0x10000401));
}

// 精简的玩家状态操作函数
#define getLife(state)    (((state) >> 3) & 0x07)
#define getBreath(state)  ((state) & 0x07)
#define setLife(state, life)    (((state) & 0x07) | (((life) & 0x07) << 3))
#define setBreath(state, breath) (((state) & 0x38) | ((breath) & 0x07))

void printPlayerStatus(INT32U player_state, INT32U player_num) {
    INT32U life = getLife(player_state);
    INT32U breath = getBreath(player_state);
    
    // 玩家标识
    uart_print_str("Player :");
    uart_putc('0' + player_num);
    uart_print_str("\t||\t");
    
    // 生命值 - 使用简单字符
    uart_print_str("Life :");
    uart_putc('0' + life);
    uart_print_str("\t||\t");
    
    // 气息值 - 使用波浪线表示
    uart_print_str("Breath: ");
    uart_putc('0' + breath);
    uart_print_str("\t||\n");
}

// 精简的动作读取 - 使用查找表
INT32U readAction(INT32U player_num) {
    INT32U data = gpio_in() >> 1;
    INT32U choice = player_num == 1 ? (data & 0x07) : ((data >> 8) & 0x07);
    // 简化映射：0-1=Breath, 2-3=Defend, 4-5=Attack, 其他=Breath
    return (choice >> 1) & 0x03;
}

INT32U readConfirm(INT32U player_num) {
    INT32U data = gpio_in() >> 1;
    return player_num == 1 ? (data >> 6) & 1 : (data >> 14) & 1;
}

// 精简的游戏逻辑处理
INT32U processGame(INT32U game_state, INT32U p1_action, INT32U p2_action) {
    INT32U p1_state = (game_state >> 6) & 0x3F;
    INT32U p2_state = game_state & 0x3F;
    
    // 处理呼气动作
    if (p1_action == ACTION_BREATH) {
        p1_state = setBreath(p1_state, (getBreath(p1_state) + 1) & 0x07);
    }
    if (p2_action == ACTION_BREATH) {
        p2_state = setBreath(p2_state, (getBreath(p2_state) + 1) & 0x07);
    }
    
    // 精简的攻击逻辑 - 使用位运算判断
    INT32U p1_attacking = (p1_action == ACTION_ATTACK);
    INT32U p2_attacking = (p2_action == ACTION_ATTACK);
    INT32U p1_defending = (p1_action == ACTION_DEFEND);
    INT32U p2_defending = (p2_action == ACTION_DEFEND);
    INT32U p1_breath = getBreath(p1_state);
    INT32U p2_breath = getBreath(p2_state);
    
    // 互相攻击时的特殊逻辑
    if (p1_attacking && p2_attacking) {
        if (p1_breath < p2_breath) {
            p1_state = setLife(p1_state, (getLife(p1_state) > 0) ? (getLife(p1_state) - 1) : 0);
            uart_print_str("P1 loses (less breath)\n");
        } else if (p2_breath < p1_breath) {
            p2_state = setLife(p2_state, (getLife(p2_state) > 0) ? (getLife(p2_state) - 1) : 0);
            uart_print_str("P2 loses (less breath)\n");
        } else if(p1_breath >= 0 && p2_breath >= 0){
            uart_print_str("Equal breath - no damage!\n");
        }
    }
    else if (p1_attacking && p1_breath >= 0 && !p2_defending) {
        p2_state = setLife(p2_state, (getLife(p2_state) > 0) ? (getLife(p2_state) - 1) : 0);
        uart_print_str("P1 hits P2!\n");
    }
    else if (p2_attacking && p2_breath >= 0 && !p1_defending) {
        p1_state = setLife(p1_state, (getLife(p1_state) > 0) ? (getLife(p1_state) - 1) : 0);
        uart_print_str("P2 hits P1!\n");
    }

    if (p1_attacking) { p1_state = setBreath(p1_state, 0); }
    if (p2_attacking) { p2_state = setBreath(p2_state, 0); }
    
    return (p1_state << 6) | p2_state;
}

void TaskStart(void *pdata) {
    INT32U game_state = GAME_INIT;
    INT32U round = 1;
    INT32U last_gpio = 0;
    INT32U waiting_flag = 0;
    INT32U p1_action = ACTION_BREATH;
    INT32U p2_action = ACTION_BREATH;
    
    uart_print_str("=== Battle Game (Optimized) ===\n");
    uart_print_str("Actions: 0=Breath Gain 1 breath point, 1=Defend Block incoming attacks, 2=Attack Deal damage (costs all BP)\n\n");
    
    uart_print_str("+=========================================+\n");
    uart_print_str("|              GAME RULES                 |\n");
    uart_print_str("|  L = Life (0-3), B = Breath (0-7)       |\n");
    uart_print_str("|  Win Condition:  Reduce life to 0       |\n");
    uart_print_str("+=========================================+\n");
    uart_print_str("Initial Status:\n");
    printPlayerStatus((game_state >> 6) & 0x3F, 1);
    printPlayerStatus(game_state & 0x3F, 2);
    uart_print_str("+=========================================+\n\n");
    
    for (;;) {
        INT32U current_gpio = gpio_in();
        
        if (current_gpio != last_gpio) {
            if (waiting_flag) {
                if (!readConfirm(1) && !readConfirm(2)) {
                    // 执行游戏逻辑
                    uart_print_str("R");
                    uart_putc('0' + round);
                    uart_print_str(": ");
                    
                    uart_print_str("P1: ");
                    uart_print_str(action_names[p1_action]);
                    uart_print_str(" | P2: ");
                    uart_print_str(action_names[p2_action]);
                    uart_print_str("\n");
                    
                    game_state = processGame(game_state, p1_action, p2_action);
                    
                    printPlayerStatus((game_state >> 6) & 0x3F, 1);
                    printPlayerStatus(game_state & 0x3F, 2);
                    uart_print_str("\n\n");
                    
                    if (getLife((game_state >> 6) & 0x3F) == 0) {
                        uart_print_str("P2 wins!\n\n");
                        break;
                    } else if (getLife(game_state & 0x3F) == 0) {
                        uart_print_str("P1 wins!\n\n");
                        break;
                    }
                    
                    round++;
                    waiting_flag = 0;
                }
            } else {
                if (readConfirm(1) && readConfirm(2)) {
                    p1_action = readAction(1);
                    p2_action = readAction(2);
                    waiting_flag = 1;
                    uart_print_str("Actions recorded, waiting...\n");
                }
            }
            last_gpio = current_gpio;
        }
    }
}

void main() {
    OSInit();
    uart_init();
    gpio_init();
    OSTaskCreate(TaskStart, (void *)0, &TaskStartStk[TASK_STK_SIZE - 1], 0);
    OSStart();
} 