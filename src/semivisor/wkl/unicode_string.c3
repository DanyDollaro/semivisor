module wkl::unicode_string;

import wdk;

macro UnicodeString constant($string)
{
    return {
        .length = $string.len,
        .maximum_length = $string.len + 2,
        .buffer = &&$$wstr16($string)
    };
}
