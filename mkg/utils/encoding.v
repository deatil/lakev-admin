module utils

import encoding.base32
import encoding.base58
import encoding.base64

// base32_encode
pub fn base32_encode(s string) string {
    return base32.encode_string_to_string(s)
}

// base32_decode
pub fn base32_decode(s string) string {
    res := base32.decode_string_to_string(s) or { '' }
    return res
}

// base32_encode_no_padding
pub fn base32_encode_no_padding(s string) string {
    encoder_no_padding := base32.new_std_encoding_with_padding(base32.no_padding)
    encoded := encoder_no_padding.encode_string_to_string(s)
    
    return encoded
}

// base32_decode_no_padding
pub fn base32_decode_no_padding(s string) string {
    encoder_no_padding := base32.new_std_encoding_with_padding(base32.no_padding)
    decoded := encoder_no_padding.decode_string_to_string(s) or { '' }
    
    return decoded
}

// ================

// base58_encode
pub fn base58_encode(s string) string {
    return base58.encode(s)
}

// base58_decode
pub fn base58_decode(s string) string {
    res := base58.decode(s) or { '' }
    return res
}

// ================

// base64_encode
pub fn base64_encode(s string) string {
    return base64.encode_str(s)
}

// base64_decode
pub fn base64_decode(s string) string {
    return base64.decode_str(s)
}

// base64_url_encode
pub fn base64_url_encode(s string) string {
    return base64.url_encode_str(s)
}

// base64_url_decode
pub fn base64_url_decode(s string) string {
    return base64.url_decode_str(s)
}
