module time

import time

const (
    date_time_format = "YYYY-MM-DD hh:mm:ss"
    date_format      = "YYYY-MM-DD"
    time_format      = "hh:mm:ss"
)

// 时间处理
struct Time {
    t time.Time
}

pub fn (this Time) to_time() time.Time {
    return this.t
}

pub fn (this Time) to_format_string(s string) string {
    return this.t.custom_format(s)
}

pub fn (this Time) to_date_time_string() string {
    return this.t.custom_format(date_time_format)
}

pub fn (this Time) to_date_string() string {
    return this.t.custom_format(date_format)
}

pub fn (this Time) to_time_string() string {
    return this.t.custom_format(time_format)
}

// 当前时间
pub fn now() Time {
    t := time.now()
    
    return Time{
        t: t
    }
}

// parse
pub fn parse(s string) Time {
    t := time.parse(s) or { time.Time{} }
    
    return Time{
        t: t
    }
}

// parse_rfc3339
pub fn parse_rfc3339(s string) Time {
    t := time.parse_rfc3339(s) or { time.Time{} }
    
    return Time{
        t: t
    }
}

// parse_iso8601
pub fn parse_iso8601(s string) Time {
    t := time.parse_iso8601(s) or { time.Time{} }
    
    return Time{
        t: t
    }
}

// parse_rfc2822
pub fn parse_rfc2822(s string) Time {
    t := time.parse_rfc2822(s) or { time.Time{} }
    
    return Time{
        t: t
    }
}

// from_unix
pub fn from_unix(abs i64) Time {
    t := time.unix(abs)
    
    return Time{
        t: t
    }
}

// from_unix2
pub fn from_unix2(abs i64, microsecond int) Time {
    t := time.unix2(abs, microsecond)
    
    return Time{
        t: t
    }
}

// from_date_time
pub fn from_date_time(year int, month int, day int, hr int, min int, sec int) Time {
    t := time.Time{
        year: year
        month: month
        day: day
        hour: hr
        minute: min
        second: sec
        unix: 0
    }
    
    return Time{
        t: t
    }
}

// from_date
pub fn from_date(year int, month int, day int) Time {
    t := time.Time{
        year: year
        month: month
        day: day
        hour: 0
        minute: 0
        second: 0
        unix: 0
    }
    
    return Time{
        t: t
    }
}

// from_date_time
pub fn from_time(hr int, min int, sec int) Time {
    now_time := time.now()

    year  := now_time.year
    month := now_time.month
    day   := now_time.day
    
    t := time.Time{
        year: year
        month: month
        day: day
        hour: hr
        minute: min
        second: sec
        unix: 0
    }
    
    return Time{
        t: t
    }
}
