module c3wkt::allocators;

import wdk;

faultdef
    NOT_ENOUGH_MEMORY;

interface Allocator
{
    // allocate memory
    fn void*? acquire(usz size, uint tag);

    // TODO: reallocate memory
    // fn void*? resize(void* ptr, uint tag, usz new_size);

    // free memory
    fn void release(void* ptr, uint tag);
}

struct NonPagedAllocator (Allocator)
{
    char dummy;
}

fn void*? NonPagedAllocator.acquire(&self, usz size, uint tag) @dynamic
{
    void* p = wdk::exAllocatePool2(wdk::POOL_FLAG_NON_PAGED, size, tag);
    return p
        ? p
        : NOT_ENOUGH_MEMORY~;
}

fn void NonPagedAllocator.release(&self, void* ptr, uint tag) @dynamic
{
    wdk::exFreePoolWithTag(ptr, tag);
}

