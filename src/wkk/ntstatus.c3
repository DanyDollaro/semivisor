module wkk::ntstatus;

import wdk;

//
//  Status values are 32 bit values laid out as follows:
//
//   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//  +---+-+-------------------------+-------------------------------+
//  |Sev|C|       Facility          |               Code            |
//  +---+-+-------------------------+-------------------------------+
//
//  where
//
//      Sev - is the severity code
//
//          00 - Success
//          01 - Informational
//          10 - Warning
//          11 - Error
//
//      C - is the Customer code flag
//
//      Facility - is the facility code
//
//      Code - is the facility's status code
//

//
// Generic test for success on any status value (non-negative numbers
// indicate success).
//

macro bool nt_success(NtStatus status)
{
    return status >= 0;
}

//
// Generic test for information on any status value.
//

macro bool nt_information(NtStatus status)
{
    return (status >> 30) == 1;
}

//
// Generic test for warning on any status value.
//

macro bool nt_warning(NtStatus status)
{
    return (status >> 30) == 2;
}

//
// Generic test for error on any status value.
//

macro bool nt_error(NtStatus status)
{
    return (status >> 30) == 3;
}

const APPLICATION_ERROR_MASK       = 0x20000000;
const ERROR_SEVERITY_SUCCESS       = 0x00000000;
const ERROR_SEVERITY_INFORMATIONAL = 0x40000000;
const ERROR_SEVERITY_WARNING       = 0x80000000;
const ERROR_SEVERITY_ERROR         = 0xC0000000;

faultdef
    FAULT_UNSUCCESSFUL,
    FAULT_NOT_IMPLEMENTED,
    FAULT_INVALID_INFO_CLASS,
    FAULT_INFO_LENGTH_MISMATCH,
    FAULT_ACCESS_VIOLATION,
    FAULT_IN_PAGE_ERROR,
    FAULT_INVALID_HANDLE,
    FAULT_INVALID_PARAMETER,
    FAULT_NO_SUCH_DEVICE,
    FAULT_NO_SUCH_FILE,
    FAULT_INVALID_DEVICE_REQUEST,
    FAULT_END_OF_FILE,
    FAULT_MORE_PROCESSING_REQUIRED,
    FAULT_NO_MEMORY,
    FAULT_ACCESS_DENIED,
    FAULT_BUFFER_TOO_SMALL,
    FAULT_OBJECT_NAME_INVALID,
    FAULT_OBJECT_NAME_NOT_FOUND,
    FAULT_OBJECT_NAME_COLLISION,
    FAULT_OBJECT_PATH_NOT_FOUND,
    FAULT_SHARING_VIOLATION,
    FAULT_DELETE_PENDING,
    FAULT_PRIVILEGE_NOT_HELD,
    FAULT_LOGON_FAILURE,
    FAULT_DISK_FULL,
    FAULT_FILE_IS_A_DIRECTORY,
    FAULT_NOT_SUPPORTED,
    FAULT_INTERNAL_ERROR,
    FAULT_INVALID_IMAGE_FORMAT,
    FAULT_DLL_NOT_FOUND,
    FAULT_ENTRYPOINT_NOT_FOUND,
    FAULT_DLL_INIT_FAILED,
    FAULT_CONTROL_C_EXIT,
    FAULT_PIPE_BROKEN,
    FAULT_REGISTRY_CORRUPT,
    FAULT_NO_SUCH_USER,
    FAULT_ACCOUNT_DISABLED,
    FAULT_PASSWORD_EXPIRED,
    FAULT_ACCOUNT_LOCKED_OUT;

