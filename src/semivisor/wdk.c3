module wdk;

// =========================================================
// Base types
// =========================================================
alias NtStatus     = uint;
alias LargeInteger = long;   // LARGE_INTEGER  — 8 bytes
alias Kirql        = char;   // KIRQL = UCHAR
alias KspinLock    = ulong;  // KSPIN_LOCK = ULONG_PTR — 8 bytes on x64
alias Handle       = void*;
alias EProcess     = void*;
alias EThread      = void*;
alias Kaffinity    = ulong;  // KAFFINITY = ULONG_PTR — 8 bytes on x64

// Opaque kernel pointers
alias IoTimer            = void*;
alias Vpb                = void*;
alias SecurityDescriptor = void*;
alias DevObjExtension    = void*;
alias FastIoDispatch     = void*;

// Access mode
const char KERNEL_MODE = 0;
const char USER_MODE   = 1;

// =========================================================
// IRQL levels
// =========================================================
const Kirql PASSIVE_LEVEL  = 0;
const Kirql LOW_LEVEL      = 0;
const Kirql APC_LEVEL      = 1;
const Kirql DISPATCH_LEVEL = 2;
const Kirql CMCI_LEVEL     = 5;
const Kirql CLOCK_LEVEL    = 13;
const Kirql IPI_LEVEL      = 14;
const Kirql POWER_LEVEL    = 14;
const Kirql PROFILE_LEVEL  = 15;
const Kirql HIGH_LEVEL     = 15;

// =========================================================
// NtStatus — Success (0x0000xxxx)
// =========================================================
const NtStatus STATUS_SUCCESS                  = 0x00000000;
const NtStatus STATUS_WAIT_1                   = 0x00000001;
const NtStatus STATUS_WAIT_2                   = 0x00000002;
const NtStatus STATUS_WAIT_3                   = 0x00000003;
const NtStatus STATUS_WAIT_63                  = 0x0000003f;
const NtStatus STATUS_ABANDONED_WAIT_0         = 0x00000080;
const NtStatus STATUS_ABANDONED_WAIT_63        = 0x000000bf;
const NtStatus STATUS_USER_APC                 = 0x000000c0;
const NtStatus STATUS_KERNEL_APC               = 0x00000100;
const NtStatus STATUS_ALERTED                  = 0x00000101;
const NtStatus STATUS_TIMEOUT                  = 0x00000102;
const NtStatus STATUS_PENDING                  = 0x00000103;
const NtStatus STATUS_REPARSE                  = 0x00000104;
const NtStatus STATUS_MORE_ENTRIES             = 0x00000105;
const NtStatus STATUS_NOT_ALL_ASSIGNED         = 0x00000106;
const NtStatus STATUS_SOME_NOT_MAPPED          = 0x00000107;
const NtStatus STATUS_OPLOCK_BREAK_IN_PROGRESS = 0x00000108;
const NtStatus STATUS_VOLUME_MOUNTED           = 0x00000109;
const NtStatus STATUS_RXACT_COMMITTED          = 0x0000010a;
const NtStatus STATUS_NOTIFY_CLEANUP           = 0x0000010b;
const NtStatus STATUS_NOTIFY_ENUM_DIR          = 0x0000010c;

// =========================================================
// NtStatus — Informational (0x4000xxxx)
// =========================================================
const NtStatus STATUS_OBJECT_NAME_EXISTS      = 0x40000000;
const NtStatus STATUS_THREAD_WAS_SUSPENDED    = 0x40000001;
const NtStatus STATUS_WORKING_SET_LIMIT_RANGE = 0x40000002;
const NtStatus STATUS_IMAGE_NOT_AT_BASE       = 0x40000003;
const NtStatus STATUS_RXACT_STATE_CREATED     = 0x40000004;
const NtStatus STATUS_SEGMENT_NOTIFICATION    = 0x40000005;

// =========================================================
// NtStatus — Warning (0x8000xxxx)
// =========================================================
const NtStatus STATUS_GUARD_PAGE_VIOLATION  = 0x80000001;
const NtStatus STATUS_DATATYPE_MISALIGNMENT = 0x80000002;
const NtStatus STATUS_BREAKPOINT            = 0x80000003;
const NtStatus STATUS_SINGLE_STEP          = 0x80000004;
const NtStatus STATUS_BUFFER_OVERFLOW       = 0x80000005;

// =========================================================
// NtStatus — Error (0xC000xxxx)
// =========================================================
const NtStatus STATUS_UNSUCCESSFUL             = 0xc0000001;
const NtStatus STATUS_NOT_IMPLEMENTED          = 0xc0000002;
const NtStatus STATUS_INVALID_INFO_CLASS       = 0xc0000003;
const NtStatus STATUS_INFO_LENGTH_MISMATCH     = 0xc0000004;
const NtStatus STATUS_ACCESS_VIOLATION         = 0xc0000005;
const NtStatus STATUS_IN_PAGE_ERROR            = 0xc0000006;
const NtStatus STATUS_INVALID_HANDLE           = 0xc0000008;
const NtStatus STATUS_INVALID_PARAMETER        = 0xc000000d;
const NtStatus STATUS_NO_SUCH_DEVICE           = 0xc000000e;
const NtStatus STATUS_NO_SUCH_FILE             = 0xc000000f;
const NtStatus STATUS_INVALID_DEVICE_REQUEST   = 0xc0000010;
const NtStatus STATUS_END_OF_FILE              = 0xc0000011;
const NtStatus STATUS_MORE_PROCESSING_REQUIRED = 0xc0000016;
const NtStatus STATUS_NO_MEMORY                = 0xc0000017;
const NtStatus STATUS_ACCESS_DENIED            = 0xc0000022;
const NtStatus STATUS_BUFFER_TOO_SMALL         = 0xc0000023;
const NtStatus STATUS_OBJECT_NAME_INVALID      = 0xc0000033;
const NtStatus STATUS_OBJECT_NAME_NOT_FOUND    = 0xc0000034;
const NtStatus STATUS_OBJECT_NAME_COLLISION    = 0xc0000035;
const NtStatus STATUS_OBJECT_PATH_NOT_FOUND    = 0xc000003a;
const NtStatus STATUS_SHARING_VIOLATION        = 0xc0000043;
const NtStatus STATUS_DELETE_PENDING           = 0xc0000056;
const NtStatus STATUS_PRIVILEGE_NOT_HELD       = 0xc0000061;
const NtStatus STATUS_NO_SUCH_USER             = 0xc0000064;
const NtStatus STATUS_LOGON_FAILURE            = 0xc000006d;
const NtStatus STATUS_PASSWORD_EXPIRED         = 0xc0000071;
const NtStatus STATUS_ACCOUNT_DISABLED         = 0xc0000072;
const NtStatus STATUS_INVALID_IMAGE_FORMAT     = 0xc000007b;
const NtStatus STATUS_DISK_FULL                = 0xc000007f;
const NtStatus STATUS_FILE_IS_A_DIRECTORY      = 0xc00000ba;
const NtStatus STATUS_NOT_SUPPORTED            = 0xc00000bb;
const NtStatus STATUS_INTERNAL_ERROR           = 0xc00000e5;
const NtStatus STATUS_DLL_NOT_FOUND            = 0xc0000135;
const NtStatus STATUS_ENTRYPOINT_NOT_FOUND     = 0xc0000139;
const NtStatus STATUS_CONTROL_C_EXIT           = 0xc000013a;
const NtStatus STATUS_DLL_INIT_FAILED          = 0xc0000142;
const NtStatus STATUS_PIPE_BROKEN              = 0xc000014b;
const NtStatus STATUS_REGISTRY_CORRUPT         = 0xc000014c;
const NtStatus STATUS_ACCOUNT_LOCKED_OUT       = 0xc0000234;

// =========================================================
// NtStatus macros
// =========================================================
macro bool nt_success(NtStatus status)     { return (uint(status) >> 30) == 0; }
macro bool nt_information(NtStatus status) { return (uint(status) >> 30) == 1; }
macro bool nt_warning(NtStatus status)     { return (uint(status) >> 30) == 2; }
macro bool nt_error(NtStatus status)       { return (uint(status) >> 30) == 3; }

// =========================================================
// Fundamental structures
// =========================================================
struct UnicodeString
{
    ushort  length;
    ushort  maximum_length;
    ushort* buffer;
}

struct AnsiString
{
    ushort length;
    ushort maximum_length;
    char*  buffer;
}

struct ListEntry
{
    ListEntry* flink;
    ListEntry* blink;
}

struct SingleListEntry
{
    SingleListEntry* next;
}

// IO_STATUS_BLOCK
// The first field is a union of NtStatus / void* (pointer-sized on x64)
struct IoStatusBlock
{
    union {
        NtStatus status;
        void*    pointer;
    }
    ulong information;  // ULONG_PTR — 8 bytes on x64
}

// =========================================================
// KEVENT
// =========================================================
alias EventType = int;
const EventType NOTIFICATION_EVENT    = 0;
const EventType SYNCHRONIZATION_EVENT = 1;

struct Kevent
{
    int[6] opaque;  // sizeof(KEVENT) == 24 on x64
}

extern fn void keInitializeEvent(
    Kevent*   event,
    EventType type,
    bool      state
) @cname("KeInitializeEvent");

extern fn int keSetEvent(
    Kevent* event,
    int     increment,
    bool    wait
) @cname("KeSetEvent");

extern fn int keResetEvent(
    Kevent* event
) @cname("KeResetEvent");

extern fn void keClearEvent(
    Kevent* event
) @cname("KeClearEvent");

// =========================================================
// KSPIN_LOCK
// =========================================================
extern fn void keInitializeSpinLock(
    KspinLock* spin_lock
) @cname("KeInitializeSpinLock");

extern fn void keAcquireSpinLock(
    KspinLock* spin_lock,
    Kirql*     old_irql
) @cname("KeAcquireSpinLock");

extern fn void keReleaseSpinLock(
    KspinLock* spin_lock,
    Kirql      new_irql
) @cname("KeReleaseSpinLock");

extern fn Kirql keAcquireSpinLockRaiseToDpc(
    KspinLock* spin_lock
) @cname("KeAcquireSpinLockRaiseToDpc");

// =========================================================
// FAST_MUTEX
// sizeof(FAST_MUTEX) == 32 on x64
// =========================================================
struct FastMutex
{
    int    count;       // LONG  — 4 bytes
    uint   _pad0;       // explicit padding to align owner to 8 bytes
    void*  owner;       // PKTHREAD — 8 bytes
    uint   contention;  // ULONG — 4 bytes
    uint   _pad1;       // padding before KEVENT (8-byte aligned)
    Kevent event;       // KEVENT (gate) — 24 bytes
    uint   old_irql;    // ULONG — 4 bytes
}

extern fn void exInitializeFastMutex(
    FastMutex* fast_mutex
) @cname("ExInitializeFastMutex");

extern fn void exAcquireFastMutex(
    FastMutex* fast_mutex
) @cname("ExAcquireFastMutex");

extern fn void exReleaseFastMutex(
    FastMutex* fast_mutex
) @cname("ExReleaseFastMutex");

extern fn bool exTryToAcquireFastMutex(
    FastMutex* fast_mutex
) @cname("ExTryToAcquireFastMutex");

// =========================================================
// OBJECT_ATTRIBUTES
// =========================================================
const uint OBJ_INHERIT            = 0x00000002;
const uint OBJ_PERMANENT          = 0x00000010;
const uint OBJ_EXCLUSIVE          = 0x00000020;
const uint OBJ_CASE_INSENSITIVE   = 0x00000040;
const uint OBJ_OPENIF             = 0x00000080;
const uint OBJ_OPENLINK           = 0x00000100;
const uint OBJ_KERNEL_HANDLE      = 0x00000200;
const uint OBJ_FORCE_ACCESS_CHECK = 0x00000400;

struct ObjectAttributes
{
    uint           length;
    Handle         root_directory;
    UnicodeString* object_name;
    uint           attributes;
    void*          security_descriptor;
    void*          security_quality_of_service;
}

