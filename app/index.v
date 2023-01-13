module app

import vweb
import mkg.time

['/'; get]
pub fn (mut app App) index() vweb.Result {
    datetime := time.parse('2022-12-05 12:13:45').to_date_time_string()
    println(datetime)
    
    return $vweb.html()
}
