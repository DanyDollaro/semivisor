import std::io;
import libc;

/* ============================================================================================== */
/* Constants                                                                                      */
/* ============================================================================================== */

const IMAGE_DOS_SIGNATURE = 0x5A4D;

const IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;

const IMAGE_SIZEOF_SHORT_NAME = 8;

enum DataDirectoryType
{
    EXPORT,
    IMPORT,
    RESOURCE,
    EXCEPTION,
    SECURITY,
    BASERELOC,
    DEBUG,
    ARCHITECTURE,
    GLOBALPTR,
    TLS,
    LOAD_CONFIG,
    BOUND_IMPORT,
    IAT,
    DELAY_IMPORT,
    COM_DESCRIPTOR
}

/* ============================================================================================== */
/* Win strctures definition                                                                       */
/* ============================================================================================== */

struct DosHeader @align(2)
{
    ushort e_magic;           // Magic number
    ushort e_cblp;            // Bytes on last page of file
    ushort e_cp;              // Pages in file
    ushort e_crlc;            // Relocations
    ushort e_cparhdr;         // Size of header in paragraphs
    ushort e_minalloc;        // Minimum extra paragraphs needed
    ushort e_maxalloc;        // Maximum extra paragraphs needed
    ushort e_ss;              // Initial (relative) SS valuez
    ushort e_sp;              // Initial SP value
    ushort e_csum;            // Checksum
    ushort e_ip;              // Initial IP value
    ushort e_cs;              // Initial (relative) CS value
    ushort e_lfarlc;          // File address of relocation table
    ushort e_ovno;            // Overlay number
    ushort[4] e_res;          // Reserved words
    ushort e_oemid;           // OEM identifier (for e_oeminfo)
    ushort e_oeminfo;         // OEM information; e_oemid specific
    ushort[10] e_res2;        // Reserved words
    int e_lfanew;             // File address of new exe header
}

struct DataDirectory
{
    uint virtual_address;
    uint size;
}

struct OptionalHeader64
{
    ushort magic;
    char major_linker_version;
    char minor_linker_version;
    uint size_of_code;
    uint size_of_initialized_data;
    uint size_of_uninitialized_data;
    uint address_of_entry_point;
    uint base_of_code;
    ulong image_base;
    uint section_alignment;
    uint file_alignment;
    ushort major_operating_system_version;
    ushort minor_operating_system_version;
    ushort major_image_version;
    ushort minor_image_version;
    ushort major_subsystem_version;
    ushort minor_subsystem_version;
    uint win32_version_value;
    uint size_of_image;
    uint size_of_headers;
    uint check_sum;
    ushort subsystem;
    ushort dll_characteristics;
    ulong size_of_stack_reserve;
    ulong size_of_stack_commit;
    ulong size_of_heap_reserve;
    ulong size_of_heap_commit;
    uint loader_flags;
    uint number_of_rva_and_sizes;
    DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES] data_directory;
}

struct FileHeader
{
    ushort machine;
    ushort number_of_sections;
    uint time_date_stamp;
    uint pointer_to_symbol_table;
    uint number_of_symbols;
    ushort size_of_optional_header;
    ushort characteristics;
}

struct NtHeaders
{
    ushort signature;
    FileHeader file_header;
    OptionalHeader64 optional_header;
}

struct SectionHeader
{
    char[IMAGE_SIZEOF_SHORT_NAME] name;
    union misc
    {
        uint physical_address;
        uint virtual_size;
    }
    uint virtual_address;
    uint size_of_raw_data;
    uint pointer_to_raw_data;
    uint pointer_to_relocations;
    uint pointer_to_linenumbers;
    ushort number_of_relocations;
    ushort number_of_linenumbers;
    uint characteristics;
}

struct ImportDescriptor
{
    union
    {
        uint characteristics;
        uint original_first_thunk;
    }
    uint time_date_stamp;
    uint forwarder_chain;
    uint name;
    uint first_thunk;
}

struct ExportDirectory
{
    uint characteristics;
    uint time_date_stamp;
    ushort major_version;
    ushort minor_version;
    uint name;
    uint base;
    uint number_of_functions;
    uint number_of_names;
    uint address_of_functions;
    uint address_of_names;
    uint address_of_name_ordinals;
}

/* ============================================================================================== */
/* Faults                                                                                         */
/* ============================================================================================== */

faultdef SIGNATURE_MISMATCH, UNABLE_TO_RESOLVE;

/* ============================================================================================== */
/* Methods                                                                                        */
/* ============================================================================================== */

fn usz? rva_to_raw(NtHeaders* nt_headers, usz rva)
{
    SectionHeader* sections_headers =
        (void*)(&nt_headers.optional_header + 1);

    for (usz i = 0; i < nt_headers.file_header.number_of_sections; i++)
    {
        SectionHeader* section_header = &sections_headers[i];

        usz section_beg = section_header.virtual_address;
        usz section_end = section_beg + section_header.misc.virtual_size;

        if ((rva >= section_beg) && (rva < section_end))
        {
            return rva - section_beg + (usz)section_header.pointer_to_raw_data;
        }
    }

    return UNABLE_TO_RESOLVE~;
}

enum LayoutType
{
    RAW,
    VIRTUAL
}

struct PeView
{
    char[] buffer;
    LayoutType layout;
    NtHeaders* nt_headers;
}

enum AddressType
{
    RAW,
    VIRTUAL
}