// =========================================================
// Function pointer aliases
// =========================================================
alias DriverAddDevice  = fn NtStatus(DriverObject*, DeviceObject*);
alias DriverStartIo    = fn void(DeviceObject*, Irp*);
alias DriverInitialize = fn NtStatus(DriverObject*, UnicodeString*);
alias DriverUnload     = fn void(DriverObject*);
alias DriverDispatch   = fn NtStatus(DeviceObject*, Irp*);
alias CancelRoutine    = fn void(DeviceObject*, Irp*);
alias IoApcRoutine     = fn void(void*, IoStatusBlock*, ulong);  // last param ULONG_PTR
alias IoCompletion     = fn NtStatus(DeviceObject*, Irp*, void*);

// =========================================================
// DRIVER_EXTENSION / DRIVER_OBJECT
// =========================================================
const uint IRP_MJ_MAXIMUM_FUNCTION = 0x1b;

struct DriverExtension
{
    DriverObject*   driver_object;
    DriverAddDevice add_device;
    uint            count;
    UnicodeString   service_key_name;
}

struct DriverObject
{
    short            type;
    short            size;
    DeviceObject*    device_object;
    uint             flags;
    void*            driver_start;
    uint             driver_size;
    void*            driver_section;
    DriverExtension* driver_extension;
    UnicodeString    driver_name;
    UnicodeString*   hardware_database;
    FastIoDispatch*  fast_io_dispatch;
    DriverInitialize driver_init;
    DriverStartIo    driver_start_io;
    DriverUnload     driver_unload;
    DriverDispatch[IRP_MJ_MAXIMUM_FUNCTION + 1] major_function;
}

// =========================================================
// DRIVER_OBJECT flags
// =========================================================
const uint DRVO_REINIT_REGISTERED     = 0x00000008;
const uint DRVO_INITIALIZED           = 0x00000010;
const uint DRVO_BOOTREINIT_REGISTERED = 0x00000020;
const uint DRVO_LEGACY_RESOURCES      = 0x00000040;

// =========================================================
// DEVICE_OBJECT flags / characteristics
// =========================================================
const uint DO_VERIFY_VOLUME                 = 0x00000002;
const uint DO_BUFFERED_IO                   = 0x00000004;
const uint DO_EXCLUSIVE                     = 0x00000008;
const uint DO_DIRECT_IO                     = 0x00000010;
const uint DO_MAP_IO_BUFFER                 = 0x00000020;
const uint DO_DEVICE_HAS_NAME               = 0x00000040;
const uint DO_DEVICE_INITIALIZING           = 0x00000080;
const uint DO_SYSTEM_BOOT_PARTITION         = 0x00000100;
const uint DO_LONG_TERM_REQUESTS            = 0x00000200;
const uint DO_NEVER_LAST_DEVICE             = 0x00000400;
const uint DO_SHUTDOWN_REGISTERED           = 0x00000800;
const uint DO_BUS_ENUMERATED_DEVICE         = 0x00001000;
const uint DO_POWER_PAGABLE                 = 0x00002000;
const uint DO_POWER_INRUSH                  = 0x00004000;
const uint DO_LOW_PRIORITY_FILESYSTEM       = 0x00010000;
const uint DO_SUPPORTS_TRANSACTIONS         = 0x00040000;
const uint DO_FORCE_NEITHER_IO              = 0x00080000;
const uint DO_VOLUME_DEVICE_OBJECT          = 0x00100000;
const uint DO_SYSTEM_SYSTEM_PARTITION       = 0x00200000;
const uint DO_SYSTEM_CRITICAL_PARTITION     = 0x00400000;
const uint DO_DISALLOW_EXECUTE              = 0x00800000;
const uint DO_DEVICE_TO_BE_RESET            = 0x04000000;
const uint DO_DEVICE_IRP_REQUIRES_EXTENSION = 0x08000000;
const uint DO_DAX_VOLUME                    = 0x10000000;
const uint DO_BOOT_CRITICAL                 = 0x20000000;

const uint FILE_REMOVABLE_MEDIA                     = 0x00000001;
const uint FILE_READ_ONLY_DEVICE                    = 0x00000002;
const uint FILE_FLOPPY_DISKETTE                     = 0x00000004;
const uint FILE_WRITE_ONCE_MEDIA                    = 0x00000008;
const uint FILE_REMOTE_DEVICE                       = 0x00000010;
const uint FILE_DEVICE_IS_MOUNTED                   = 0x00000020;
const uint FILE_VIRTUAL_VOLUME                      = 0x00000040;
const uint FILE_AUTOGENERATED_DEVICE_NAME           = 0x00000080;
const uint FILE_DEVICE_SECURE_OPEN                  = 0x00000100;
const uint FILE_CHARACTERISTIC_PNP_DEVICE           = 0x00000800;
const uint FILE_CHARACTERISTIC_TS_DEVICE            = 0x00001000;
const uint FILE_CHARACTERISTIC_WEBDAV_DEVICE        = 0x00002000;
const uint FILE_CHARACTERISTIC_CSV                  = 0x00010000;
const uint FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL = 0x00020000;
const uint FILE_PORTABLE_DEVICE                     = 0x00040000;
const uint FILE_REMOTE_DEVICE_VSMB                  = 0x00080000;
const uint FILE_DEVICE_REQUIRE_SECURITY_CHECK       = 0x00100000;

// =========================================================
// FILE_DEVICE_xxx types
// =========================================================
const uint FILE_DEVICE_BEEP                = 0x00000001;
const uint FILE_DEVICE_CD_ROM              = 0x00000002;
const uint FILE_DEVICE_CD_ROM_FILE_SYSTEM  = 0x00000003;
const uint FILE_DEVICE_CONTROLLER          = 0x00000004;
const uint FILE_DEVICE_DATALINK            = 0x00000005;
const uint FILE_DEVICE_DFS                 = 0x00000006;
const uint FILE_DEVICE_DISK                = 0x00000007;
const uint FILE_DEVICE_DISK_FILE_SYSTEM    = 0x00000008;
const uint FILE_DEVICE_FILE_SYSTEM         = 0x00000009;
const uint FILE_DEVICE_INPORT_PORT         = 0x0000000a;
const uint FILE_DEVICE_KEYBOARD            = 0x0000000b;
const uint FILE_DEVICE_MAILSLOT            = 0x0000000c;
const uint FILE_DEVICE_MIDI_IN             = 0x0000000d;
const uint FILE_DEVICE_MIDI_OUT            = 0x0000000e;
const uint FILE_DEVICE_MOUSE               = 0x0000000f;
const uint FILE_DEVICE_MULTI_UNC_PROVIDER  = 0x00000010;
const uint FILE_DEVICE_NAMED_PIPE          = 0x00000011;
const uint FILE_DEVICE_NETWORK             = 0x00000012;
const uint FILE_DEVICE_NETWORK_BROWSER     = 0x00000013;
const uint FILE_DEVICE_NETWORK_FILE_SYSTEM = 0x00000014;
const uint FILE_DEVICE_NULL                = 0x00000015;
const uint FILE_DEVICE_PARALLEL_PORT       = 0x00000016;
const uint FILE_DEVICE_PHYSICAL_NETCARD    = 0x00000017;
const uint FILE_DEVICE_PRINTER             = 0x00000018;
const uint FILE_DEVICE_SCANNER             = 0x00000019;
const uint FILE_DEVICE_SERIAL_MOUSE_PORT   = 0x0000001a;
const uint FILE_DEVICE_SERIAL_PORT         = 0x0000001b;
const uint FILE_DEVICE_SCREEN              = 0x0000001c;
const uint FILE_DEVICE_SOUND               = 0x0000001d;
const uint FILE_DEVICE_STREAMS             = 0x0000001e;
const uint FILE_DEVICE_TAPE                = 0x0000001f;
const uint FILE_DEVICE_TAPE_FILE_SYSTEM    = 0x00000020;
const uint FILE_DEVICE_TRANSPORT           = 0x00000021;
const uint FILE_DEVICE_UNKNOWN             = 0x00000022;
const uint FILE_DEVICE_VIDEO               = 0x00000023;
const uint FILE_DEVICE_VIRTUAL_DISK        = 0x00000024;
const uint FILE_DEVICE_WAVE_IN             = 0x00000025;
const uint FILE_DEVICE_WAVE_OUT            = 0x00000026;
const uint FILE_DEVICE_8042_PORT           = 0x00000027;
const uint FILE_DEVICE_NETWORK_REDIRECTOR  = 0x00000028;
const uint FILE_DEVICE_BATTERY             = 0x00000029;
const uint FILE_DEVICE_BUS_EXTENDER        = 0x0000002a;
const uint FILE_DEVICE_MODEM               = 0x0000002b;
const uint FILE_DEVICE_VDM                 = 0x0000002c;
const uint FILE_DEVICE_MASS_STORAGE        = 0x0000002d;
const uint FILE_DEVICE_SMB                 = 0x0000002e;
const uint FILE_DEVICE_KS                  = 0x0000002f;
const uint FILE_DEVICE_CHANGER             = 0x00000030;
const uint FILE_DEVICE_SMARTCARD           = 0x00000031;
const uint FILE_DEVICE_ACPI                = 0x00000032;
const uint FILE_DEVICE_DVD                 = 0x00000033;
const uint FILE_DEVICE_FULLSCREEN_VIDEO    = 0x00000034;
const uint FILE_DEVICE_DFS_FILE_SYSTEM     = 0x00000035;
const uint FILE_DEVICE_DFS_VOLUME          = 0x00000036;
const uint FILE_DEVICE_SERENUM             = 0x00000037;
const uint FILE_DEVICE_TERMSRV             = 0x00000038;
const uint FILE_DEVICE_KSEC                = 0x00000039;
const uint FILE_DEVICE_FIPS                = 0x0000003a;
const uint FILE_DEVICE_INFINIBAND          = 0x0000003b;
const uint FILE_DEVICE_VMBUS               = 0x0000003e;
const uint FILE_DEVICE_CRYPT_PROVIDER      = 0x0000003f;
const uint FILE_DEVICE_WPD                 = 0x00000040;
const uint FILE_DEVICE_BLUETOOTH           = 0x00000041;
const uint FILE_DEVICE_MT_COMPOSITE        = 0x00000042;
const uint FILE_DEVICE_MT_TRANSPORT        = 0x00000043;
const uint FILE_DEVICE_BIOMETRIC           = 0x00000044;
const uint FILE_DEVICE_PMI                 = 0x00000045;
const uint FILE_DEVICE_EHSTOR              = 0x00000046;
const uint FILE_DEVICE_DEVAPI              = 0x00000047;
const uint FILE_DEVICE_GPIO                = 0x00000048;
const uint FILE_DEVICE_USBEX               = 0x00000049;
const uint FILE_DEVICE_CONSOLE             = 0x00000050;
const uint FILE_DEVICE_NFP                 = 0x00000051;
const uint FILE_DEVICE_SYSENV              = 0x00000052;
const uint FILE_DEVICE_VIRTUAL_BLOCK       = 0x00000053;
const uint FILE_DEVICE_POINT_OF_SERVICE    = 0x00000054;
const uint FILE_DEVICE_STORAGE_REPLICATION = 0x00000055;
const uint FILE_DEVICE_TRUST_ENV           = 0x00000056;
const uint FILE_DEVICE_UCM                 = 0x00000057;
const uint FILE_DEVICE_UCMTCPCI            = 0x00000058;
const uint FILE_DEVICE_PERSISTENT_MEMORY   = 0x00000059;
const uint FILE_DEVICE_NVDIMM              = 0x0000005a;
const uint FILE_DEVICE_HOLOGRAPHIC         = 0x0000005b;
const uint FILE_DEVICE_SDFXHCI             = 0x0000005c;
const uint FILE_DEVICE_UCMUCSI             = 0x0000005d;
const uint FILE_DEVICE_PRM                 = 0x0000005e;
const uint FILE_DEVICE_EVENT_COLLECTOR     = 0x0000005f;
const uint FILE_DEVICE_USB4                = 0x00000060;
const uint FILE_DEVICE_SOUNDWIRE           = 0x00000061;
const uint FILE_DEVICE_FABRIC_NVME         = 0x00000062;
const uint FILE_DEVICE_SVM                 = 0x00000063;
const uint FILE_DEVICE_HARDWARE_ACCELERATOR = 0x00000064;
const uint FILE_DEVICE_I3C                 = 0x00000065;

