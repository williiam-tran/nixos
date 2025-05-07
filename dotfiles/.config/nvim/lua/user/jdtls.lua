-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		"/usr/bin/java", -- or '/path/to/java11_or_newer/bin/java'
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		"/home/tt-tung261/Downloads/jdt-language-server-latest/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
		"-configuration",
		"/home/tt-tung261/Downloads/jdt-language-server-latest/config_linux",
		"-data",
		"/home/tt-tung261/Studycorner/Programming/project/health-first-backend/user-service",
	},

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "mvn", "pom.xml" }),

	settings = {
		java = {},
	},

	init_options = {
		bundles = {
			vim.fn.glob(
				"/home/tt-tung261/Downloads/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.36.0.jar"
			),
		},
	},
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)

config["on_attach"] = function(client, bufnr)
	-- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
	-- you make during a debug session immediately.
	-- Remove the option if you do not want that.
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.setup").add_commands()([[
      command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
      command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
      command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
      command! -buffer JdtJol lua require('jdtls').jol()
      command! -buffer JdtBytecode lua require('jdtls').javap()
      command! -buffer JdtJshell lua require('jdtls').jshell()
  ]])
end
