module semivisor;

import wdk;
import serial;

extern fn uint dbgPrintEx(uint component_id, uint level, char* format, ...) @cname("DbgPrintEx");

fn void driver_unload(DriverObject* driver_object)
{

}

fn NtStatus driver_entry(DriverObject* driver_object, UnicodeString* registry_path) @export("DriverEntry")
{
    driver_object.driver_unload = &driver_unload;
    dbgPrintEx(0, 0, "hello");

    serial::init();
    serial::write_string("hellooooooooooo", serial::DEFAULT_COM);

    return wdk::STATUS_SUCCESS;
}