// =========================================================
// DEVICE_OBJECT
// The queue field is a KDEVICE_QUEUE (not a plain union);
// on x64 sizeof(KDEVICE_QUEUE) == 32.  We keep it opaque.
// =========================================================
struct DeviceObject
{
    short         type;
    short         size;
    int           reference_count;
    DriverObject* driver_object;
    DeviceObject* next_device;
    DeviceObject* attached_device;
    Irp*          current_irp;
    IoTimer*      timer;
    uint          flags;
    uint          characteristics;
    Vpb*          vpb;
    void*         device_extension;
    uint          device_type;
    char          stack_size;
    char[3]       _pad0;             // padding — stack_size is CCHAR, next field 8-aligned
    ulong[4]      device_queue;      // KDEVICE_QUEUE — 32 bytes on x64 (opaque)
    ulong[4]      dpc;               // KDPC — 32 bytes on x64 (opaque)
    uint          active_thread_count;
    SecurityDescriptor security_descriptor;
    Kevent        device_lock;
    ushort        sector_size;
    ushort        spare1;
    DevObjExtension device_object_extension;
    void*         reserved;
}

// =========================================================
// FILE_OBJECT
// =========================================================
struct FileObject
{
    short         type;
    short         size;
    DeviceObject* device_object;
    Vpb*          vpb;
    void*         fs_context;
    void*         fs_context2;
    void*         section_object_pointer;
    void*         private_cache_map;
    NtStatus      final_status;
    uint          _pad0;             // pad NtStatus (4 bytes) up to 8 before pointer
    FileObject*   related_file_object;
    bool          lock_operation;
    bool          delete_pending;
    bool          read_access;
    bool          write_access;
    bool          delete_access;
    bool          shared_read;
    bool          shared_write;
    bool          shared_delete;
    uint          flags;
    UnicodeString file_name;
    long          current_byte_offset;  // LARGE_INTEGER — 8 bytes
    uint          waiters;
    uint          busy;
    void*         last_lock;
    Kevent        lock;
    Kevent        event;
    void*         completion_context;
    KspinLock     irp_list_lock;
    ListEntry     irp_list;
    void*         file_object_extension;
}

// =========================================================
// IRP_MJ codes
// =========================================================
const uint IRP_MJ_CREATE                   = 0x00;
const uint IRP_MJ_CREATE_NAMED_PIPE        = 0x01;
const uint IRP_MJ_CLOSE                    = 0x02;
const uint IRP_MJ_READ                     = 0x03;
const uint IRP_MJ_WRITE                    = 0x04;
const uint IRP_MJ_QUERY_INFORMATION        = 0x05;
const uint IRP_MJ_SET_INFORMATION          = 0x06;
const uint IRP_MJ_QUERY_EA                 = 0x07;
const uint IRP_MJ_SET_EA                   = 0x08;
const uint IRP_MJ_FLUSH_BUFFERS            = 0x09;
const uint IRP_MJ_QUERY_VOLUME_INFORMATION = 0x0a;
const uint IRP_MJ_SET_VOLUME_INFORMATION   = 0x0b;
const uint IRP_MJ_DIRECTORY_CONTROL        = 0x0c;
const uint IRP_MJ_FILE_SYSTEM_CONTROL      = 0x0d;
const uint IRP_MJ_DEVICE_CONTROL           = 0x0e;
const uint IRP_MJ_INTERNAL_DEVICE_CONTROL  = 0x0f;
const uint IRP_MJ_SHUTDOWN                 = 0x10;
const uint IRP_MJ_LOCK_CONTROL             = 0x11;
const uint IRP_MJ_CLEANUP                  = 0x12;
const uint IRP_MJ_CREATE_MAILSLOT          = 0x13;
const uint IRP_MJ_QUERY_SECURITY           = 0x14;
const uint IRP_MJ_SET_SECURITY             = 0x15;
const uint IRP_MJ_POWER                    = 0x16;
const uint IRP_MJ_SYSTEM_CONTROL           = 0x17;
const uint IRP_MJ_DEVICE_CHANGE            = 0x18;
const uint IRP_MJ_QUERY_QUOTA              = 0x19;
const uint IRP_MJ_SET_QUOTA                = 0x1a;
const uint IRP_MJ_PNP                      = 0x1b;

// =========================================================
// IRP_MN — PnP minor codes
// =========================================================
const uint IRP_MN_START_DEVICE                 = 0x00;
const uint IRP_MN_QUERY_REMOVE_DEVICE          = 0x01;
const uint IRP_MN_REMOVE_DEVICE                = 0x02;
const uint IRP_MN_CANCEL_REMOVE_DEVICE         = 0x03;
const uint IRP_MN_STOP_DEVICE                  = 0x04;
const uint IRP_MN_QUERY_STOP_DEVICE            = 0x05;
const uint IRP_MN_CANCEL_STOP_DEVICE           = 0x06;
const uint IRP_MN_QUERY_DEVICE_RELATIONS       = 0x07;
const uint IRP_MN_QUERY_INTERFACE              = 0x08;
const uint IRP_MN_QUERY_CAPABILITIES           = 0x09;
const uint IRP_MN_QUERY_RESOURCES              = 0x0a;
const uint IRP_MN_QUERY_RESOURCE_REQUIREMENTS  = 0x0b;
const uint IRP_MN_QUERY_DEVICE_TEXT            = 0x0c;
const uint IRP_MN_FILTER_RESOURCE_REQUIREMENTS = 0x0d;
const uint IRP_MN_READ_CONFIG                  = 0x0f;
const uint IRP_MN_WRITE_CONFIG                 = 0x10;
const uint IRP_MN_EJECT                        = 0x11;
const uint IRP_MN_SET_LOCK                     = 0x12;
const uint IRP_MN_QUERY_ID                     = 0x13;
const uint IRP_MN_QUERY_PNP_DEVICE_STATE       = 0x14;
const uint IRP_MN_QUERY_BUS_INFORMATION        = 0x15;
const uint IRP_MN_DEVICE_USAGE_NOTIFICATION    = 0x16;
const uint IRP_MN_SURPRISE_REMOVAL             = 0x17;

// =========================================================
// IRP_MN — Power minor codes
// =========================================================
const uint IRP_MN_WAIT_WAKE      = 0x00;
const uint IRP_MN_POWER_SEQUENCE = 0x01;
const uint IRP_MN_SET_POWER      = 0x02;
const uint IRP_MN_QUERY_POWER    = 0x03;

// =========================================================
// IO_STACK_LOCATION parameter sub-structs
// =========================================================
struct IoStackCreate
{
    uint   security_context;  // PIO_SECURITY_CONTEXT — kept as uint (pointer in real WDK, but often cast)
    uint   options;
    ushort file_attributes;
    ushort share_access;
    uint   ea_length;
}

struct IoStackRead
{
    uint length;
    uint key;
    long byte_offset;  // LARGE_INTEGER — 8 bytes
}

struct IoStackWrite
{
    uint length;
    uint key;
    long byte_offset;  // LARGE_INTEGER — 8 bytes
}

struct IoStackQueryDirectory
{
    uint           length;
    UnicodeString* file_name;
    uint           file_information_class;
    uint           file_index;
}

struct IoStackDeviceIoControl
{
    uint  output_buffer_length;
    uint  input_buffer_length;
    uint  io_control_code;
    uint  _pad;              // explicit pad — next field is pointer-aligned
    void* type3_input_buffer;
}

// The Parameters union inside IO_STACK_LOCATION.
// All sub-structs must fit within the largest member (IoStackRead/Write at 16 bytes).
union IoStackParameters
{
    IoStackCreate          create;
    IoStackRead            read;
    IoStackWrite           write;
    IoStackQueryDirectory  query_directory;
    IoStackDeviceIoControl device_io_control;
}

// =========================================================
// IO_STACK_LOCATION
// =========================================================
struct IoStackLocation
{
    char              major_function;
    char              minor_function;
    char              flags;
    char              control;
    IoStackParameters parameters;
    DeviceObject*     device_object;
    FileObject*       file_object;
    IoCompletion      completion_routine;
    void*             context;
}

// =========================================================
// AssociatedIrp / IrpOverlay / IrpTail
// Kept as named aliases for documentation only.
// They are NOT used as field types inside Irp — they are
// inlined as anonymous unions directly in the struct below.
// =========================================================

alias KProcessorMode = char;

enum Mode
{
    KERNEL_MODE,
    USER_MODE,
    MAXIMUM_MODE
}

struct KDeviceQueueEntry
{
    ListEntry list_entry;
    uint      sort_key;
    bool      inserted;
}

struct KApc
{
    char  type;
    char  all_flags;
    char  size;
    char  spare_byte1;
    uint  spare_long0;
    void* thread;
    ListEntry apc_list_entry;
    void*[3]  reserved;
    void* normal_context;
    void* system_argument1;
    void* system_argument2;
    char  apc_state_index;
    char  apc_mode;
    bool  inserted;
}

struct Irp
{
    short  type;
    ushort size;
    void*  mdl_address;
    uint   flags;

    union associated_irp
    {
        Irp*  master_irp;
        int   irp_count;
        void* system_buffer;
    }

    ListEntry      thread_list_entry;
    IoStatusBlock  io_status;
    char           requestor_mode;
    bool           pending_returned;
    char           stack_count;
    char           current_location;
    bool           cancel;
    Kirql          cancel_irql;
    char           apc_environment;
    char           allocation_flags;

    union
    {
        IoStatusBlock* user_iosb;
        void*          io_ring_context;
    }

    void* user_event;

    union overlay
    {
        struct asynchronous_parameters
        {
            union
            {
                IoApcRoutine user_apc_routine;
                void*        issuing_process;
            }
            union
            {
                void* user_apc_context;
                void* io_ring;
            }
        }
        long allocation_size;
    }

    CancelRoutine cancel_routine;
    void*         user_buffer;

    union tail
    {
        struct overlay
        {
            union
            {
                KDeviceQueueEntry device_queue_entry;
                struct
                {
                    void*[4] driver_context;
                }
            }
            void*  thread;
            char*  auxiliary_buffer;
            struct
            {
                ListEntry list_entry;
                union
                {
                    IoStackLocation* current_stack_location;
                    uint             packet_type;
                }
            }
            void*  original_file_object;
        }
        KApc  apc;
        void* completion_key;
    }
}

// =========================================================
// IO priority boost increments
// =========================================================
const char IO_NO_INCREMENT         = 0;
const char IO_CD_ROM_INCREMENT     = 1;
const char IO_DISK_INCREMENT       = 1;
const char IO_KEYBOARD_INCREMENT   = 6;
const char IO_MAILSLOT_INCREMENT   = 2;
const char IO_MOUSE_INCREMENT      = 6;
const char IO_NAMED_PIPE_INCREMENT = 2;
const char IO_NETWORK_INCREMENT    = 2;
const char IO_PARALLEL_INCREMENT   = 1;
const char IO_SERIAL_INCREMENT     = 2;
const char IO_SOUND_INCREMENT      = 8;
const char IO_VIDEO_INCREMENT      = 1;

// =========================================================
// CTL_CODE helper
// =========================================================
const uint METHOD_BUFFERED   = 0;
const uint METHOD_IN_DIRECT  = 1;
const uint METHOD_OUT_DIRECT = 2;
const uint METHOD_NEITHER    = 3;

const uint FILE_ANY_ACCESS   = 0;
const uint FILE_READ_ACCESS  = 0x0001;
const uint FILE_WRITE_ACCESS = 0x0002;

