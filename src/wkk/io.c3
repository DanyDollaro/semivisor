module wkk;

import wdk;
import wkk::ntstatus;
import log;

fn NtStatus? io_create_device(
  DriverObject*  driver_object,
  ulong          device_extension_size,
  UnicodeString* device_name,
  uint           device_type,
  uint           device_characteristics,
  bool           exclusive,
  DeviceObject** device_object
) @inline
{
    return ntstatus::ntstatus_to_fault(wdk::ioCreateDevice(driver_object, 0, device_name, wdk::FILE_DEVICE_UNKNOWN,
        wdk::FILE_DEVICE_SECURE_OPEN, true, device_object));
}

fn NtStatus? io_create_symbolic_link(
  UnicodeString* symbolic_link_name,
  UnicodeString* device_name
) @inline
{
    return ntstatus::ntstatus_to_fault(wdk::ioCreateSymbolicLink(symbolic_link_name, device_name));
}

fn void io_delete_device(
  DeviceObject* device_object
) @inline
{
    wdk::ioDeleteDevice(device_object);
}

fn NtStatus? io_delete_symbolic_link(
  UnicodeString* symbolic_link_name
) @inline
{
    return ntstatus::ntstatus_to_fault(wdk::ioDeleteSymbolicLink(symbolic_link_name));
}
