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
    device_object.flags &= ~wdk::DO_DEVICE_INITIALIZING;

    // Create the symbolic link for usermode applications
    wkk::io_create_symbolic_link(&symbolic_link, &device_name)!;
}

fn void? driver_cleanup(DriverObject* driver_object)
{
    wkk::io_delete_symbolic_link(&symbolic_link)!;
    wkk::io_delete_device(driver_object.device_object);
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

