local au = require("funcs.autocmds")

au.define_autocmds({
    TermOpen = {
        ['*'] = {
            -- automatically enter insert mode on new terminals
            'startinsert',
        },
    },
})
