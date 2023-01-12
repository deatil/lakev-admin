module utils

import crypto.hmac
import crypto.md5
import crypto.sha1
import crypto.sha256
import crypto.sha512

// md5
pub fn md5(s string) string {
    data := md5.sum(s.bytes()).hex().str()
    
    return data
}

// sha1
pub fn sha1(s string) string {
    data := sha1.sum(s.bytes()).hex().str()
    
    return data
}

// sha256
pub fn sha256(s string) string {
    data := sha256.sum(s.bytes()).hex().str()
    
    return data
}

// sha512
pub fn sha512(s string) string {
    data := sha512.sum512(s.bytes()).hex().str()
    
    return data
}

// hmac_md5
pub fn hmac_md5(key []u8, data []u8) string {
    result := hmac.new(key, data, md5.sum, md5.block_size).hex().str()
    
    return result
}

// hmac_sha1
pub fn hmac_sha1(key []u8, data []u8) string {
    result := hmac.new(key, data, sha1.sum, sha1.block_size).hex().str()
    
    return result
}

// hmac_sha256
pub fn hmac_sha256(key []u8, data []u8) string {
    result := hmac.new(key, data, sha256.sum, sha256.block_size).hex().str()
    
    return result
}

// hmac_sha512
pub fn hmac_sha512(key []u8, data []u8) string {
    result := hmac.new(key, data, sha512.sum512, sha512.block_size).hex().str()
    
    return result
}

