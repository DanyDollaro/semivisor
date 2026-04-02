module wdk;

alias NtStatus = uint;

// =========================================================
// Success (0x0000xxxx)
// =========================================================
const NtStatus STATUS_SUCCESS                            = 0x00000000;
const NtStatus STATUS_WAIT_1                             = 0x00000001;
const NtStatus STATUS_WAIT_2                             = 0x00000002;
const NtStatus STATUS_WAIT_3                             = 0x00000003;
const NtStatus STATUS_WAIT_63                            = 0x0000003F;
const NtStatus STATUS_ABANDONED_WAIT_0                   = 0x00000080;
const NtStatus STATUS_ABANDONED_WAIT_63                  = 0x000000BF;
const NtStatus STATUS_USER_APC                           = 0x000000C0;
const NtStatus STATUS_KERNEL_APC                         = 0x00000100;
const NtStatus STATUS_ALERTED                            = 0x00000101;
const NtStatus STATUS_TIMEOUT                            = 0x00000102;
const NtStatus STATUS_PENDING                            = 0x00000103;
const NtStatus STATUS_REPARSE                            = 0x00000104;
const NtStatus STATUS_MORE_ENTRIES                       = 0x00000105;
const NtStatus STATUS_NOT_ALL_ASSIGNED                   = 0x00000106;
const NtStatus STATUS_SOME_NOT_MAPPED                    = 0x00000107;
const NtStatus STATUS_OPLOCK_BREAK_IN_PROGRESS           = 0x00000108;
const NtStatus STATUS_VOLUME_MOUNTED                     = 0x00000109;
const NtStatus STATUS_RXACT_COMMITTED                    = 0x0000010A;
const NtStatus STATUS_NOTIFY_CLEANUP                     = 0x0000010B;
const NtStatus STATUS_NOTIFY_ENUM_DIR                    = 0x0000010C;

// =========================================================
// Informational (0x4000xxxx)
// =========================================================
const NtStatus STATUS_OBJECT_NAME_EXISTS                 = 0x40000000;
const NtStatus STATUS_THREAD_WAS_SUSPENDED               = 0x40000001;
const NtStatus STATUS_WORKING_SET_LIMIT_RANGE            = 0x40000002;
const NtStatus STATUS_IMAGE_NOT_AT_BASE                  = 0x40000003;
const NtStatus STATUS_RXACT_STATE_CREATED                = 0x40000004;
const NtStatus STATUS_SEGMENT_NOTIFICATION               = 0x40000005;

// =========================================================
// Warning (0x8000xxxx)
// =========================================================
const NtStatus STATUS_GUARD_PAGE_VIOLATION               = 0x80000001;
const NtStatus STATUS_DATATYPE_MISALIGNMENT              = 0x80000002;
const NtStatus STATUS_BREAKPOINT                         = 0x80000003;
const NtStatus STATUS_SINGLE_STEP                        = 0x80000004;
const NtStatus STATUS_BUFFER_OVERFLOW                    = 0x80000005;

