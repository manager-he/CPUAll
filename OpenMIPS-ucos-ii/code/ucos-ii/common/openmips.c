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

// 游戏状态定义 - 使用位运算
#define ACTION_BREATH  0x01  // 呼气
#define ACTION_DEFEND  0x02  // 防御  
#define ACTION_ATTACK  0x04  // 攻击

// 玩家状态 - 每个玩家用8位表示：高4位是生命值，低4位是气息值
// 初始状态：生命值3，气息值0 = 0x30
#define INITIAL_LIFE    3
#define INITIAL_BREATH  0
#define PLAYER_INIT     ((INITIAL_LIFE << 4) | INITIAL_BREATH)

// 游戏状态 - 用16位表示：高8位是玩家1状态，低8位是玩家2状态
#define GAME_INIT       ((PLAYER_INIT << 8) | PLAYER_INIT)

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

INT32U uart_getc(void) {
    unsigned char lsr;
    do {
        lsr = REG8(UART_BASE + UART_LS_REG);
    } while ((lsr & 0x01) == 0);
    return (INT32U)REG8(UART_BASE + UART_TH_REG);
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

// 获取玩家生命值
INT32U getLife(INT32U player_state) {
    return (player_state >> 4) & 0x0F;
}

// 获取玩家气息值
INT32U getBreath(INT32U player_state) {
    return player_state & 0x0F;
}

// 设置玩家生命值
INT32U setLife(INT32U player_state, INT32U life) {
    return (player_state & 0x0F) | ((life & 0x0F) << 4);
}

// 设置玩家气息值
INT32U setBreath(INT32U player_state, INT32U breath) {
    return (player_state & 0xF0) | (breath & 0x0F);
}

// 打印玩家状态
void printPlayerStatus(INT32U player_state, INT32U player_num) {
    uart_print_str("P");
    uart_putc('0' + player_num);
    uart_print_str(": Life=");
    uart_putc('0' + getLife(player_state));
    uart_print_str(" Breath=");
    uart_putc('0' + getBreath(player_state));
    uart_print_str(" ");
}

// 打印动作名称
void printAction(INT32U action) {
    if (action == ACTION_BREATH) {
        uart_print_str("Breath");
    } else if (action == ACTION_DEFEND) {
        uart_print_str("Defend");
    } else if (action == ACTION_ATTACK) {
        uart_print_str("Attack");
    }
}

// 处理游戏逻辑
INT32U processGame(INT32U game_state, INT32U p1_action, INT32U p2_action) {
    INT32U p1_state = (game_state >> 8) & 0xFF;
    INT32U p2_state = game_state & 0xFF;
    INT32U p1_life = getLife(p1_state);
    INT32U p2_life = getLife(p2_state);
    INT32U p1_breath = getBreath(p1_state);
    INT32U p2_breath = getBreath(p2_state);
    
    // 处理呼气动作
    if (p1_action == ACTION_BREATH) {
        p1_breath = (p1_breath + 1) & 0x0F; // 限制在0-15范围内
        p1_state = setBreath(p1_state, p1_breath);
    }
    if (p2_action == ACTION_BREATH) {
        p2_breath = (p2_breath + 1) & 0x0F;
        p2_state = setBreath(p2_state, p2_breath);
    }
    
    // 处理攻击和防御逻辑
    if (p1_action == ACTION_ATTACK && p2_action == ACTION_DEFEND) {
        // P1攻击，P2防御 - 攻击无效
        uart_print_str("P1 attack blocked by P2 defense!\n");
    } else if (p2_action == ACTION_ATTACK && p1_action == ACTION_DEFEND) {
        // P2攻击，P1防御 - 攻击无效
        uart_print_str("P2 attack blocked by P1 defense!\n");
    } else if (p1_action == ACTION_ATTACK && p2_action == ACTION_ATTACK) {
        // 互相攻击 - 气息少的扣生命
        if (p1_breath < p2_breath) {
            p1_life = (p1_life > 0) ? (p1_life - 1) : 0;
            p1_state = setLife(p1_state, p1_life);
            uart_print_str("P1 loses life! (less breath)\n");
        } else if (p2_breath < p1_breath) {
            p2_life = (p2_life > 0) ? (p2_life - 1) : 0;
            p2_state = setLife(p2_state, p2_life);
            uart_print_str("P2 loses life! (less breath)\n");
        } else {
            uart_print_str("Equal breath - no damage!\n");
        }
    } else if (p1_action == ACTION_ATTACK && p2_action != ACTION_DEFEND) {
        // P1攻击成功
        p2_life = (p2_life > 0) ? (p2_life - 1) : 0;
        p2_state = setLife(p2_state, p2_life);
        uart_print_str("P1 attack hits P2!\n");
    } else if (p2_action == ACTION_ATTACK && p1_action != ACTION_DEFEND) {
        // P2攻击成功
        p1_life = (p1_life > 0) ? (p1_life - 1) : 0;
        p1_state = setLife(p1_state, p1_life);
        uart_print_str("P2 attack hits P1!\n");
    }
    
    // 返回新的游戏状态
    return (p1_state << 8) | p2_state;
}

// 从GPIO读取动作选择
INT32U readAction(INT32U player_num) {
    INT32U data = gpio_in() >> 1;
    INT32U choice;
    
    if (player_num == 1) {
        choice = (data) & 0x07; // 1-3
    } else {
        choice = (data >> 8) & 0x07;  // 9-11
    }
    
    // 将选择映射到动作
    if (choice == 0 || choice == 1) return ACTION_BREATH;
    if (choice == 2 || choice == 3) return ACTION_DEFEND;
    if (choice == 4 || choice == 5) return ACTION_ATTACK;
    return ACTION_BREATH; // 默认动作
}

// 读取确认按键
INT32U readConfirm(INT32U player_num) {
    INT32U data = gpio_in() >> 1;
    return player_num == 1 ? (data >> 6) & 1 : (data >> 14) & 1;
}

void TaskStart(void *pdata) {
    INT32U game_state = GAME_INIT;
    INT32U round = 1;
    INT32U last_gpio = 0;
    INT32U waiting_flag = 0;
    INT32U p1_action = ACTION_BREATH;
    INT32U p2_action = ACTION_BREATH;
    
    uart_print_str("=== Battle Game ===\n");
    uart_print_str("Actions: 1=Breath, 2=Defend, 4=Attack\n");
    uart_print_str("P1 uses low 1-3 + 7 bits, P2 uses high 9-11 + 15bits\n");
    
    for (;;) {
        INT32U current_gpio = gpio_in();
        
        if (current_gpio != last_gpio) {
            if (waiting_flag) {
                // 等待状态：检查确认键是否都为0
                if (!readConfirm(1) && !readConfirm(2)) {
                    // 确认键都归0，执行游戏逻辑
                    uart_print_str("Round ");
                    uart_putc('0' + round);
                    uart_print_str(": ");
                    
                    INT32U p1_state = (game_state >> 8) & 0xFF;
                    INT32U p2_state = game_state & 0xFF;
                    printPlayerStatus(p1_state, 1);
                    printPlayerStatus(p2_state, 2);
                    uart_print_str("\n");
                    
                    uart_print_str("P1: ");
                    printAction(p1_action);
                    uart_print_str(" | P2: ");
                    printAction(p2_action);
                    uart_print_str("\n");
                    
                    game_state = processGame(game_state, p1_action, p2_action);
                    
                    p1_state = (game_state >> 8) & 0xFF;
                    p2_state = game_state & 0xFF;
                    uart_print_str("Result: ");
                    printPlayerStatus(p1_state, 1);
                    printPlayerStatus(p2_state, 2);
                    uart_print_str("\n\n\n\n\n");
                    
                    if (getLife(p1_state) == 0) {
                        uart_print_str("P2 wins! P1 is defeated!\n\n\n\n\n");
                        break;
                    } else if (getLife(p2_state) == 0) {
                        uart_print_str("P1 wins! P2 is defeated!\n\n\n\n\n");
                        break;
                    }
                    
                    round++;
                    waiting_flag = 0;
                } else {
                    // 提醒将确认键置为0
                    uart_print_str("Please reset confirm keys to 0\n");
                }
            } else {
                // 非等待状态：检查确认键是否都为1
                if (readConfirm(1) && readConfirm(2)) {
                    // 记录当前动作
                    p1_action = readAction(1);
                    p2_action = readAction(2);
                    waiting_flag = 1;
                    uart_print_str("Actions recorded, waiting for reset...\n");
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