macro uint ctl_code(uint device_type, uint function, uint method, uint access)
{
    return (device_type << 16) | (access << 14) | (function << 2) | method;
}

// =========================================================
// MDL flags
// =========================================================
const uint MDL_MAPPED_TO_SYSTEM_VA     = 0x0001;
const uint MDL_PAGES_LOCKED            = 0x0002;
const uint MDL_SOURCE_IS_NONPAGED_POOL = 0x0004;
const uint MDL_ALLOCATED_FIXED_SIZE    = 0x0008;
const uint MDL_PARTIAL                 = 0x0010;
const uint MDL_PARTIAL_HAS_BEEN_MAPPED = 0x0020;
const uint MDL_IO_PAGE_READ            = 0x0040;
const uint MDL_WRITE_OPERATION         = 0x0080;
const uint MDL_IO_SPACE                = 0x0800;
const uint MDL_NETWORK_HEADER          = 0x1000;
const uint MDL_MAPPING_CAN_FAIL        = 0x2000;
const uint MDL_ALLOCATED_MUST_SUCCEED  = 0x4000;

alias LockOperation = int;
const LockOperation IO_READ_ACCESS   = 0;
const LockOperation IO_WRITE_ACCESS  = 1;
const LockOperation IO_MODIFY_ACCESS = 2;

// =========================================================
// Pool flags  (POOL_FLAGS — ULONG64 = 8 bytes)
// =========================================================
const ulong POOL_FLAG_USE_QUOTA         = 0x0000000000000001;
const ulong POOL_FLAG_UNINITIALIZED     = 0x0000000000000002;
const ulong POOL_FLAG_SESSION           = 0x0000000000000004;
const ulong POOL_FLAG_CACHE_ALIGNED     = 0x0000000000000008;
const ulong POOL_FLAG_RESERVED1         = 0x0000000000000010;
const ulong POOL_FLAG_RAISE_ON_FAILURE  = 0x0000000000000020;
const ulong POOL_FLAG_NON_PAGED         = 0x0000000000000040;
const ulong POOL_FLAG_NON_PAGED_EXECUTE = 0x0000000000000080;
const ulong POOL_FLAG_PAGED             = 0x0000000000000100;
const ulong POOL_FLAG_RESERVED2         = 0x0000000000000200;
const ulong POOL_FLAG_RESERVED3         = 0x0000000000000400;
const ulong POOL_FLAG_SPECIAL_POOL      = 0x0000000100000000;

// =========================================================
// Registry constants
// =========================================================
const uint KEY_QUERY_VALUE        = 0x0001;
const uint KEY_SET_VALUE          = 0x0002;
const uint KEY_CREATE_SUB_KEY     = 0x0004;
const uint KEY_ENUMERATE_SUB_KEYS = 0x0008;
const uint KEY_NOTIFY             = 0x0010;
const uint KEY_CREATE_LINK        = 0x0020;
const uint KEY_READ               = 0x20019;
const uint KEY_WRITE              = 0x20006;
const uint KEY_ALL_ACCESS         = 0xf003f;

const uint REG_NONE                       = 0;
const uint REG_SZ                         = 1;
const uint REG_EXPAND_SZ                  = 2;
const uint REG_BINARY                     = 3;
const uint REG_DWORD                      = 4;
const uint REG_DWORD_LITTLE_ENDIAN        = 4;
const uint REG_DWORD_BIG_ENDIAN           = 5;
const uint REG_LINK                       = 6;
const uint REG_MULTI_SZ                   = 7;
const uint REG_RESOURCE_LIST              = 8;
const uint REG_FULL_RESOURCE_DESCRIPTOR   = 9;
const uint REG_RESOURCE_REQUIREMENTS_LIST = 10;
const uint REG_QWORD                      = 11;
const uint REG_QWORD_LITTLE_ENDIAN        = 11;

// =========================================================
// File access / sharing / disposition / options
// =========================================================
const uint GENERIC_READ    = 0x80000000;
const uint GENERIC_WRITE   = 0x40000000;
const uint GENERIC_EXECUTE = 0x20000000;
const uint GENERIC_ALL     = 0x10000000;

const uint FILE_SHARE_READ   = 0x00000001;
const uint FILE_SHARE_WRITE  = 0x00000002;
const uint FILE_SHARE_DELETE = 0x00000004;

const uint FILE_SUPERSEDE    = 0x00000000;
const uint FILE_OPEN         = 0x00000001;
const uint FILE_CREATE       = 0x00000002;
const uint FILE_OPEN_IF      = 0x00000003;
const uint FILE_OVERWRITE    = 0x00000004;
const uint FILE_OVERWRITE_IF = 0x00000005;

const uint FILE_DIRECTORY_FILE            = 0x00000001;
const uint FILE_WRITE_THROUGH             = 0x00000002;
const uint FILE_SEQUENTIAL_ONLY           = 0x00000004;
const uint FILE_NO_INTERMEDIATE_BUFFERING = 0x00000008;
const uint FILE_SYNCHRONOUS_IO_ALERT      = 0x00000010;
const uint FILE_SYNCHRONOUS_IO_NONALERT   = 0x00000020;
const uint FILE_NON_DIRECTORY_FILE        = 0x00000040;
const uint FILE_NO_EA_KNOWLEDGE           = 0x00000200;
const uint FILE_RANDOM_ACCESS             = 0x00000800;
const uint FILE_DELETE_ON_CLOSE           = 0x00001000;
const uint FILE_OPEN_BY_FILE_ID           = 0x00002000;
const uint FILE_OPEN_FOR_BACKUP_INTENT    = 0x00004000;

// =========================================================
// KwaitReason
// =========================================================
alias KwaitReason = int;
const KwaitReason EXECUTIVE           = 0;
const KwaitReason FREE_PAGE           = 1;
const KwaitReason PAGE_IN             = 2;
const KwaitReason POOL_ALLOCATION     = 3;
const KwaitReason DELAY_EXECUTION     = 4;
const KwaitReason SUSPENDED           = 5;
const KwaitReason USER_REQUEST        = 6;
const KwaitReason WR_EXECUTIVE        = 7;
const KwaitReason WR_FREE_PAGE        = 8;
const KwaitReason WR_PAGE_IN          = 9;
const KwaitReason WR_POOL_ALLOCATION  = 10;
const KwaitReason WR_DELAY_EXECUTION  = 11;
const KwaitReason WR_SUSPENDED        = 12;
const KwaitReason WR_USER_REQUEST     = 13;
const KwaitReason WR_QUEUE            = 15;
const KwaitReason WR_LPC_RECEIVE      = 16;
const KwaitReason WR_LPC_REPLY        = 17;
const KwaitReason WR_VIRTUAL_MEMORY   = 18;
const KwaitReason WR_FAST_MUTEX       = 34;
const KwaitReason WR_GUARDED_MUTEX    = 35;
const KwaitReason WR_RUNDOWN          = 36;
const KwaitReason MAXIMUM_WAIT_REASON = 37;

// =========================================================
// Miscellaneous structures
// =========================================================
struct TimeFields
{
    short year;
    short month;
    short day;
    short hour;
    short minute;
    short second;
    short milliseconds;
    short weekday;
}

struct ProcessorNumber
{
    ushort group;
    char   number;
    char   reserved;
}

struct OsVersionInfo
{
    uint        os_version_info_size;
    uint        major_version;
    uint        minor_version;
    uint        build_number;
    uint        platform_id;
    ushort[128] csd_version;
}

// =========================================================
// Ke — Processor / Time / Wait
// =========================================================
extern fn Kirql keGetCurrentIrql()
    @cname("KeGetCurrentIrql");

extern fn uint keGetCurrentProcessorNumberEx(
    ProcessorNumber* processor_number
) @cname("KeGetCurrentProcessorNumberEx");

extern fn void keQuerySystemTimePrecise(
    LargeInteger* current_time
) @cname("KeQuerySystemTimePrecise");

extern fn NtStatus keWaitForSingleObject(
    void*         object,
    KwaitReason   wait_reason,
    char          wait_mode,
    bool          alertable,
    LargeInteger* timeout
) @cname("KeWaitForSingleObject");

extern fn NtStatus keWaitForMultipleObjects(
    uint          count,
    void**        object,
    int           wait_type,    // WaitAny=0, WaitAll=1
    KwaitReason   wait_reason,
    char          wait_mode,
    bool          alertable,
    LargeInteger* timeout,
    void*         wait_block_array
) @cname("KeWaitForMultipleObjects");

extern fn NtStatus keDelayExecutionThread(
    char          wait_mode,
    bool          alertable,
    LargeInteger* interval
) @cname("KeDelayExecutionThread");

extern fn void keBugCheck(
    uint bug_check_code
) @cname("KeBugCheck");

extern fn void keBugCheckEx(
    uint  bug_check_code,
    ulong p1,   // ULONG_PTR — 8 bytes on x64
    ulong p2,
    ulong p3,
    ulong p4
) @cname("KeBugCheckEx");

// =========================================================
// Ke — IRQL management
// =========================================================
extern fn Kirql keRaiseIrqlToDpcLevel() @cname("KeRaiseIrqlToDpcLevel");

extern fn void keRaiseIrql(
    Kirql  new_irql,
    Kirql* old_irql
) @cname("KeRaiseIrql");

extern fn void keLowerIrql(
    Kirql new_irql
) @cname("KeLowerIrql");

extern fn void keEnterCriticalRegion()  @cname("KeEnterCriticalRegion");
extern fn void keLeaveCriticalRegion()  @cname("KeLeaveCriticalRegion");
extern fn void keEnterGuardedRegion()   @cname("KeEnterGuardedRegion");
extern fn void keLeaveGuardedRegion()   @cname("KeLeaveGuardedRegion");

// =========================================================
// Ke — Processor affinity / count
// =========================================================
extern fn Kaffinity keQueryActiveProcessors()
    @cname("KeQueryActiveProcessors");

extern fn uint keQueryActiveProcessorCountEx(
    ushort group_number
) @cname("KeQueryActiveProcessorCountEx");

extern fn uint keQueryMaximumProcessorCountEx(
    ushort group_number
) @cname("KeQueryMaximumProcessorCountEx");

// =========================================================
// Ke — Time queries
// =========================================================
extern fn void keQuerySystemTime(
    LargeInteger* current_time
) @cname("KeQuerySystemTime");

extern fn void keQueryTickCount(
    LargeInteger* tick_count
) @cname("KeQueryTickCount");

extern fn uint  keQueryTimeIncrement()      // ULONG — 4 bytes
    @cname("KeQueryTimeIncrement");

extern fn ulong keQueryInterruptTime()      // ULONGLONG — 8 bytes
    @cname("KeQueryInterruptTime");

extern fn ulong keQueryInterruptTimePrecise(
    ulong* qpc_time_stamp                   // ULONG64* — 8 bytes
) @cname("KeQueryInterruptTimePrecise");

extern fn ulong keQueryUnbiasedInterruptTime()  // ULONGLONG — 8 bytes
    @cname("KeQueryUnbiasedInterruptTime");

// =========================================================
// Ke — Bugcheck codes (common subset)
// =========================================================
const uint IRQL_NOT_LESS_OR_EQUAL                     = 0x0000000a;
const uint KMODE_EXCEPTION_NOT_HANDLED                = 0x0000001e;
const uint SYSTEM_SERVICE_EXCEPTION                   = 0x0000003b;
const uint PAGE_FAULT_IN_NONPAGED_AREA                = 0x00000050;
const uint DRIVER_IRQL_NOT_LESS_OR_EQUAL              = 0x000000d1;
const uint DRIVER_PAGE_FAULT_BEYOND_END_OF_ALLOCATION = 0x000000e7;
const uint ATTEMPTED_WRITE_TO_READONLY_MEMORY         = 0x000000be;
const uint DRIVER_CORRUPTED_EXPOOL                    = 0x000000c5;

// =========================================================
// Ke — Semaphore  (sizeof(KSEMAPHORE) == 20 on x64)
// =========================================================
struct Ksemaphore
{
    int[5] opaque;
}

