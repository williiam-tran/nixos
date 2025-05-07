local persisted = require("persisted")

persisted.setup({
	autoload = true,
	autostart = true,

	telescope = {
		mappings = { -- Mappings for managing sessions in Telescope
			delete_session = "d",
		},
		icons = { -- icons displayed in the Telescope picker
			selected = " ",
			dir = "  ",
			branch = " ",
		},
	},
})
