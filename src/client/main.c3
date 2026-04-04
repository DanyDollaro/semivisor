import std::io;
import std::os::win32;

const GENERIC_READ = 0x80000000L;
const GENERIC_WRITE = 0x40000000L;
const GENERIC_EXECUTE = 0x20000000L;
const GENERIC_ALL   = 0x10000000L;
const FILE_SHARE_READ  = 0x00000001;
const FILE_SHARE_WRITE = 0x00000002;
const FILE_SHARE_DELETE = 0x00000004;
const OPEN_EXISTING = 3;
const FILE_ATTRIBUTE_NORMAL = 0x00000080;

const uint FILE_DEVICE_UNKNOWN = 0x00000022;

const uint METHOD_BUFFERED   = 0;
const uint METHOD_IN_DIRECT  = 1;
const uint METHOD_OUT_DIRECT = 2;
const uint METHOD_NEITHER    = 3;

const uint FILE_ANY_ACCESS   = 0;

macro uint ctl_code(uint device_type, uint function, uint method, uint access)
{
    return (device_type << 16) | (access << 14) | (function << 2) | method;
}

const uint IOCTL_CODE_DO_SOMETHNIG = (0x22 << 16) | (0 << 14) | (0x800 << 2) | 3;
const uint IOCTL_CODE_DO_SOMETHNIG2 = (0x22 << 16) | (0 << 14) | (0x812 << 2) | 3;

extern fn bool deviceIoControl(
  Win32_HANDLE       hDevice,
  Win32_DWORD        dwIoControlCode,
  Win32_LPVOID       lpInBuffer,
  Win32_DWORD        nInBufferSize,
  Win32_LPVOID       lpOutBuffer,
  Win32_DWORD        nOutBufferSize,
  Win32_LPDWORD      lpBytesReturned,
  Win32_LPOVERLAPPED lpOverlapped
) @cname("DeviceIoControl");

fn int main(String[] args)
{
    Win32_HANDLE device = win32::createFileA(
        "\\\\.\\Semivisor",
        GENERIC_READ | GENERIC_WRITE,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        null,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        null
    );

    if (!device)
    {
        uint error = win32::getLastError();
        io::printfn("Error while opening the file %Xh", error);
        return error;
    }

    deviceIoControl(device, IOCTL_CODE_DO_SOMETHNIG, null, 0, null, 0, null, null);
    deviceIoControl(device, IOCTL_CODE_DO_SOMETHNIG2, null, 0, null, 0, null, null);
    win32::closeHandle(device);

    return 0;
}
