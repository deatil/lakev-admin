module utils

import os
import time
import math
import rand
import crypto.rand as crypto_rand

const (
    avatar_max_file_size = 1 * 1024 * 1024 // 1 megabyte
    supported_mime_types = [
        'image/jpeg',
        'image/png',
        'image/webp',
    ]
)

pub const max_safe_unsigned_integer = u32(4_294_967_295)

pub fn hash_password_with_salt(password string, salt string) string {
    password_hashed := sha256(password)
    salted_password := '${password_hashed}${salt}'

    return sha256(salted_password)
}

pub fn compare_password_with_hash(password string, salt string, hashed string) bool {
    return hash_password_with_salt(password, salt) == hashed
}

pub fn set_rand_crypto_safe_seed() {
    first_seed := generate_crypto_safe_int_u32()
    second_seed := generate_crypto_safe_int_u32()

    rand.seed([first_seed, second_seed])
}

pub fn generate_salt() string {
    return rand.i64().str()
}

fn generate_crypto_safe_int_u32() u32 {
    return u32(crypto_rand.int_u64(max_safe_unsigned_integer) or { 0 })
}

pub fn running_since(started_at i64) string {
    duration := time.now().unix - started_at

    seconds_in_hour := 60 * 60

    days := int(math.floor(duration / (seconds_in_hour * 24)))
    hours := int(math.floor(duration / seconds_in_hour % 24))
    minutes := int(math.floor(duration / 60)) % 60
    seconds := duration % 60

    return '${days} 天 ${hours} 小时 ${minutes} 分 ${seconds} 秒'
}

pub fn create_directory_if_not_exists(path string) {
    if !os.exists(path) {
        os.mkdir(path) or { }
    }
}

pub fn calculate_pages(count int, per_page int) int {
    if count == 0 {
        return 0
    }

    return int(math.ceil(f32(count) / f32(per_page))) - 1
}

pub fn generate_prev_next_pages(page int) (int, int) {
    prev_page := if page > 0 { page - 1 } else { 0 }
    next_page := page + 1

    return prev_page, next_page
}

pub fn check_first_page(page int) bool {
    return page == 0
}

pub fn check_last_page(total int, offset int, per_page int) bool {
    return (total - offset) < per_page
}

pub fn validate_avatar_content_type(content_type string) bool {
    return supported_mime_types.contains(content_type)
}

pub fn extract_file_extension_from_mime_type(mime_type string) ?string {
    is_valid_mime_type := validate_avatar_content_type(mime_type)

    if !is_valid_mime_type {
        return error('MIME type is not supported')
    }

    mime_parts := mime_type.split('/')

    return mime_parts[1]
}

pub fn validate_avatar_file_size(content string) bool {
    return content.len <= avatar_max_file_size
}

pub fn pretty_size(size int) string {
    sizes := ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB']
    size_in_bytes := size

    if size_in_bytes == 0 {
        return 'n/a'
    }

    index := int(math.floor(math.log(size_in_bytes) / math.log(1024)))

    if index == 0 {
        return '${size_in_bytes} ${sizes[index]}'
    }

    size_in := math.round_sig(size_in_bytes / (math.pow(1024, index)), 2)

    return '${size_in} ${sizes[index]}'
}