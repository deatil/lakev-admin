module response

import vweb

struct ResultJson[T] {
    code    int 
    message string
    data    T
}

// 返回 json
pub fn return_json[T](mut ctx vweb.Context, code int, message string, data T) vweb.Result {
    res := ResultJson[T]{
        code:    code 
        message: message
        data:    data
    }

    return ctx.json(res)
}

// 返回 json
pub fn json_success[T](mut ctx vweb.Context, message string, data T) vweb.Result {
    return return_json(mut ctx, 0, message, data)
}

// 返回 json
pub fn json_error[T](mut ctx vweb.Context, message string, data T) vweb.Result {
    return return_json(mut ctx, 1, message, '')
}
