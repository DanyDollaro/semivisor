module wkk::core::builtin;

<*
 Return the excuse in the Optional if it is Empty, otherwise
 return a null fault.
*>
macro fault @catch(#expr) @builtin
{
    if (catch f = #expr) return f;
    return {};
}

<*
 Check if an Optional expression holds a value or is empty, returning true
 if it has a value.
*>
macro bool @ok(#expr) @builtin
{
    if (catch #expr) return false;
    return true;
}

