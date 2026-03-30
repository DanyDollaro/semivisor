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

alias DeviceObject = void*;
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