// =========================================================
// Error (0xC000xxxx)
// =========================================================
const NtStatus STATUS_UNSUCCESSFUL                       = 0xC0000001;
const NtStatus STATUS_NOT_IMPLEMENTED                    = 0xC0000002;
const NtStatus STATUS_INVALID_INFO_CLASS                 = 0xC0000003;
const NtStatus STATUS_INFO_LENGTH_MISMATCH               = 0xC0000004;
const NtStatus STATUS_ACCESS_VIOLATION                   = 0xC0000005;
const NtStatus STATUS_IN_PAGE_ERROR                      = 0xC0000006;
const NtStatus STATUS_INVALID_HANDLE                     = 0xC0000008;
const NtStatus STATUS_INVALID_PARAMETER                  = 0xC000000D;
const NtStatus STATUS_NO_SUCH_DEVICE                     = 0xC000000E;
const NtStatus STATUS_NO_SUCH_FILE                       = 0xC000000F;
const NtStatus STATUS_INVALID_DEVICE_REQUEST             = 0xC0000010;
const NtStatus STATUS_END_OF_FILE                        = 0xC0000011;
const NtStatus STATUS_MORE_PROCESSING_REQUIRED           = 0xC0000016;
const NtStatus STATUS_NO_MEMORY                          = 0xC0000017;
const NtStatus STATUS_ACCESS_DENIED                      = 0xC0000022;
const NtStatus STATUS_BUFFER_TOO_SMALL                   = 0xC0000023;
const NtStatus STATUS_OBJECT_NAME_INVALID                = 0xC0000033;
const NtStatus STATUS_OBJECT_NAME_NOT_FOUND              = 0xC0000034;
const NtStatus STATUS_OBJECT_NAME_COLLISION              = 0xC0000035;
const NtStatus STATUS_OBJECT_PATH_NOT_FOUND              = 0xC000003A;
const NtStatus STATUS_SHARING_VIOLATION                  = 0xC0000043;
const NtStatus STATUS_DELETE_PENDING                     = 0xC0000056;
const NtStatus STATUS_PRIVILEGE_NOT_HELD                 = 0xC0000061;
const NtStatus STATUS_LOGON_FAILURE                      = 0xC000006D;
const NtStatus STATUS_DISK_FULL                          = 0xC000007F;
const NtStatus STATUS_FILE_IS_A_DIRECTORY                = 0xC00000BA;
const NtStatus STATUS_NOT_SUPPORTED                      = 0xC00000BB;
const NtStatus STATUS_INTERNAL_ERROR                     = 0xC00000E5;
const NtStatus STATUS_INVALID_IMAGE_FORMAT               = 0xC000007B;
const NtStatus STATUS_DLL_NOT_FOUND                      = 0xC0000135;
const NtStatus STATUS_ENTRYPOINT_NOT_FOUND               = 0xC0000139;
const NtStatus STATUS_DLL_INIT_FAILED                    = 0xC0000142;
const NtStatus STATUS_CONTROL_C_EXIT                     = 0xC000013A;
const NtStatus STATUS_PIPE_BROKEN                        = 0xC000014B;
const NtStatus STATUS_REGISTRY_CORRUPT                   = 0xC000014C;
const NtStatus STATUS_NO_SUCH_USER                       = 0xC0000064;
const NtStatus STATUS_ACCOUNT_DISABLED                   = 0xC0000072;
const NtStatus STATUS_PASSWORD_EXPIRED                   = 0xC0000071;
const NtStatus STATUS_ACCOUNT_LOCKED_OUT                 = 0xC0000234;

struct UnicodeString
{
    ushort length;
    ushort maximum_length;
    ushort* buffer;
}

alias IoTimer          = void*;
alias Vpb              = void*;
alias SecurityDescriptor = void*;
alias DevObjExtension  = void*;

alias KDeviceQueue     = void*;
alias Kdpc             = void*;
alias KEvent           = void*;

alias Irp = void*;
alias FastIoDispatch = void*;

alias DriverAddDevice = fn NtStatus(DriverObject*, DeviceObject*);
alias DriverStartIo = fn void(DeviceObject* device_object, Irp* irp);
alias DriverInitialize = fn NtStatus(DriverObject* driver_object, UnicodeString* registry_path);
alias DriverUnload = fn void(DriverObject* driver_object);
alias DriverDispatch = fn NtStatus(DeviceObject* device_object, Irp* irp);

const IRP_MJ_MAXIMUM_FUNCTION = 0x1b;

struct DriverExtension
{
    DriverObject* driver_object;
    DriverAddDevice add_device;
    uint count;
    UnicodeString service_key_name;
}

struct DriverObject
{
    short type;
    short size;
    DeviceObject* device_object;
    uint flags;
    void* driver_start;
    uint driver_size;
    void* driver_section;
    DriverExtension* driver_extension;
    UnicodeString driver_name;
    UnicodeString* hardware_database;
    FastIoDispatch* fast_io_dispatch;
    DriverInitialize driver_init;
    DriverStartIo driver_start_io;
    DriverUnload driver_unload;
    DriverDispatch[IRP_MJ_MAXIMUM_FUNCTION + 1] major_function;
}

