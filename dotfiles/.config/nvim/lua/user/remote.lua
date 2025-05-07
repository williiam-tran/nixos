require("remote-nvim").setup({
	-- Configuration for devpod connections
	devpod = {
		binary = "devpod", -- Binary to use for devpod
		docker_binary = "docker", -- Binary to use for docker-related commands
		---@diagnostic disable-next-line:param-type-mismatch

		dotfiles = {
			path = nil, -- Path to your dotfiles which should be copied into devcontainers
			install_script = nil, -- Install script that should be called to install your dotfiles
		},

		gpg_agent_forwarding = false, -- Should GPG agent be forwarded over the network
		container_list = "running_only", -- How should docker list containers ("running_only" or "all")
	},
	-- Configuration for SSH connections
	ssh_config = {
		ssh_binary = "ssh", -- Binary to use for running SSH command
		scp_binary = "scp", -- Binary to use for running SSH copy commands
		ssh_config_file_paths = { "$HOME/.ssh/config" }, -- Which files should be considered to contain the ssh host configurations. NOTE: `Include` is respected in the provided files.

		-- These are useful for password-based SSH authentication.
		-- It provides parsing pattern for the plugin to detect that an input is requested.
		-- Each element contains the following attributes:
		-- match - The string to match (plain matching is done)
		-- type - Supports two values "plain"|"secret". Secret means when you provide the value, it should not be stored in the completion history of Neovim.
		-- value - Default value for the prompt
		-- value_type - "static"|"dynamic". For things like password, it would be needed for each new connection that the plugin initiates which could be obtrusive.
		-- So, we save the value (only for current session's interval) to ease the process. If set to "dynamic", we do not save the value even for the session. You have to provide a fresh value each time.
		ssh_prompts = {
			{
				match = "password:",
				type = "secret",
				value_type = "static",
				value = "",
			},
			{
				match = "continue connecting (yes/no/[fingerprint])?",
				type = "plain",
				value_type = "static",
				value = "",
			},
			-- There are other values here which can be checked in lua/remote-nvim/init.lua
		},
	},

	progress_view = {
		type = "popup",
	},

	-- Offline mode configuration. For more details, see the "Offline mode" section below.
	offline_mode = {
		-- Should offline mode be enabled?
		enabled = true,
		-- Do not connect to GitHub at all. Not even to get release information.
		no_github = false,
	},

	-- Remote configuration
	remote = {
		app_name = "nvim", -- This directly maps to the value NVIM_APPNAME. If you use any other paths for configuration, also make sure to set this.
		-- List of directories that should be copied over
		copy_dirs = {
			-- else to copy to remote's Neovim config directory
			config = {
				dirs = "*", -- Directories that should be copied over. "*" means all directories. To specify a subset, use a list like {"lazy", "mason"} where "lazy", "mason" are subdirectories
				-- under path specified in `base`.
				compression = {
					enabled = false, -- Should compression be enabled or not
					additional_opts = {}, -- Any additional options that should be used for compression. Any argument that is passed to `tar` (for compression) can be passed here as separate elements.
				},
			},
			-- What to copy to remote's Neovim data directory
			data = {
				dirs = {},
				compression = {
					enabled = true,
				},
			},
			-- What to copy to remote's Neovim cache directory
			cache = {
				dirs = {},
				compression = {
					enabled = true,
				},
			},
			-- What to copy to remote's Neovim state directory
			state = {
				dirs = {},
				compression = {
					enabled = true,
				},
			},
		},
	},
})