extern fn void keInitializeSemaphore(
    Ksemaphore* semaphore,
    int         count,
    int         limit
) @cname("KeInitializeSemaphore");

extern fn int keReleaseSemaphore(
    Ksemaphore* semaphore,
    int         increment,
    int         adjustment,
    bool        wait
) @cname("KeReleaseSemaphore");

// =========================================================
// Ke — Mutex  (sizeof(KMUTEX) == 32 on x64)
// =========================================================
struct Kmutex
{
    int[8] opaque;
}

extern fn void keInitializeMutex(
    Kmutex* mutex,
    uint    level
) @cname("KeInitializeMutex");

extern fn int keReleaseMutex(
    Kmutex* mutex,
    bool    wait
) @cname("KeReleaseMutex");

extern fn int keReadStateMutex(
    Kmutex* mutex
) @cname("KeReadStateMutex");

// =========================================================
// Ke — Timer  (sizeof(KTIMER) == 40 on x64)
// =========================================================
struct Ktimer
{
    int[10] opaque;
}

alias TimerType = int;
const TimerType NOTIFICATION_TIMER    = 0;
const TimerType SYNCHRONIZATION_TIMER = 1;

extern fn void keInitializeTimer(
    Ktimer* timer
) @cname("KeInitializeTimer");

extern fn void keInitializeTimerEx(
    Ktimer*   timer,
    TimerType type
) @cname("KeInitializeTimerEx");

extern fn bool keSetTimer(
    Ktimer*      timer,
    LargeInteger due_time,  // LARGE_INTEGER by value — 8 bytes
    void*        dpc
) @cname("KeSetTimer");

extern fn bool keSetTimerEx(
    Ktimer*      timer,
    LargeInteger due_time,
    int          period,    // LONG — 4 bytes
    void*        dpc
) @cname("KeSetTimerEx");

extern fn bool keCancelTimer(
    Ktimer* timer
) @cname("KeCancelTimer");

extern fn bool keReadStateTimer(
    Ktimer* timer
) @cname("KeReadStateTimer");

// =========================================================
// Ke — DPC  (sizeof(KDPC) == 32 on x64)
// =========================================================
alias DpcRoutine = fn void(void* dpc, void* deferred_context, void* sa1, void* sa2);

struct Kdpc
{
    int[8] opaque;
}

extern fn void keInitializeDpc(
    Kdpc*      dpc,
    DpcRoutine deferred_routine,
    void*      deferred_context
) @cname("KeInitializeDpc");

extern fn bool keInsertQueueDpc(
    Kdpc* dpc,
    void* system_argument1,
    void* system_argument2
) @cname("KeInsertQueueDpc");

extern fn bool keRemoveQueueDpc(
    Kdpc* dpc
) @cname("KeRemoveQueueDpc");

extern fn void keFlushQueuedDpcs() @cname("KeFlushQueuedDpcs");

extern fn void keSetImportanceDpc(
    Kdpc* dpc,
    int   importance
) @cname("KeSetImportanceDpc");

extern fn void keSetTargetProcessorDpcEx(
    Kdpc*            dpc,
    ProcessorNumber* proc_number
) @cname("KeSetTargetProcessorDpcEx");

// =========================================================
// Rtl — Time / String / Memory
// =========================================================
extern fn void rtlTimeToTimeFields(
    LargeInteger* time,
    TimeFields*   time_fields
) @cname("RtlTimeToTimeFields");

extern fn void exSystemTimeToLocalTime(
    LargeInteger* system_time,
    LargeInteger* local_time
) @cname("ExSystemTimeToLocalTime");

extern fn void rtlInitUnicodeString(
    UnicodeString* destination_string,
    ushort*        source_string
) @cname("RtlInitUnicodeString");

extern fn void rtlCopyUnicodeString(
    UnicodeString* destination_string,
    UnicodeString* source_string
) @cname("RtlCopyUnicodeString");

extern fn bool rtlEqualUnicodeString(
    UnicodeString* string1,
    UnicodeString* string2,
    bool           case_insensitive
) @cname("RtlEqualUnicodeString");

extern fn int rtlCompareUnicodeString(
    UnicodeString* string1,
    UnicodeString* string2,
    bool           case_insensitive
) @cname("RtlCompareUnicodeString");

extern fn NtStatus rtlAppendUnicodeStringToString(
    UnicodeString* destination,
    UnicodeString* source
) @cname("RtlAppendUnicodeStringToString");

extern fn NtStatus rtlAppendUnicodeToString(
    UnicodeString* destination,
    ushort*        source
) @cname("RtlAppendUnicodeToString");

extern fn NtStatus rtlIntegerToUnicodeString(
    uint           value,
    uint           base,
    UnicodeString* string
) @cname("RtlIntegerToUnicodeString");

extern fn NtStatus rtlUnicodeStringToInteger(
    UnicodeString* string,
    uint           base,
    uint*          value
) @cname("RtlUnicodeStringToInteger");

extern fn void* rtlMoveMemory(
    void* destination,
    void* source,
    usz   length
) @cname("RtlMoveMemory");

extern fn void rtlZeroMemory(
    void* destination,
    usz   length
) @cname("RtlZeroMemory");

extern fn void rtlFillMemory(
    void* destination,
    usz   length,
    char  fill
) @cname("RtlFillMemory");

extern fn usz rtlCompareMemory(
    void* source1,
    void* source2,
    usz   length
) @cname("RtlCompareMemory");

extern fn bool rtlEqualMemory(
    void* source1,
    void* source2,
    usz   length
) @cname("RtlEqualMemory");

extern fn NtStatus rtlGetVersion(
    OsVersionInfo* version_information
) @cname("RtlGetVersion");

// =========================================================
// Rtl — ANSI / Unicode conversion
// =========================================================
extern fn void rtlInitAnsiString(
    AnsiString* destination_string,
    char*       source_string
) @cname("RtlInitAnsiString");

extern fn NtStatus rtlAnsiStringToUnicodeString(
    UnicodeString* destination_string,
    AnsiString*    source_string,
    bool           allocate_destination_string
) @cname("RtlAnsiStringToUnicodeString");

extern fn NtStatus rtlUnicodeStringToAnsiString(
    AnsiString*    destination_string,
    UnicodeString* source_string,
    bool           allocate_destination_string
) @cname("RtlUnicodeStringToAnsiString");

extern fn void rtlFreeAnsiString(
    AnsiString* ansi_string
) @cname("RtlFreeAnsiString");

extern fn void rtlFreeUnicodeString(
    UnicodeString* unicode_string
) @cname("RtlFreeUnicodeString");

extern fn NtStatus rtlDuplicateUnicodeString(
    uint           flags,
    UnicodeString* string_in,
    UnicodeString* string_out
) @cname("RtlDuplicateUnicodeString");

extern fn bool rtlPrefixUnicodeString(
    UnicodeString* string1,
    UnicodeString* string2,
    bool           case_insensitive
) @cname("RtlPrefixUnicodeString");

extern fn NtStatus rtlUpcaseUnicodeString(
    UnicodeString* destination_string,
    UnicodeString* source_string,
    bool           allocate_destination_string
) @cname("RtlUpcaseUnicodeString");

// =========================================================
// Rtl — GUID
// =========================================================
struct Guid
{
    uint    data1;
    ushort  data2;
    ushort  data3;
    char[8] data4;
}

extern fn NtStatus rtlStringFromGuid(
    Guid*          guid,
    UnicodeString* guid_string
) @cname("RtlStringFromGUID");

extern fn NtStatus rtlGuidFromString(
    UnicodeString* guid_string,
    Guid*          guid
) @cname("RtlGUIDFromString");

// =========================================================
// Rtl — AVL generic table
// sizeof(RTL_AVL_TABLE) == 72 on x64  →  9 × ulong
// =========================================================
alias TableCompareRoutine  = fn int(void* table, void* first_struct, void* second_struct);
alias TableAllocateRoutine = fn void*(void* table, usz byte_size);
alias TableFreeRoutine     = fn void(void* table, void* buffer);

struct RtlAvlTable
{
    ulong[9] opaque;  // 72 bytes on x64
}

extern fn void rtlInitializeGenericTableAvl(
    RtlAvlTable*         table,
    TableCompareRoutine  compare_routine,
    TableAllocateRoutine allocate_routine,
    TableFreeRoutine     free_routine,
    void*                table_context
) @cname("RtlInitializeGenericTableAvl");

extern fn void* rtlInsertElementGenericTableAvl(
    RtlAvlTable* table,
    void*        buffer,
    uint         buffer_size,
    bool*        new_element
) @cname("RtlInsertElementGenericTableAvl");

extern fn bool rtlDeleteElementGenericTableAvl(
    RtlAvlTable* table,
    void*        buffer
) @cname("RtlDeleteElementGenericTableAvl");

extern fn void* rtlLookupElementGenericTableAvl(
    RtlAvlTable* table,
    void*        buffer
) @cname("RtlLookupElementGenericTableAvl");

extern fn void* rtlEnumerateGenericTableAvl(
    RtlAvlTable* table,
    bool         restart
) @cname("RtlEnumerateGenericTableAvl");

extern fn uint rtlNumberGenericTableElementsAvl(
    RtlAvlTable* table
) @cname("RtlNumberGenericTableElementsAvl");

// =========================================================
// Rtl — Bitmap
// =========================================================
struct RtlBitmap
{
    uint  size_of_bit_map;
    uint* buffer;
}

extern fn void rtlInitializeBitMap(
    RtlBitmap* bit_map_header,
    uint*      bit_map_buffer,
    uint       size_of_bit_map
) @cname("RtlInitializeBitMap");

extern fn void rtlClearAllBits(RtlBitmap* h) @cname("RtlClearAllBits");
extern fn void rtlSetAllBits(RtlBitmap* h)   @cname("RtlSetAllBits");

extern fn void rtlSetBit(
    RtlBitmap* bit_map_header,
    uint       bit_number
) @cname("RtlSetBit");

extern fn void rtlClearBit(
    RtlBitmap* bit_map_header,
    uint       bit_number
) @cname("RtlClearBit");

extern fn bool rtlTestBit(
    RtlBitmap* bit_map_header,
    uint       bit_number
) @cname("RtlTestBit");

extern fn uint rtlFindFirstRunClear(
    RtlBitmap* bit_map_header,
    uint*      starting_index
) @cname("RtlFindFirstRunClear");

extern fn uint rtlFindClearBitsAndSet(
    RtlBitmap* bit_map_header,
    uint       number_to_find,
    uint       hint_index
) @cname("RtlFindClearBitsAndSet");

extern fn uint rtlNumberOfSetBits(RtlBitmap* h)   @cname("RtlNumberOfSetBits");
extern fn uint rtlNumberOfClearBits(RtlBitmap* h) @cname("RtlNumberOfClearBits");

// =========================================================
// Rtl — CRC / hash
// =========================================================
extern fn uint  rtlComputeCrc32(
    uint  partial_crc,
    void* buffer,
    usz   length
) @cname("RtlComputeCrc32");

extern fn ulong rtlComputeCrc64(   // ULONGLONG — 8 bytes
    ulong partial_crc,
    void* buffer,
    usz   length
) @cname("RtlComputeCrc64");

// =========================================================
// Rtl — Random / entropy
// =========================================================
extern fn uint rtlRandom(uint* seed)   @cname("RtlRandom");
extern fn uint rtlRandomEx(uint* seed) @cname("RtlRandomEx");

extern fn NtStatus rtlGenRandom(
    void* random_buffer,
    uint  random_buffer_length
) @cname("RtlGenRandom");

// =========================================================
// Rtl — Stack capture
// =========================================================
extern fn ushort rtlCaptureStackBackTrace(
    uint   frames_to_skip,
    uint   frames_to_capture,
    void** back_trace,
    uint*  back_trace_hash
) @cname("RtlCaptureStackBackTrace");

extern fn void rtlCaptureContext(
    void* context_record    // PCONTEXT — opaque
) @cname("RtlCaptureContext");

