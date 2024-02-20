local Config = require("config")

return Config:init()
	:append(require("config.base"))
	:append(require("config.theme"))
	:append(require("config.keys"))
	:append(require("config.general"))
	:append(require("config.launch")).options