union DeviceQueue
{
    void* list_entry;       // LIST_ENTRY
    void* wait_context_block;
}

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

const uint DRVO_REINIT_REGISTERED           = 0x00000008;
const uint DRVO_INITIALIZED                 = 0x00000010;
const uint DRVO_BOOTREINIT_REGISTERED       = 0x00000020;
const uint DRVO_LEGACY_RESOURCES            = 0x00000040;

struct DeviceObject
{
    short              type;
    short              size;
    int                reference_count;
    DriverObject*      driver_object;
    DeviceObject*      next_device;
    DeviceObject*      attached_device;
    Irp*               current_irp;
    IoTimer*           timer;
    uint               flags;
    uint               characteristics;
    Vpb*               vpb;
    void*              device_extension;
    uint               device_type;
    char               stack_size;
    DeviceQueue        queue;
    uint               alignment_requirement;
    KDeviceQueue       device_queue;
    Kdpc               dpc;
    uint               active_thread_count;
    SecurityDescriptor security_descriptor;
    KEvent             device_lock;
    ushort             sector_size;
    ushort             spare1;
    DevObjExtension    device_object_extension;
    void*              reserved;
}

extern fn int sprintf_s(
    char* buffer,
    usz size_of_buffer,
    char* format,
    ...
);

extern fn uint dbgPrintEx(uint component_id, uint level, char* format, ...) @cname("DbgPrintEx");

fn void __security_check_cookie(usz cookie) @export("__security_check_cookie")
{
    // this function is required for or the linker will give error
}

alias LargeInteger = long;

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

// Retrieves current system time (UTC)
extern fn void keQuerySystemTimePrecise(
    LargeInteger* current_time
) @cname("KeQuerySystemTimePrecise");

extern fn void rtlTimeToTimeFields(
    LargeInteger* time,
    TimeFields* time_fields
) @cname("RtlTimeToTimeFields");

extern fn void exSystemTimeToLocalTime(
    LargeInteger* system_time,
    LargeInteger* local_time
) @cname("ExSystemTimeToLocalTime");

struct ProcessorNumber
{
  ushort group;
  char number;
  char reserved;
}

extern fn uint keGetCurrentProcessorNumberEx(
    ProcessorNumber* processor_number
) @cname("KeGetCurrentProcessorNumberEx");

const POOL_FLAG_REQUIRED_START    = 0x0000000000000001;
const POOL_FLAG_USE_QUOTA         = 0x0000000000000001;     // Charge quota
const POOL_FLAG_UNINITIALIZED     = 0x0000000000000002;     // Don't zero-initialize allocation
const POOL_FLAG_SESSION           = 0x0000000000000004;     // Use session specific pool
const POOL_FLAG_CACHE_ALIGNED     = 0x0000000000000008;     // Cache aligned allocation
const POOL_FLAG_RESERVED1         = 0x0000000000000010;     // Reserved for system use
const POOL_FLAG_RAISE_ON_FAILURE  = 0x0000000000000020;     // Raise exception on failure
const POOL_FLAG_NON_PAGED         = 0x0000000000000040;     // Non paged pool NX
const POOL_FLAG_NON_PAGED_EXECUTE = 0x0000000000000080;     // Non paged pool executable
const POOL_FLAG_PAGED             = 0x0000000000000100;     // Paged pool
const POOL_FLAG_RESERVED2         = 0x0000000000000200;     // Reserved for system use
const POOL_FLAG_RESERVED3         = 0x0000000000000400;     // Reserved for system use
const POOL_FLAG_REQUIRED_END      = 0x0000000080000000;
const POOL_FLAG_OPTIONAL_START    = 0x0000000100000000;
const POOL_FLAG_SPECIAL_POOL      = 0x0000000100000000;     // Make special pool allocation
const POOL_FLAG_OPTIONAL_END      = 0x8000000000000000;

