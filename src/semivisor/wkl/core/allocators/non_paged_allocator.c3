module wkl::core::allocators::non_paged_allocator;

import wdk;
import wkl::core::mem;
import wkl::core::alloc;

struct NonPagedAllocator (Allocator)
{
    char dummy;
}

fn void*? NonPagedAllocator.acquire(&self, usz size, uint tag) @dynamic
{
    return alloc::alloc_non_paged(size, tag);
}

fn void NonPagedAllocator.release(&self, void* ptr, uint tag) @dynamic
{
    wdk::exFreePoolWithTag(ptr, tag);
}

