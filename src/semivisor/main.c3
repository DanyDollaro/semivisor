module semivisor;

import wkl::core;
import wkl;
import wdk;
import log;
import wkl::unicode_string;

// TODO: place these macro in a more meaningful file
// macro for testing
macro @funclog(; @body())
{
    log::print($$FUNC +++ " start");
    defer log::print($$FUNC +++ " end");
    @body();
}

macro uint ctl_code(uint device_type, uint function, uint method, uint access)
{
    return (device_type << 16) | (access << 14) | (function << 2) | method;
}

//
// Globals
//

UnicodeString device_name =
    unicode_string::constant("\\Device\\Semivisor");

UnicodeString symbolic_link =
    unicode_string::constant("\\DosDevices\\Semivisor");

//
// Globals
//

// Vmm vmm;

//
// Wrapped driver entries
//

fn void? driver_setup(DriverObject* driver_object, UnicodeString* registry_path)
{
    driver_object.driver_unload = &native_driver_unload;
    driver_object.major_function[wdk::IRP_MJ_CREATE] = &complete_irp_with_success;
    driver_object.major_function[wdk::IRP_MJ_CLOSE] = &complete_irp_with_success;
    driver_object.major_function[wdk::IRP_MJ_DEVICE_CONTROL] = &native_mj_device_control;

    // Create the device object
    DeviceObject* device_object;
    wkl::io_create_device(driver_object, 0, &device_name, wdk::FILE_DEVICE_UNKNOWN,
        wdk::FILE_DEVICE_SECURE_OPEN, true, &device_object)!;
    defer catch wkl::io_delete_device(device_object);

    // Create the symbolic link for usermode applications
    wkl::io_create_symbolic_link(&symbolic_link, &device_name)!;
}

fn void? driver_cleanup(DriverObject* driver_object)
{
    wkl::io_delete_symbolic_link(&symbolic_link)!;
    wkl::io_delete_device(driver_object.device_object);
}

fn NtStatus? device_control(DeviceObject* device_object, Irp* irp)
{
    IoStackLocation* stack = irp.tail.overlay.current_stack_location;
    uint code = stack.parameters.device_io_control.io_control_code;

    log::print("servicing IOCTL %Xh", code);

    irp.io_status.status = wdk::STATUS_SUCCESS;
    irp.io_status.information = 0;

    wkl::io_complete_request(irp, wdk::IO_NO_INCREMENT);
    return wdk::STATUS_SUCCESS;
}

//
// Native driver entries
//

fn NtStatus native_driver_entry(DriverObject* driver_object, UnicodeString* registry_path)
    @export("DriverEntry")
{
    log::init();
    log::print(">>>>>>>>>>>>>>>>>>>> DRIVER COMPILED AT %s %s <<<<<<<<<<<<<<<<<<<<",
        $$DATE, $$TIME);

    return @ok(driver_setup(driver_object, registry_path))
        ? wdk::STATUS_SUCCESS
        : wdk::STATUS_UNSUCCESSFUL;
}

fn void native_driver_unload(DriverObject* driver_object)
{
    if (catch err = driver_cleanup(driver_object))
    {
        log::print("driver cleanup failed aaaaaahhhhh!!! %llXh", err);
    }

    // Print an empty line
    log::print("");
    log::destroy();
}

fn NtStatus native_mj_device_control(DeviceObject* device_object, Irp* irp)
{
    if (catch err = device_control(device_object, irp))
    {
        log::print("device_control failed %llXh", err);

        // TODO: write a function that converts fault to ntstatusses
        return wdk::STATUS_UNSUCCESSFUL;
    }

    return wdk::STATUS_SUCCESS;
}

fn NtStatus complete_irp_with_success(DeviceObject* device_object, Irp* irp) => @funclog()
{
    irp.io_status.status = wdk::STATUS_SUCCESS;
    irp.io_status.information = 0;

    wkl::io_complete_request(irp, wdk::IO_NO_INCREMENT);
    return wdk::STATUS_SUCCESS;
}

// symbols required by the linker to compile
fn void __security_check_cookie(usz cookie) @export("__security_check_cookie") {}
fn void _dllMainCRTStartup() @export("_DllMainCRTStartup") {}
