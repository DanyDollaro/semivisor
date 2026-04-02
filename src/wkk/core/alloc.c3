module wkk::core::alloc;

import wdk;
import wkk::core::mem;

faultdef
    FAILED_ALLOCATION;

interface Allocator
{
    // allocate memory
    fn void*? acquire(usz size, uint tag);

    // TODO: reallocate memory
    // fn void*? resize(void* ptr, uint tag, usz new_size);

    // free memory
    fn void release(void* ptr, uint tag);
}

fn void*? alloc_non_paged(usz size, uint tag)
{
    void* p = wdk::exAllocatePool2(wdk::POOL_FLAG_NON_PAGED, size, tag);
    return p
        ? p
        : FAILED_ALLOCATION~;
}

fn void*? realloc_non_paged(void* ptr, usz size, uint tag, usz new_size)
{
    void* p = alloc_non_paged(new_size, tag)!;
    mem::copy(p, ptr, size);
    free_non_paged(ptr, tag);
    return p;
}

fn void free_non_paged(void* ptr, uint tag)
{
    wdk::exFreePoolWithTag(ptr, tag);
}

<*
 @require $Type.alignof <= mem::DEFAULT_MEM_ALIGNMENT : "Types with alignment exceeding the default must use 'new_aligned' instead"
 @require $vacount < 2 : "Too many arguments."
 @require $vacount == 0 ||| $defined($Type t = $vaexpr[0]) : "The second argument must be an initializer for the type"
*>
macro new(Allocator allocator, $Type, ...) @nodiscard
{
    $if $vacount == 0:
        return ($Type*)calloc(allocator, $Type.sizeof);
    $else
        $Type* val = malloc(allocator, $Type.sizeof);
        *val = $vaexpr[0];
        return val;
    $endif
}
