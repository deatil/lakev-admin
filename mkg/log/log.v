module log

import log
import time
import mkg.cfg

const deafault_log_file = './runtime/log/lakev-{Y}-{m}-{d}.log'
const deafault_log_level = 'error'

// 日志
// fatal | error | warn | info | debug
pub fn log() &log.Log {
    mut logger := &log.Log{}

    mut log_file := cfg.config().value('log.log_file').string()
    mut log_level := cfg.config().value('log.log_level').string()
    
    if log_file == '' {
        log_file = deafault_log_file
    }
    if log_level == '' {
        log_level = deafault_log_level
    }
    
    level := level_from_tag(log_level)
    
    logger.set_level(level)
    
    mut now_time := time.now()
    
    mut file := log_file.replace('{Y}', now_time.custom_format('YYYY'))
    file = file.replace('{m}', now_time.custom_format('MM'))
    file = file.replace('{d}', now_time.custom_format('DD'))
    file = file.replace('{H}', time.now().custom_format('hh'))
    file = file.replace('{m}', time.now().custom_format('mm'))
    file = file.replace('{s}', time.now().custom_format('ss'))
    logger.set_full_logpath(file)
    
    return logger
}

// fatal
pub fn fatal(s string) {
    mut logger := log()
    logger.fatal(s)
}

// error
pub fn error(s string) {
    mut logger := log()
    logger.error(s)
    logger.flush()
}

// warn
pub fn warn(s string) {
    mut logger := log()
    logger.warn(s)
    logger.flush()
}

// info
pub fn info(s string) {
    mut logger := log()
    logger.info(s)
    logger.flush()
}

// debug
pub fn debug(s string) {
    mut logger := log()
    logger.debug(s)
    logger.flush()
}

// level
pub fn level_from_tag(tag string) log.Level {
    return match tag {
        'disabled' { log.Level.disabled }
        'fatal' { log.Level.fatal }
        'error' { log.Level.error }
        'warn' { log.Level.warn }
        'info' { log.Level.info }
        'debug' { log.Level.debug }
        else { log.Level.error }
    }
}