module auth

import mkg.cfg
import mkg.utils

pub fn hash_password(password string) string {
    salt := cfg.config().value('auth.salt').string()

    return utils.hash_password_with_salt(password, salt)
}

pub fn compare_password(password string, hashed string) bool {
    salt := cfg.config().value('auth.salt').string()

    return utils.compare_password_with_hash(password, salt, hashed)
}
