-- All languages live in lua/langs/<name>.lua as plain data; core.lang turns them into specs.
local lang = require("core.lang")
lang.setup_options()
return lang.specs(lang.registry())