// =========================================================
// Rtl — Exception helpers
// =========================================================
const int EXCEPTION_CONTINUE_EXECUTION = -1;
const int EXCEPTION_CONTINUE_SEARCH    =  0;
const int EXCEPTION_EXECUTE_HANDLER    =  1;

// =========================================================
// Ex — Pool
// =========================================================
extern fn void* exAllocatePool2(
    ulong flags,            // POOL_FLAGS — 8 bytes
    usz   number_of_bytes,
    uint  tag
) @cname("ExAllocatePool2");

extern fn void exFreePoolWithTag(
    void* p,
    uint  tag
) @cname("ExFreePoolWithTag");

extern fn char exGetPreviousMode() @cname("ExGetPreviousMode");

// =========================================================
// Ex — ERESOURCE (reader-writer lock)
// =========================================================
struct EresourceThread
{
    ListEntry list_entry;
    ulong     thread_and_flags;  // ERESOURCE_THREAD = ULONG_PTR — 8 bytes
}

struct Eresource
{
    ListEntry         system_resources_list;
    EresourceThread*  owner_table;
    short             active_count;
    ushort            flag;
    uint              _pad0;                   // pad before pointer fields
    void*             shared_waiters;          // PKSEMAPHORE
    void*             exclusive_waiters;       // PKEVENT
    EresourceThread   owner_entry;
    uint              active_entries;
    uint              content_length;
    uint              number_of_shared_waiters;
    uint              number_of_exclusive_waiters;
    void*             address;
    KspinLock         spin_lock;
}

extern fn NtStatus exInitializeResourceLite(
    Eresource* resource
) @cname("ExInitializeResourceLite");

extern fn NtStatus exDeleteResourceLite(
    Eresource* resource
) @cname("ExDeleteResourceLite");

extern fn bool exAcquireResourceSharedLite(
    Eresource* resource,
    bool       wait
) @cname("ExAcquireResourceSharedLite");

extern fn bool exAcquireResourceExclusiveLite(
    Eresource* resource,
    bool       wait
) @cname("ExAcquireResourceExclusiveLite");

extern fn void exReleaseResourceLite(
    Eresource* resource
) @cname("ExReleaseResourceLite");

extern fn void exReleaseResourceForThreadLite(
    Eresource* resource,
    ulong      resource_thread_id  // ERESOURCE_THREAD = ULONG_PTR — 8 bytes
) @cname("ExReleaseResourceForThreadLite");

extern fn bool exIsResourceAcquiredExclusiveLite(
    Eresource* resource
) @cname("ExIsResourceAcquiredExclusiveLite");

extern fn uint exIsResourceAcquiredSharedLite(
    Eresource* resource
) @cname("ExIsResourceAcquiredSharedLite");

extern fn void exConvertExclusiveToSharedLite(
    Eresource* resource
) @cname("ExConvertExclusiveToSharedLite");

// =========================================================
// Ex — Lookaside lists
// GENERAL_LOOKASIDE_POOL == 256 bytes  →  32 × ulong
// =========================================================
alias AllocateFunction = fn void*(uint pool_type, usz size, uint tag);
alias FreeFunction     = fn void(void* buffer);

struct GeneralLookasidePool { ulong[32] opaque; }
alias NpagedLookasideList = GeneralLookasidePool;
alias PagedLookasideList  = GeneralLookasidePool;

extern fn void exInitializeNPagedLookasideList(
    NpagedLookasideList* lookaside,
    AllocateFunction     allocate,
    FreeFunction         free,
    ulong                flags,
    usz                  size,
    uint                 tag,
    ushort               depth
) @cname("ExInitializeNPagedLookasideList");

extern fn void  exDeleteNPagedLookasideList(NpagedLookasideList* l)              @cname("ExDeleteNPagedLookasideList");
extern fn void* exAllocateFromNPagedLookasideList(NpagedLookasideList* l)        @cname("ExAllocateFromNPagedLookasideList");
extern fn void  exFreeToNPagedLookasideList(NpagedLookasideList* l, void* entry) @cname("ExFreeToNPagedLookasideList");

extern fn void exInitializePagedLookasideList(
    PagedLookasideList* lookaside,
    AllocateFunction    allocate,
    FreeFunction        free,
    ulong               flags,
    usz                 size,
    uint                tag,
    ushort              depth
) @cname("ExInitializePagedLookasideList");

extern fn void  exDeletePagedLookasideList(PagedLookasideList* l)              @cname("ExDeletePagedLookasideList");
extern fn void* exAllocateFromPagedLookasideList(PagedLookasideList* l)        @cname("ExAllocateFromPagedLookasideList");
extern fn void  exFreeToPagedLookasideList(PagedLookasideList* l, void* entry) @cname("ExFreeToPagedLookasideList");

// =========================================================
// Ex — Callback objects
// =========================================================
alias CallbackFunction = fn void(void* callback_context, void* argument1, void* argument2);

struct CallbackObject { ulong[8] opaque; }

extern fn NtStatus exCreateCallback(
    CallbackObject**  callback_object,
    ObjectAttributes* object_attributes,
    bool              create,
    bool              allow_multiple_callbacks
) @cname("ExCreateCallback");

extern fn void* exRegisterCallback(
    CallbackObject*  callback_object,
    CallbackFunction callback_function,
    void*            callback_context
) @cname("ExRegisterCallback");

extern fn void exUnregisterCallback(void* callback_registration) @cname("ExUnregisterCallback");

extern fn void exNotifyCallback(
    CallbackObject* callback_object,
    void*           argument1,
    void*           argument2
) @cname("ExNotifyCallback");

// =========================================================
// Ex — Push lock (EX_PUSH_LOCK = ULONG_PTR — 8 bytes on x64)
// =========================================================
bitstruct ExPushLock : ulong
{
    bool  locked          : 0;
    bool  waiting         : 1;
    bool  waking          : 2;
    bool  multiple_shared : 3;
    ulong shared          : 4..63;
}

extern fn void exInitializePushLock(
    ExPushLock* push_lock
) @cname("ExInitializePushLock");

extern fn void exAcquirePushLockShared(
    ExPushLock* push_lock
) @cname("ExAcquirePushLockShared");

extern fn void exAcquirePushLockExclusive(
    ExPushLock* push_lock
) @cname("ExAcquirePushLockExclusive");

extern fn void exReleasePushLockShared(
    ExPushLock* push_lock
) @cname("ExReleasePushLockShared");

extern fn void exReleasePushLockExclusive(
    ExPushLock* push_lock
) @cname("ExReleasePushLockExclusive");

// =========================================================
// Interlocked — 32-bit  (LONG = int = 4 bytes)
// =========================================================
extern fn int interlockedIncrement(int* addend)                         @cname("InterlockedIncrement");
extern fn int interlockedDecrement(int* addend)                         @cname("InterlockedDecrement");
extern fn int interlockedExchange(int* target, int value)               @cname("InterlockedExchange");
extern fn int interlockedCompareExchange(int* dest, int xchg, int cmp)  @cname("InterlockedCompareExchange");
extern fn int interlockedAdd(int* addend, int value)                    @cname("InterlockedAdd");
extern fn int interlockedOr(int* dest, int value)                       @cname("InterlockedOr");
extern fn int interlockedAnd(int* dest, int value)                      @cname("InterlockedAnd");
extern fn int interlockedXor(int* dest, int value)                      @cname("InterlockedXor");
extern fn int interlockedExchangeAdd(int* addend, int value)            @cname("InterlockedExchangeAdd");

// =========================================================
// Interlocked — 64-bit  (LONGLONG = long = 8 bytes)
// =========================================================
extern fn long interlockedIncrement64(long* addend)                          @cname("InterlockedIncrement64");
extern fn long interlockedDecrement64(long* addend)                          @cname("InterlockedDecrement64");
extern fn long interlockedExchange64(long* target, long value)               @cname("InterlockedExchange64");
extern fn long interlockedCompareExchange64(long* dest, long xchg, long cmp) @cname("InterlockedCompareExchange64");
extern fn long interlockedExchangeAdd64(long* addend, long value)            @cname("InterlockedExchangeAdd64");
extern fn long interlockedOr64(long* dest, long value)                       @cname("InterlockedOr64");
extern fn long interlockedAnd64(long* dest, long value)                      @cname("InterlockedAnd64");
extern fn long interlockedXor64(long* dest, long value)                      @cname("InterlockedXor64");

// =========================================================
// Probe
// =========================================================
extern fn void probeForRead(void* address, usz length, uint alignment)  @cname("ProbeForRead");
extern fn void probeForWrite(void* address, usz length, uint alignment) @cname("ProbeForWrite");

// =========================================================
// Ob — Object manager
// =========================================================
extern fn void obReferenceObject(void* object)   @cname("ObReferenceObject");
extern fn void obDereferenceObject(void* object) @cname("ObDereferenceObject");

extern fn NtStatus obReferenceObjectByHandle(
    Handle handle,
    uint   desired_access,
    void*  object_type,
    char   access_mode,
    void** object,
    void*  handle_information
) @cname("ObReferenceObjectByHandle");

extern fn NtStatus obOpenObjectByPointer(
    void*             object,
    uint              handle_attributes,
    void*             access_state,
    uint              desired_access,
    void*             object_type,
    char              access_mode,
    Handle*           handle
) @cname("ObOpenObjectByPointer");

// =========================================================
// Ps — Process / Thread
// =========================================================
extern fn EProcess psGetCurrentProcess()   @cname("PsGetCurrentProcess");
extern fn EThread  psGetCurrentThread()    @cname("PsGetCurrentThread");
extern fn void*    psGetCurrentProcessId() @cname("PsGetCurrentProcessId");
extern fn void*    psGetCurrentThreadId()  @cname("PsGetCurrentThreadId");

extern fn NtStatus psLookupProcessByProcessId(
    void*     process_id,
    EProcess* process
) @cname("PsLookupProcessByProcessId");

extern fn NtStatus psLookupThreadByThreadId(
    void*    thread_id,
    EThread* thread
) @cname("PsLookupThreadByThreadId");

extern fn void*    psGetProcessImageFileName(EProcess process) @cname("PsGetProcessImageFileName");
extern fn EProcess psGetThreadProcess(EThread thread)          @cname("PsGetThreadProcess");

// =========================================================
// Ps — System threads
// =========================================================
alias KstartRoutine = fn void(void* start_context);

extern fn NtStatus psCreateSystemThread(
    Handle*           thread_handle,
    uint              desired_access,
    ObjectAttributes* object_attributes,
    Handle            process_handle,
    void*             client_id,
    KstartRoutine     start_routine,
    void*             start_context
) @cname("PsCreateSystemThread");

extern fn NtStatus psTerminateSystemThread(
    NtStatus exit_status
) @cname("PsTerminateSystemThread");

// =========================================================
// Ps — Process / thread notifications
// =========================================================
alias CreateProcessNotifyRoutineEx =
    fn void(EProcess process, void* process_id, void* create_info);
alias CreateThreadNotifyRoutine =
    fn void(void* process_id, void* thread_id, bool create);
alias LoadImageNotifyRoutine =
    fn void(UnicodeString* full_image_name, void* process_id, void* image_info);

extern fn NtStatus psSetCreateProcessNotifyRoutineEx(
    CreateProcessNotifyRoutineEx notify_routine,
    bool                         remove
) @cname("PsSetCreateProcessNotifyRoutineEx");

extern fn NtStatus psSetCreateThreadNotifyRoutine(
    CreateThreadNotifyRoutine notify_routine
) @cname("PsSetCreateThreadNotifyRoutine");

extern fn NtStatus psRemoveCreateThreadNotifyRoutine(
    CreateThreadNotifyRoutine notify_routine
) @cname("PsRemoveCreateThreadNotifyRoutine");

extern fn NtStatus psSetLoadImageNotifyRoutine(
    LoadImageNotifyRoutine notify_routine
) @cname("PsSetLoadImageNotifyRoutine");