fn void*? PeView.locate(&self, usz address, AddressType type)
{
    switch (type)
    {
    case AddressType.RAW:
        return (void*)(
            self.buffer.ptr + rva_to_raw(self.nt_headers, address)!!
        );
    case AddressType.VIRTUAL:
        return (void*)(
            self.buffer.ptr + address
        );
    }
}

fn void PeView.set_view(&self, char[] buffer, LayoutType layout)
{
    self.layout = layout;
    self.buffer = buffer;
    self.nt_headers = (void*)(buffer.ptr + ((DosHeader*)buffer.ptr).e_lfanew);
}

fn void*? PeView.get_data_directory(&self, DataDirectoryType type)
{
    // TODO: handle directories wich has RAW address instead of virual ones
    return self.locate(self.nt_headers.optional_header.data_directory[type.ordinal].virtual_address,
        AddressType.RAW);
}

fn ImportDescriptor[] PeView.get_imports(&self)
{
    ImportDescriptor* imports =
        self.get_data_directory(DataDirectoryType.IMPORT)!!;

    usz i = 0;
    while (imports[i].original_first_thunk)
    {
        i++;
    }

    return imports[:i];
}

fn bool compare_zstring(ZString s1, ZString s2)
{
    for (usz i = 0; s1[i] && s2[i]; i++)
    {
        if (s1[i] != s2[i])
        {
            return false;
        }
    }

    return true;
}

fn uint get_driver_ep_rva(PeView* view)
{
    ExportDirectory* export_directory =
        view.get_data_directory(DataDirectoryType.EXPORT)!!;

    uint* functions =
        view.locate(export_directory.address_of_functions, AddressType.RAW)!!;
    ushort* ordinals =
        view.locate(export_directory.address_of_name_ordinals, AddressType.RAW)!!;
    uint* names =
        view.locate(export_directory.address_of_names, AddressType.RAW)!!;

    for (usz i = 0; i < export_directory.number_of_functions; i++)
    {
        uint n = mem::load(&names[ordinals[i]], 1);
        if (compare_zstring((ZString)view.locate(n, AddressType.RAW)!!, "DriverEntry"))
        {
            return mem::load(&functions[i], 1);
        }
    }

    return 0;
}

// This function remove all the user mode imports and write the kernel ones at the start of the iat
fn void crop_kernel_imports(PeView* view)
{
    // TODO: test with multiple kernel imports
    ZString[1] kernel_imports =
    {
        "ntoskrnl.exe"
        // "hal.dll",
        // "win32k.sys"
    };
    ImportDescriptor[kernel_imports.len] descriptors_copies;
    uint found_imports = 0;

    ImportDescriptor* imports =
        view.get_data_directory(DataDirectoryType.IMPORT)!!;

    for (usz i = 0; imports[i].original_first_thunk; i++)
    {
        ZString module_name = (ZString)view.locate(imports[i].name, AddressType.RAW)!!;
        for (usz j = 0; j < kernel_imports.len; j++)
        {
            if (compare_zstring(module_name, kernel_imports[j]))
            {
                mem::copy(&descriptors_copies[j], imports + i, ImportDescriptor.sizeof);
                found_imports++;
            }
        }
    }

    mem::copy(imports, &descriptors_copies, ImportDescriptor.sizeof * kernel_imports.len);
    mem::clear(imports + kernel_imports.len, ImportDescriptor.sizeof);

    // Fix the IAT size
    view.nt_headers.optional_header.data_directory[DataDirectoryType.IMPORT.ordinal].size =
        ImportDescriptor.sizeof * found_imports;
}

// C3C usually generate executable with section pretection set to 0, this causes bsods
// when the windows laoder tries to load the driver
fn void fix_section_protection(PeView* view)
{
    SectionHeader* sections = (void*)(view.nt_headers + 1);
    for (usz i = 0; i < view.nt_headers.file_header.number_of_sections; i++)
    {
        if (!sections[i].characteristics)
        {
            // Set the section as readable
            sections[i].characteristics |= 0x40000040;
        }
    }
}

fn int main(String[] args)
{
    String target = args[1];

    char[] buffer = io::file::load_buffer(
        target,
        mem::new_array(
            char,
            io::file::get_size(target)
        )
    )!!;
    defer mem::free(buffer.ptr);

    PeView view;
    view.set_view(buffer, LayoutType.RAW);

    // Set PE subsystem
    view.nt_headers.optional_header.subsystem = 1; // Driver

    // Set the Check Integrity flag into DllCharacteristics
    view.nt_headers.optional_header.dll_characteristics = 0x1E0;

    // Set the driver entry point
    view.nt_headers.optional_header.address_of_entry_point =
        get_driver_ep_rva(&view);

    // Rebuild the iat leaving only the kernel imports
    crop_kernel_imports(&view);

    // Fix the section protection
    fix_section_protection(&view);

    // Zero out TLS directory data
    view.nt_headers.optional_header.data_directory[DataDirectoryType.TLS.ordinal].size            = 0;
    view.nt_headers.optional_header.data_directory[DataDirectoryType.TLS.ordinal].virtual_address = 0;

    // Zero out load config directory data
    view.nt_headers.optional_header.data_directory[DataDirectoryType.LOAD_CONFIG.ordinal].size            = 0;
    view.nt_headers.optional_header.data_directory[DataDirectoryType.LOAD_CONFIG.ordinal].virtual_address = 0;

    // Write the modified PE to disk
    String name = target[0 : target.len - 4].tconcat(".sys");
    File fout = io::file::open(name, "wb")!!;
    fout.write(view.buffer)!!;
    fout.close()!!;

    return 0;
}

