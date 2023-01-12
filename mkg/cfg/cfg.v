module cfg

import toml

const deafault_cfg_file = './config/cfg.toml'

// 配置
// config().value('value').string()
// string() | bool() 
// datetime() (toml.DateTime) | date() (toml.Date) | time() (toml.Time)
// f32() | f64() | int() | i64() | u64()
pub fn config() toml.Doc {
    doc := toml.parse_file(deafault_cfg_file) or { panic(err) }
    
    return doc
}

// 解析文本
pub fn parse_text(text string) toml.Doc {
    doc := toml.parse_text(text) or { panic(err) }
    
    return doc
}

// 解析文件
pub fn parse_file(path string) toml.Doc {
    doc := toml.parse_file(path) or { panic(err) }
    
    return doc
}