fn NtStatus? ntstatus_to_fault(NtStatus status)
{
    if (!nt_error(status))
    {
        return status;
    }

    switch (status)
    {
    case wdk::STATUS_UNSUCCESSFUL:             return FAULT_UNSUCCESSFUL~;
    case wdk::STATUS_NOT_IMPLEMENTED:          return FAULT_NOT_IMPLEMENTED~;
    case wdk::STATUS_INVALID_INFO_CLASS:       return FAULT_INVALID_INFO_CLASS~;
    case wdk::STATUS_INFO_LENGTH_MISMATCH:     return FAULT_INFO_LENGTH_MISMATCH~;
    case wdk::STATUS_ACCESS_VIOLATION:         return FAULT_ACCESS_VIOLATION~;
    case wdk::STATUS_IN_PAGE_ERROR:            return FAULT_IN_PAGE_ERROR~;
    case wdk::STATUS_INVALID_HANDLE:           return FAULT_INVALID_HANDLE~;
    case wdk::STATUS_INVALID_PARAMETER:        return FAULT_INVALID_PARAMETER~;
    case wdk::STATUS_NO_SUCH_DEVICE:           return FAULT_NO_SUCH_DEVICE~;
    case wdk::STATUS_NO_SUCH_FILE:             return FAULT_NO_SUCH_FILE~;
    case wdk::STATUS_INVALID_DEVICE_REQUEST:   return FAULT_INVALID_DEVICE_REQUEST~;
    case wdk::STATUS_END_OF_FILE:              return FAULT_END_OF_FILE~;
    case wdk::STATUS_MORE_PROCESSING_REQUIRED: return FAULT_MORE_PROCESSING_REQUIRED~;
    case wdk::STATUS_NO_MEMORY:                return FAULT_NO_MEMORY~;
    case wdk::STATUS_ACCESS_DENIED:            return FAULT_ACCESS_DENIED~;
    case wdk::STATUS_BUFFER_TOO_SMALL:         return FAULT_BUFFER_TOO_SMALL~;
    case wdk::STATUS_OBJECT_NAME_INVALID:      return FAULT_OBJECT_NAME_INVALID~;
    case wdk::STATUS_OBJECT_NAME_NOT_FOUND:    return FAULT_OBJECT_NAME_NOT_FOUND~;
    case wdk::STATUS_OBJECT_NAME_COLLISION:    return FAULT_OBJECT_NAME_COLLISION~;
    case wdk::STATUS_OBJECT_PATH_NOT_FOUND:    return FAULT_OBJECT_PATH_NOT_FOUND~;
    case wdk::STATUS_SHARING_VIOLATION:        return FAULT_SHARING_VIOLATION~;
    case wdk::STATUS_DELETE_PENDING:           return FAULT_DELETE_PENDING~;
    case wdk::STATUS_PRIVILEGE_NOT_HELD:       return FAULT_PRIVILEGE_NOT_HELD~;
    case wdk::STATUS_LOGON_FAILURE:            return FAULT_LOGON_FAILURE~;
    case wdk::STATUS_DISK_FULL:                return FAULT_DISK_FULL~;
    case wdk::STATUS_FILE_IS_A_DIRECTORY:      return FAULT_FILE_IS_A_DIRECTORY~;
    case wdk::STATUS_NOT_SUPPORTED:            return FAULT_NOT_SUPPORTED~;
    case wdk::STATUS_INTERNAL_ERROR:           return FAULT_INTERNAL_ERROR~;
    case wdk::STATUS_INVALID_IMAGE_FORMAT:     return FAULT_INVALID_IMAGE_FORMAT~;
    case wdk::STATUS_DLL_NOT_FOUND:            return FAULT_DLL_NOT_FOUND~;
    case wdk::STATUS_ENTRYPOINT_NOT_FOUND:     return FAULT_ENTRYPOINT_NOT_FOUND~;
    case wdk::STATUS_DLL_INIT_FAILED:          return FAULT_DLL_INIT_FAILED~;
    case wdk::STATUS_CONTROL_C_EXIT:           return FAULT_CONTROL_C_EXIT~;
    case wdk::STATUS_PIPE_BROKEN:              return FAULT_PIPE_BROKEN~;
    case wdk::STATUS_REGISTRY_CORRUPT:         return FAULT_REGISTRY_CORRUPT~;
    case wdk::STATUS_NO_SUCH_USER:             return FAULT_NO_SUCH_USER~;
    case wdk::STATUS_ACCOUNT_DISABLED:         return FAULT_ACCOUNT_DISABLED~;
    case wdk::STATUS_PASSWORD_EXPIRED:         return FAULT_PASSWORD_EXPIRED~;
    case wdk::STATUS_ACCOUNT_LOCKED_OUT:       return FAULT_ACCOUNT_LOCKED_OUT~;
    }

    // In case the value is not in the switch return a generic fault
    // TODO: maybe create a specific fault to indicate a failed conversion
    return FAULT_UNSUCCESSFUL~;
}