extern fn void* exAllocatePool2(
  ulong flags,
  usz number_of_bytes,
  uint tag
) @cname("ExAllocatePool2");

extern fn void exFreePoolWithTag(
  void* p,
  uint tag
) @cname("ExFreePoolWithTag");

alias Kirql = char;

extern fn Kirql keGetCurrentIrql()
    @cname("KeGetCurrentIrql");

const uint FILE_DEVICE_BEEP                    = 0x00000001;
const uint FILE_DEVICE_CD_ROM                  = 0x00000002;
const uint FILE_DEVICE_CD_ROM_FILE_SYSTEM      = 0x00000003;
const uint FILE_DEVICE_CONTROLLER              = 0x00000004;
const uint FILE_DEVICE_DATALINK                = 0x00000005;
const uint FILE_DEVICE_DFS                     = 0x00000006;
const uint FILE_DEVICE_DISK                    = 0x00000007;
const uint FILE_DEVICE_DISK_FILE_SYSTEM        = 0x00000008;
const uint FILE_DEVICE_FILE_SYSTEM             = 0x00000009;
const uint FILE_DEVICE_INPORT_PORT             = 0x0000000a;
const uint FILE_DEVICE_KEYBOARD                = 0x0000000b;
const uint FILE_DEVICE_MAILSLOT                = 0x0000000c;
const uint FILE_DEVICE_MIDI_IN                 = 0x0000000d;
const uint FILE_DEVICE_MIDI_OUT                = 0x0000000e;
const uint FILE_DEVICE_MOUSE                   = 0x0000000f;
const uint FILE_DEVICE_MULTI_UNC_PROVIDER      = 0x00000010;
const uint FILE_DEVICE_NAMED_PIPE              = 0x00000011;
const uint FILE_DEVICE_NETWORK                 = 0x00000012;
const uint FILE_DEVICE_NETWORK_BROWSER         = 0x00000013;
const uint FILE_DEVICE_NETWORK_FILE_SYSTEM     = 0x00000014;
const uint FILE_DEVICE_NULL                    = 0x00000015;
const uint FILE_DEVICE_PARALLEL_PORT           = 0x00000016;
const uint FILE_DEVICE_PHYSICAL_NETCARD        = 0x00000017;
const uint FILE_DEVICE_PRINTER                 = 0x00000018;
const uint FILE_DEVICE_SCANNER                 = 0x00000019;
const uint FILE_DEVICE_SERIAL_MOUSE_PORT       = 0x0000001a;
const uint FILE_DEVICE_SERIAL_PORT             = 0x0000001b;
const uint FILE_DEVICE_SCREEN                  = 0x0000001c;
const uint FILE_DEVICE_SOUND                   = 0x0000001d;
const uint FILE_DEVICE_STREAMS                 = 0x0000001e;
const uint FILE_DEVICE_TAPE                    = 0x0000001f;
const uint FILE_DEVICE_TAPE_FILE_SYSTEM        = 0x00000020;
const uint FILE_DEVICE_TRANSPORT               = 0x00000021;
const uint FILE_DEVICE_UNKNOWN                 = 0x00000022;
const uint FILE_DEVICE_VIDEO                   = 0x00000023;
const uint FILE_DEVICE_VIRTUAL_DISK            = 0x00000024;
const uint FILE_DEVICE_WAVE_IN                 = 0x00000025;
const uint FILE_DEVICE_WAVE_OUT                = 0x00000026;
const uint FILE_DEVICE_8042_PORT               = 0x00000027;
const uint FILE_DEVICE_NETWORK_REDIRECTOR      = 0x00000028;
const uint FILE_DEVICE_BATTERY                 = 0x00000029;
const uint FILE_DEVICE_BUS_EXTENDER            = 0x0000002a;
const uint FILE_DEVICE_MODEM                   = 0x0000002b;
const uint FILE_DEVICE_VDM                     = 0x0000002c;
const uint FILE_DEVICE_MASS_STORAGE            = 0x0000002d;
const uint FILE_DEVICE_SMB                     = 0x0000002e;
const uint FILE_DEVICE_KS                      = 0x0000002f;
const uint FILE_DEVICE_CHANGER                 = 0x00000030;
const uint FILE_DEVICE_SMARTCARD               = 0x00000031;
const uint FILE_DEVICE_ACPI                    = 0x00000032;
const uint FILE_DEVICE_DVD                     = 0x00000033;
const uint FILE_DEVICE_FULLSCREEN_VIDEO        = 0x00000034;
const uint FILE_DEVICE_DFS_FILE_SYSTEM         = 0x00000035;
const uint FILE_DEVICE_DFS_VOLUME              = 0x00000036;
const uint FILE_DEVICE_SERENUM                 = 0x00000037;
const uint FILE_DEVICE_TERMSRV                 = 0x00000038;
const uint FILE_DEVICE_KSEC                    = 0x00000039;
const uint FILE_DEVICE_FIPS                    = 0x0000003a;
const uint FILE_DEVICE_INFINIBAND              = 0x0000003b;
const uint FILE_DEVICE_VMBUS                   = 0x0000003e;
const uint FILE_DEVICE_CRYPT_PROVIDER          = 0x0000003f;
const uint FILE_DEVICE_WPD                     = 0x00000040;
const uint FILE_DEVICE_BLUETOOTH               = 0x00000041;
const uint FILE_DEVICE_MT_COMPOSITE            = 0x00000042;
const uint FILE_DEVICE_MT_TRANSPORT            = 0x00000043;
const uint FILE_DEVICE_BIOMETRIC               = 0x00000044;
const uint FILE_DEVICE_PMI                     = 0x00000045;
const uint FILE_DEVICE_EHSTOR                  = 0x00000046;
const uint FILE_DEVICE_DEVAPI                  = 0x00000047;
const uint FILE_DEVICE_GPIO                    = 0x00000048;
const uint FILE_DEVICE_USBEX                   = 0x00000049;
const uint FILE_DEVICE_CONSOLE                 = 0x00000050;
const uint FILE_DEVICE_NFP                     = 0x00000051;
const uint FILE_DEVICE_SYSENV                  = 0x00000052;
const uint FILE_DEVICE_VIRTUAL_BLOCK           = 0x00000053;
const uint FILE_DEVICE_POINT_OF_SERVICE        = 0x00000054;
const uint FILE_DEVICE_STORAGE_REPLICATION     = 0x00000055;
const uint FILE_DEVICE_TRUST_ENV               = 0x00000056;
const uint FILE_DEVICE_UCM                     = 0x00000057;
const uint FILE_DEVICE_UCMTCPCI                = 0x00000058;
const uint FILE_DEVICE_PERSISTENT_MEMORY       = 0x00000059;
const uint FILE_DEVICE_NVDIMM                  = 0x0000005a;
const uint FILE_DEVICE_HOLOGRAPHIC             = 0x0000005b;
const uint FILE_DEVICE_SDFXHCI                 = 0x0000005c;
const uint FILE_DEVICE_UCMUCSI                 = 0x0000005d;
const uint FILE_DEVICE_PRM                     = 0x0000005e;
const uint FILE_DEVICE_EVENT_COLLECTOR         = 0x0000005f;
const uint FILE_DEVICE_USB4                    = 0x00000060;
const uint FILE_DEVICE_SOUNDWIRE               = 0x00000061;
const uint FILE_DEVICE_FABRIC_NVME             = 0x00000062;
const uint FILE_DEVICE_SVM                     = 0x00000063;
const uint FILE_DEVICE_HARDWARE_ACCELERATOR    = 0x00000064;
const uint FILE_DEVICE_I3C                     = 0x00000065;

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

extern fn NtStatus ioCreateDevice(
  DriverObject*  driver_object,
  ulong          device_extension_size,
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

extern fn void ioDeleteDevice(
  DeviceObject* device_object
) @cname("IoDeleteDevice");

extern fn NtStatus ioDeleteSymbolicLink(
  UnicodeString* symbolic_link_name
) @cname("IoDeleteSymbolicLink");
