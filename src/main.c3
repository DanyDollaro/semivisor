module semivisor;

import wdk;
import logger;
import c3wkt; // c3 windows kernel kit

fn void driver_unload(DriverObject* driver_object)
{
    logger::destroy();
}

fn NtStatus driver_entry(DriverObject* driver_object, UnicodeString* registry_path) @export("DriverEntry")
{
    driver_object.driver_unload = &driver_unload;

    logger::init();
    logger::print(">>>>>>>>>>>>>>>>>>>>>>> DRIVER COMPILED AT %s %s <<<<<<<<<<<<<<<<<<<<<<<", $$DATE, $$TIME);



    return wdk::STATUS_SUCCESS;
}