extern fn NtStatus psRemoveLoadImageNotifyRoutine(
    LoadImageNotifyRoutine notify_routine
) @cname("PsRemoveLoadImageNotifyRoutine");

// =========================================================
// PS_CREATE_NOTIFY_INFO
// =========================================================
bitstruct PsCreateNotifyInfoFlags : uint
{
    bool file_opened_as_image : 0;
    bool is_subsystem_process : 1;
}

struct PsCreateNotifyInfo
{
    usz                     size;
    PsCreateNotifyInfoFlags flags;
    uint                    _pad0;    // pad flags (4 bytes) before pointer
    EProcess                parent_process;
    void*                   creating_thread_id;
    void*                   file_object;          // PFILE_OBJECT
    UnicodeString*          image_file_name;
    UnicodeString*          command_line;
    NtStatus                creation_status;
}

// =========================================================
// Io — Device / Symbolic link
// =========================================================
extern fn NtStatus ioCreateDevice(
    DriverObject*  driver_object,
    uint           device_extension_size,  // ULONG — 4 bytes
    UnicodeString* device_name,
    uint           device_type,
    uint           device_characteristics,
    bool           exclusive,
    DeviceObject** device_object
) @cname("IoCreateDevice");

extern fn NtStatus ioCreateSymbolicLink(
    UnicodeString* symbolic_link_name,
    UnicodeString* device_name
) @cname("IoCreateSymbolicLink");

extern fn void     ioDeleteDevice(DeviceObject* device_object)                @cname("IoDeleteDevice");
extern fn NtStatus ioDeleteSymbolicLink(UnicodeString* symbolic_link_name)    @cname("IoDeleteSymbolicLink");

extern fn DeviceObject* ioAttachDeviceToDeviceStack(
    DeviceObject* source_device,
    DeviceObject* target_device
) @cname("IoAttachDeviceToDeviceStack");

extern fn void ioDetachDevice(DeviceObject* target_device) @cname("IoDetachDevice");

extern fn NtStatus ioGetDeviceObjectPointer(
    UnicodeString* object_name,
    uint           desired_access,
    FileObject**   file_object,
    DeviceObject** device_object
) @cname("IoGetDeviceObjectPointer");

// =========================================================
// Io — IRP helpers
// =========================================================
extern fn void iofCompleteRequest(Irp* irp, char priority_boost) @cname("IofCompleteRequest");

extern fn IoStackLocation* ioGetCurrentIrpStackLocation(Irp* irp) @cname("IoGetCurrentIrpStackLocation");
extern fn IoStackLocation* ioGetNextIrpStackLocation(Irp* irp)    @cname("IoGetNextIrpStackLocation");

extern fn void ioMarkIrpPending(Irp* irp) @cname("IoMarkIrpPending");

extern fn void ioSetCompletionRoutine(
    Irp*         irp,
    IoCompletion completion_routine,
    void*        context,
    bool         invoke_on_success,
    bool         invoke_on_error,
    bool         invoke_on_cancel
) @cname("IoSetCompletionRoutine");

extern fn void ioCopyCurrentIrpStackLocationToNext(Irp* irp) @cname("IoCopyCurrentIrpStackLocationToNext");
extern fn void ioSkipCurrentIrpStackLocation(Irp* irp)       @cname("IoSkipCurrentIrpStackLocation");
extern fn void ioSetNextIrpStackLocation(Irp* irp)           @cname("IoSetNextIrpStackLocation");

extern fn void ioInitializeIrp(
    Irp*   irp,
    ushort packet_size,
    char   stack_size
) @cname("IoInitializeIrp");

extern fn Irp* ioAllocateIrp(char stack_size, bool charge_quota) @cname("IoAllocateIrp");
extern fn void ioFreeIrp(Irp* irp)                               @cname("IoFreeIrp");

extern fn Irp* ioBuildSynchronousFsdRequest(
    uint           major_function,
    DeviceObject*  device_object,
    void*          buffer,
    uint           length,
    LargeInteger*  starting_offset,
    Kevent*        event,
    IoStatusBlock* io_status_block
) @cname("IoBuildSynchronousFsdRequest");

extern fn Irp* ioBuildAsynchronousFsdRequest(
    uint           major_function,
    DeviceObject*  device_object,
    void*          buffer,
    uint           length,
    LargeInteger*  starting_offset,
    IoStatusBlock* io_status_block
) @cname("IoBuildAsynchronousFsdRequest");

extern fn Irp* ioBuildDeviceIoControlRequest(
    uint           io_control_code,
    DeviceObject*  device_object,
    void*          input_buffer,
    uint           input_buffer_length,
    void*          output_buffer,
    uint           output_buffer_length,
    bool           internal_device_io_control,
    Kevent*        event,
    IoStatusBlock* io_status_block
) @cname("IoBuildDeviceIoControlRequest");

extern fn NtStatus iofCallDriver(
    DeviceObject* device_object,
    Irp*          irp
) @cname("IofCallDriver");

// =========================================================
// Io — MDL
// =========================================================
extern fn void* ioAllocateMdl(
    void* virtual_address,
    uint  length,
    bool  secondary_buffer,
    bool  charge_quota,
    Irp*  irp
) @cname("IoAllocateMdl");

extern fn void ioFreeMdl(void* mdl) @cname("IoFreeMdl");

// =========================================================
// Io — Work items
// =========================================================
alias WorkItemRoutine = fn void(void* io_object, void* context, void* work_item);
alias IoWorkItem      = void*;

alias WorkQueueType = int;
const WorkQueueType CRITICAL_WORK_QUEUE      = 0;
const WorkQueueType DELAYED_WORK_QUEUE       = 1;
const WorkQueueType HYPERCRITICAL_WORK_QUEUE = 2;

extern fn IoWorkItem ioAllocateWorkItem(DeviceObject* device_object) @cname("IoAllocateWorkItem");
extern fn void       ioFreeWorkItem(IoWorkItem work_item)             @cname("IoFreeWorkItem");

extern fn void ioQueueWorkItem(
    IoWorkItem      work_item,
    WorkItemRoutine routine,
    WorkQueueType   queue_type,
    void*           context
) @cname("IoQueueWorkItem");

// =========================================================
// Io — Device relations / PnP
// =========================================================
alias DeviceRelationType = int;
const DeviceRelationType BUS_RELATIONS          = 0;
const DeviceRelationType EJECTION_RELATIONS     = 1;
const DeviceRelationType POWER_RELATIONS        = 2;
const DeviceRelationType REMOVAL_RELATIONS      = 3;
const DeviceRelationType TARGET_DEVICE_RELATION = 4;
const DeviceRelationType SINGLE_BUS_RELATIONS   = 5;
const DeviceRelationType TRANSPORT_RELATIONS    = 6;

struct DeviceRelations
{
    uint          count;
    DeviceObject* objects;  // flexible array — access as (DeviceObject**)&objects
}

// =========================================================
// Io — Error logging
// =========================================================
extern fn void* ioAllocateErrorLogEntry(void* io_object, char entry_size) @cname("IoAllocateErrorLogEntry");
extern fn void  ioWriteErrorLogEntry(void* error_log_entry)               @cname("IoWriteErrorLogEntry");

// =========================================================
// Mm — Memory
// =========================================================
extern fn void mmProbeAndLockPages(
    void*         memory_descriptor_list,
    char          access_mode,
    LockOperation operation
) @cname("MmProbeAndLockPages");

extern fn void  mmUnlockPages(void* mdl)                                       @cname("MmUnlockPages");
extern fn void* mmGetSystemAddressForMdlSafe(void* mdl, uint priority)         @cname("MmGetSystemAddressForMdlSafe");
extern fn bool  mmIsAddressValid(void* virtual_address)                        @cname("MmIsAddressValid");
extern fn void* mmAllocateNonCachedMemory(usz number_of_bytes)                 @cname("MmAllocateNonCachedMemory");
extern fn void  mmFreeNonCachedMemory(void* base_address, usz number_of_bytes) @cname("MmFreeNonCachedMemory");

extern fn void* mmAllocateContiguousMemory(
    usz          number_of_bytes,
    LargeInteger highest_acceptable_address  // PHYSICAL_ADDRESS = LARGE_INTEGER — 8 bytes
) @cname("MmAllocateContiguousMemory");

extern fn void  mmFreeContiguousMemory(void* base_address) @cname("MmFreeContiguousMemory");
extern fn ulong mmGetPhysicalAddress(void* base_address)   @cname("MmGetPhysicalAddress");  // PHYSICAL_ADDRESS — 8 bytes

extern fn void* mmMapIoSpace(
    ulong physical_address,  // PHYSICAL_ADDRESS — 8 bytes
    usz   number_of_bytes,
    int   cache_type
) @cname("MmMapIoSpace");

extern fn void mmUnmapIoSpace(void* base_address, usz number_of_bytes) @cname("MmUnmapIoSpace");

// =========================================================
// Mm — Virtual memory (Zw wrappers)
// =========================================================
alias MemoryInformationClass = int;
const MemoryInformationClass MEMORY_BASIC_INFORMATION_CLASS = 0;
const MemoryInformationClass MEMORY_WORKING_SET_LIST        = 1;

struct MemoryBasicInformation
{
    void* base_address;
    void* allocation_base;
    uint  allocation_protect;
    uint  _pad0;           // pad before SIZE_T
    usz   region_size;
    uint  state;
    uint  protect;
    uint  type;
    uint  _pad1;           // trailing pad to keep struct size a multiple of 8
}

// Page-protection constants
const uint PAGE_NOACCESS          = 0x001;
const uint PAGE_READONLY          = 0x002;
const uint PAGE_READWRITE         = 0x004;
const uint PAGE_WRITECOPY         = 0x008;
const uint PAGE_EXECUTE           = 0x010;
const uint PAGE_EXECUTE_READ      = 0x020;
const uint PAGE_EXECUTE_READWRITE = 0x040;
const uint PAGE_EXECUTE_WRITECOPY = 0x080;
const uint PAGE_GUARD             = 0x100;
const uint PAGE_NOCACHE           = 0x200;
const uint PAGE_WRITECOMBINE      = 0x400;

// MEM_xxx allocation type / state
const uint MEM_COMMIT    = 0x00001000;
const uint MEM_RESERVE   = 0x00002000;
const uint MEM_DECOMMIT  = 0x00004000;
const uint MEM_RELEASE   = 0x00008000;
const uint MEM_FREE      = 0x00010000;
const uint MEM_PRIVATE   = 0x00020000;
const uint MEM_MAPPED    = 0x00040000;
const uint MEM_RESET     = 0x00080000;
const uint MEM_IMAGE     = 0x01000000;

extern fn NtStatus zwAllocateVirtualMemory(
    Handle process_handle,
    void** base_address,
    ulong  zero_bits,       // ULONG_PTR — 8 bytes on x64
    usz*   region_size,
    uint   allocation_type,
    uint   protect
) @cname("ZwAllocateVirtualMemory");

extern fn NtStatus zwFreeVirtualMemory(
    Handle process_handle,
    void** base_address,
    usz*   region_size,
    uint   free_type
) @cname("ZwFreeVirtualMemory");

extern fn NtStatus zwQueryVirtualMemory(
    Handle                 process_handle,
    void*                  base_address,
    MemoryInformationClass memory_information_class,
    void*                  memory_information,
    usz                    memory_information_length,
    usz*                   return_length
) @cname("ZwQueryVirtualMemory");

extern fn NtStatus zwProtectVirtualMemory(
    Handle process_handle,
    void** base_address,
    usz*   region_size,
    uint   new_protect,
    uint*  old_protect
) @cname("ZwProtectVirtualMemory");

extern fn NtStatus zwReadVirtualMemory(
    Handle process_handle,
    void*  base_address,
    void*  buffer,
    usz    size,
    usz*   bytes_read
) @cname("ZwReadVirtualMemory");

extern fn NtStatus zwWriteVirtualMemory(
    Handle process_handle,
    void*  base_address,
    void*  buffer,
    usz    size,
    usz*   bytes_written
) @cname("ZwWriteVirtualMemory");

