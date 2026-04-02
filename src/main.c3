module semivisor;

import wkk::core;
import wkk;
import wdk;
import log;

//
// Globals
//

// TODO: create a macro to create constant wide strings
UnicodeString device_name =
{
    .length = 36,
    .maximum_length = 38,
    .buffer = &&$$wstr16("\\Device\\Semivisor")
};

UnicodeString symbolic_link =
{
    .length = 42,
    .maximum_length = 44,
    .buffer = &&$$wstr16("\\DosDevices\\Semivisor")
};

//
// Wrapped driver entries
//

fn void? driver_setup(DriverObject* driver_object, UnicodeString* registry_path)
{
    driver_object.driver_unload = &driver_unload;

    // Create the device object
    DeviceObject* device_object;
    wkk::io_create_device(driver_object, 0, &device_name, wdk::FILE_DEVICE_UNKNOWN,
        wdk::FILE_DEVICE_SECURE_OPEN, true, &device_object)!;
    defer catch wkk::io_delete_device(device_object);

    // Create the symbolic link for usermode applications
    wkk::io_create_symbolic_link(&symbolic_link, &device_name)!;

    driver_object.major_function[wdk::IRP_MJ_CREATE] = null;
    driver_object.major_function[wdk::IRP_MJ_CLOSE] = null;
    driver_object.major_function[wdk::IRP_MJ_DEVICE_CONTROL] = &irp_driver_device_io_control;
    driver_object.major_function[wdk::IRP_MJ_CREATE] = null;
}

fn void? driver_cleanup(DriverObject* driver_object)
{
    wkk::io_delete_symbolic_link(&symbolic_link)!;
    wkk::io_delete_device(driver_object.device_object);
}

fn NtStatus? driver_device_io_control(DeviceObject* device_object, Irp* irp)
{
    wkk::io_complete_request(irp, wdk::IO_NO_INCREMENT);

    return wdk::STATUS_SUCCESS;
}

//
// Native driver entries
//

fn NtStatus driver_entry(DriverObject* driver_object, UnicodeString* registry_path)
    @export("DriverEntry")
{
    log::init();
    log::print(">>>>>>>>>>>>>>>>>>>>>>> DRIVER COMPILED AT %s %s <<<<<<<<<<<<<<<<<<<<<<<",
        $$DATE, $$TIME);

    return @ok(driver_setup(driver_object, registry_path))
        ? wdk::STATUS_SUCCESS
        : wdk::STATUS_UNSUCCESSFUL;
}

fn void driver_unload(DriverObject* driver_object)
{
    if (catch err = driver_cleanup(driver_object))
    {
        log::print("driver cleanup failed aaaaaahhhhh!!! %llXh", err);
    }

    // Print an empty line
    log::print("");
    log::destroy();
}

fn NtStatus irp_driver_device_io_control(DeviceObject* device_object, Irp* irp)
{
    if (catch err = driver_device_io_control(device_object, irp))
    {
        log::print("driver_device_io_control failed %llXh", err);

        // TODO: write a function that converts fault to ntstatusses
        return wdk::STATUS_UNSUCCESSFUL;
    }

    return wdk::STATUS_SUCCESS;
}

// required by the linker to compile
fn void __security_check_cookie(usz cookie) @export("__security_check_cookie")
{
}
