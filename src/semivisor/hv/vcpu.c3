module hv::vcpu;

struct Vcpu
{
    // the pointer loaded in rsp
    void* stack;
    // the base allocation of the stack
    void* stack_allocation_base;
    void* msr_bitmap;
    void* io_bitmap_a;
    void* io_bitmap_b;
}


