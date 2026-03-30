module serial;

/* ============================================================================================== */
/* Imported functions                                                                             */
/* ============================================================================================== */

extern fn void write_port_uchar(void* port, char value) @extern("write_port_uchar");
extern fn char read_port_uchar(void* port) @extern("read_port_uchar");

/* ============================================================================================== */
/* Constants                                                                                      */
/* ============================================================================================== */

const void* COM1 = (void*)0x3F8;
const void* COM2 = (void*)0x2F8;
const void* COM3 = (void*)0x3E8;
const void* COM4 = (void*)0x2E8;

const void* DEFAULT_COM = COM2;

const uptr REG_DATA       = 0; // RX / TX
const uptr REG_INT_EN     = 1; // Interrupt enable
const uptr REG_FIFO_CTRL  = 2; // FIFO control
const uptr REG_LINE_CTRL  = 3; // Line control  (LCR)
const uptr REG_MODEM_CTRL = 4; // Modem control (MCR)
const uptr REG_LINE_STAT  = 5; // Line status   (LSR)

const uptr REG_DIV_LSB    = 0; // Baud divisor low byte
const uptr REG_DIV_MSB    = 1; // Baud divisor high byte

const char LCR_8N1        = 0x03; // 8 data bits, no parity, 1 stop bit
const char LCR_DLAB       = 0x80; // Divisor latch access bit
const char LSR_THR_EMPTY  = 0x20; // TX holding register empty → safe to write
const char FCR_INIT       = 0xC7; // Enable FIFO, clear RX/TX, 14-byte threshold
const char MCR_DTR_RTS    = 0x03; // Assert DTR + RTS

const char BAUD_115200_LSB = 0x01;
const char BAUD_115200_MSB = 0x00;
const char BAUD_9600_LSB   = 0x0C;
const char BAUD_9600_MSB   = 0x00;

/* ============================================================================================== */
/* Private functions                                                                              */
/* ============================================================================================== */

fn void write_reg(void* base, uptr offset, char value) @inline
{
    write_port_uchar((void*)((uptr)base + offset), value);
}

fn char read_reg(void* base, uptr offset) @inline
{
    return read_port_uchar((void*)((uptr)base + offset));
}

/* ============================================================================================== */
/* Imported functions                                                                             */
/* ============================================================================================== */

// Initialize the UART: 115200 8N1, FIFO enabled, interrupts disabled.
// Call once before any write. Pass a different base to target COM2/3/4.
fn void init(void* base = COM2)
{
    write_reg(base, REG_INT_EN,     0x00);       // disable all UART interrupts

    write_reg(base, REG_LINE_CTRL,  LCR_DLAB);   // unlock divisor registers
    write_reg(base, REG_DIV_LSB,    BAUD_115200_LSB);
    write_reg(base, REG_DIV_MSB,    BAUD_115200_MSB);

    write_reg(base, REG_LINE_CTRL,  LCR_8N1);    // 8N1, clear DLAB
    write_reg(base, REG_FIFO_CTRL,  FCR_INIT);   // enable + flush FIFO
    write_reg(base, REG_MODEM_CTRL, MCR_DTR_RTS);
}

// Block until the TX holding register is empty, then write one byte.
fn void write_char(char c, void* base = DEFAULT_COM)
{
    while ((read_reg(base, REG_LINE_STAT) & LSR_THR_EMPTY) == 0) {}
    write_reg(base, REG_DATA, c);
}

// Write a null-terminated string.
fn void write_string(char[] str, void* base = DEFAULT_COM)
{
    foreach (c : str)
    {
        write_char(c, base);
    }
}

// Write a null-terminated string followed by "\r\n".
fn void write_line(char[] str, void* base = DEFAULT_COM)
{
    write_string(str, base);
    write_char('\r', base);
    write_char('\n', base);
}

/* ============================================================================================== */