// =========================================================
// Zw — File I/O
// =========================================================
extern fn NtStatus zwCreateFile(
    Handle*           file_handle,
    uint              desired_access,
    ObjectAttributes* object_attributes,
    IoStatusBlock*    io_status_block,
    LargeInteger*     allocation_size,
    uint              file_attributes,
    uint              share_access,
    uint              create_disposition,
    uint              create_options,
    void*             ea_buffer,
    uint              ea_length
) @cname("ZwCreateFile");

extern fn NtStatus zwClose(Handle handle) @cname("ZwClose");

extern fn NtStatus zwReadFile(
    Handle         file_handle,
    Handle         event,
    void*          apc_routine,
    void*          apc_context,
    IoStatusBlock* io_status_block,
    void*          buffer,
    uint           length,
    LargeInteger*  byte_offset,
    uint*          key
) @cname("ZwReadFile");

extern fn NtStatus zwWriteFile(
    Handle         file_handle,
    Handle         event,
    void*          apc_routine,
    void*          apc_context,
    IoStatusBlock* io_status_block,
    void*          buffer,
    uint           length,
    LargeInteger*  byte_offset,
    uint*          key
) @cname("ZwWriteFile");

extern fn NtStatus zwQueryInformationFile(
    Handle         file_handle,
    IoStatusBlock* io_status_block,
    void*          file_information,
    uint           length,
    uint           file_information_class
) @cname("ZwQueryInformationFile");

extern fn NtStatus zwSetInformationFile(
    Handle         file_handle,
    IoStatusBlock* io_status_block,
    void*          file_information,
    uint           length,
    uint           file_information_class
) @cname("ZwSetInformationFile");

extern fn NtStatus zwFlushBuffersFile(
    Handle         file_handle,
    IoStatusBlock* io_status_block
) @cname("ZwFlushBuffersFile");

extern fn NtStatus zwDeleteFile(
    ObjectAttributes* object_attributes
) @cname("ZwDeleteFile");

// =========================================================
// Zw — Registry
// =========================================================
extern fn NtStatus zwOpenKey(
    Handle*           key_handle,
    uint              desired_access,
    ObjectAttributes* object_attributes
) @cname("ZwOpenKey");

extern fn NtStatus zwCreateKey(
    Handle*           key_handle,
    uint              desired_access,
    ObjectAttributes* object_attributes,
    uint              title_index,
    UnicodeString*    class,
    uint              create_options,
    uint*             disposition
) @cname("ZwCreateKey");

extern fn NtStatus zwDeleteKey(Handle key_handle) @cname("ZwDeleteKey");

extern fn NtStatus zwQueryValueKey(
    Handle         key_handle,
    UnicodeString* value_name,
    uint           key_value_information_class,
    void*          key_value_information,
    uint           length,
    uint*          result_length
) @cname("ZwQueryValueKey");

extern fn NtStatus zwSetValueKey(
    Handle         key_handle,
    UnicodeString* value_name,
    uint           title_index,
    uint           type,
    void*          data,
    uint           data_size
) @cname("ZwSetValueKey");

extern fn NtStatus zwDeleteValueKey(
    Handle         key_handle,
    UnicodeString* value_name
) @cname("ZwDeleteValueKey");

extern fn NtStatus zwEnumerateKey(
    Handle  key_handle,
    uint    index,
    uint    key_information_class,
    void*   key_information,
    uint    length,
    uint*   result_length
) @cname("ZwEnumerateKey");

extern fn NtStatus zwEnumerateValueKey(
    Handle  key_handle,
    uint    index,
    uint    key_value_information_class,
    void*   key_value_information,
    uint    length,
    uint*   result_length
) @cname("ZwEnumerateValueKey");

// =========================================================
// Zw — System / process information
// =========================================================
alias SystemInformationClass = int;
const SystemInformationClass SYSTEM_BASIC_INFORMATION           = 0;
const SystemInformationClass SYSTEM_PERFORMANCE_INFORMATION     = 2;
const SystemInformationClass SYSTEM_TIME_OF_DAY_INFORMATION     = 3;
const SystemInformationClass SYSTEM_PROCESS_INFORMATION         = 5;
const SystemInformationClass SYSTEM_MODULE_INFORMATION          = 11;
const SystemInformationClass SYSTEM_KERNEL_DEBUGGER_INFORMATION = 35;

extern fn NtStatus zwQuerySystemInformation(
    SystemInformationClass system_information_class,
    void*                  system_information,
    uint                   system_information_length,
    uint*                  return_length
) @cname("ZwQuerySystemInformation");

struct SystemProcessInformation
{
    uint          next_entry_offset;
    uint          number_of_threads;
    long[3]       spare_li;         // LARGE_INTEGER[3] — 8 bytes each
    long          create_time;      // LARGE_INTEGER
    long          user_time;
    long          kernel_time;
    UnicodeString image_name;
    int           base_priority;    // KPRIORITY = LONG — 4 bytes
    uint          _pad0;
    void*         unique_process_id;
    void*         inherited_from_unique_process_id;
    uint          handle_count;
    uint          session_id;
    ulong         unique_process_key;   // ULONG_PTR — 8 bytes
    usz           peak_virtual_size;
    usz           virtual_size;
    uint          page_fault_count;
    uint          _pad1;
}

alias ProcessInformationClass = int;
const ProcessInformationClass PROCESS_BASIC_INFORMATION_CLASS = 0;
const ProcessInformationClass PROCESS_VM_COUNTERS             = 3;
const ProcessInformationClass PROCESS_TIMES                   = 4;
const ProcessInformationClass PROCESS_SESSION_INFORMATION     = 24;
const ProcessInformationClass PROCESS_IMAGE_FILE_NAME         = 27;
const ProcessInformationClass PROCESS_PROTECT_INFORMATION     = 61;

alias ThreadInformationClass = int;
const ThreadInformationClass THREAD_BASIC_INFORMATION_CLASS  = 0;
const ThreadInformationClass THREAD_TIMES                    = 1;
const ThreadInformationClass THREAD_PRIORITY                 = 2;
const ThreadInformationClass THREAD_BASE_PRIORITY            = 3;
const ThreadInformationClass THREAD_QUERY_SET_WIN32_PRIORITY = 9;

extern fn NtStatus zwQueryInformationProcess(
    Handle                  process_handle,
    ProcessInformationClass process_information_class,
    void*                   process_information,
    uint                    process_information_length,
    uint*                   return_length
) @cname("ZwQueryInformationProcess");

extern fn NtStatus zwQueryInformationThread(
    Handle                 thread_handle,
    ThreadInformationClass thread_information_class,
    void*                  thread_information,
    uint                   thread_information_length,
    uint*                  return_length
) @cname("ZwQueryInformationThread");

struct ProcessBasicInformation
{
    NtStatus exit_status;
    uint     _pad0;
    void*    peb_base_address;
    usz      affinity_mask;    // KAFFINITY = ULONG_PTR — 8 bytes
    int      base_priority;    // KPRIORITY = LONG — 4 bytes
    uint     _pad1;
    void*    unique_process_id;
    void*    inherited_from_unique_process_id;
}

// =========================================================
// Cm — Registry callback
// =========================================================
alias CmRegistryCallback = fn NtStatus(void* callback_context, void* argument1, void* argument2);

alias RegNotifyClass = int;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_DELETE_KEY        = 0;
const RegNotifyClass REG_NOTIFY_CLASS_POST_DELETE_KEY       = 1;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_SET_VALUE_KEY     = 2;
const RegNotifyClass REG_NOTIFY_CLASS_POST_SET_VALUE_KEY    = 3;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_DELETE_VALUE_KEY  = 4;
const RegNotifyClass REG_NOTIFY_CLASS_POST_DELETE_VALUE_KEY = 5;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_QUERY_KEY         = 12;
const RegNotifyClass REG_NOTIFY_CLASS_POST_QUERY_KEY        = 13;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_OPEN_KEY          = 14;
const RegNotifyClass REG_NOTIFY_CLASS_POST_OPEN_KEY         = 15;
const RegNotifyClass REG_NOTIFY_CLASS_PRE_CREATE_KEY        = 16;
const RegNotifyClass REG_NOTIFY_CLASS_POST_CREATE_KEY       = 17;

extern fn NtStatus cmRegisterCallback(
    CmRegistryCallback function,
    void*              context,
    LargeInteger*      cookie      // LARGE_INTEGER* — 8 bytes
) @cname("CmRegisterCallback");

extern fn NtStatus cmUnRegisterCallback(
    LargeInteger cookie             // LARGE_INTEGER by value — 8 bytes
) @cname("CmUnRegisterCallback");

// =========================================================
// Se — Security / token helpers
// =========================================================
alias TokenInformationClass = int;
const TokenInformationClass TOKEN_USER_CLASS            = 1;
const TokenInformationClass TOKEN_GROUPS_CLASS          = 2;
const TokenInformationClass TOKEN_PRIVILEGES_CLASS      = 3;
const TokenInformationClass TOKEN_OWNER_CLASS           = 4;
const TokenInformationClass TOKEN_PRIMARY_GROUP_CLASS   = 5;
const TokenInformationClass TOKEN_SOURCE_CLASS          = 7;
const TokenInformationClass TOKEN_TYPE_CLASS            = 8;
const TokenInformationClass TOKEN_STATISTICS_CLASS      = 10;
const TokenInformationClass TOKEN_INTEGRITY_LEVEL_CLASS = 25;

extern fn NtStatus seQueryInformationToken(
    void*                 token,
    TokenInformationClass token_information_class,
    void**                token_information
) @cname("SeQueryInformationToken");

extern fn bool seTokenIsAdmin(void* token)      @cname("SeTokenIsAdmin");
extern fn bool seTokenIsRestricted(void* token) @cname("SeTokenIsRestricted");

extern fn NtStatus seQuerySessionIdToken(
    void*  token,
    uint*  session_id
) @cname("SeQuerySessionIdToken");

// Privilege index constants — ULONG (4 bytes)
const uint SE_CREATE_TOKEN_PRIVILEGE       = 2;
const uint SE_ASSIGNPRIMARYTOKEN_PRIVILEGE = 3;
const uint SE_LOCK_MEMORY_PRIVILEGE        = 4;
const uint SE_INCREASE_QUOTA_PRIVILEGE     = 5;
const uint SE_TCB_PRIVILEGE                = 7;
const uint SE_SECURITY_PRIVILEGE           = 8;
const uint SE_TAKE_OWNERSHIP_PRIVILEGE     = 9;
const uint SE_LOAD_DRIVER_PRIVILEGE        = 10;
const uint SE_SYSTEM_PROFILE_PRIVILEGE     = 11;
const uint SE_SYSTEMTIME_PRIVILEGE         = 12;
const uint SE_SHUTDOWN_PRIVILEGE           = 19;
const uint SE_DEBUG_PRIVILEGE              = 20;
const uint SE_AUDIT_PRIVILEGE              = 21;
const uint SE_MANAGE_VOLUME_PRIVILEGE      = 28;
const uint SE_IMPERSONATE_PRIVILEGE        = 29;
const uint SE_CREATE_GLOBAL_PRIVILEGE      = 30;

// LUID
struct Luid
{
    uint low_part;   // ULONG — 4 bytes
    int  high_part;  // LONG  — 4 bytes
}

struct LuidAndAttributes
{
    Luid luid;
    uint attributes;
}

const uint SE_PRIVILEGE_ENABLED_BY_DEFAULT = 0x00000001;
const uint SE_PRIVILEGE_ENABLED            = 0x00000002;
const uint SE_PRIVILEGE_REMOVED            = 0x00000004;
const uint SE_PRIVILEGE_USED_FOR_ACCESS    = 0x80000000;

// =========================================================
// Debug / CRT
// =========================================================
extern fn uint dbgPrintEx(
    uint  component_id,
    uint  level,
    char* format,
    ...
) @cname("DbgPrintEx");

extern fn int sprintf_s(
    char* buffer,
    usz   size_of_buffer,
    char* format,
    ...
);
