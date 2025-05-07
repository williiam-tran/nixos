return {
	"tomasiser/vim-code-dark",
	priority = 1000,
	event = "BufReadPre",
	config = function()
		vim.g["codedark_term256"] = 1
		vim.cmd([[
			colorscheme codedark
			hi Comment guifg=#dbaf84
			hi! String guifg=#efa29b
			hi! Search guibg=#658da1
			hi! IncSearch guibg=#658da1
			hi! EasyMotionTarget guifg=#9cdcfe ctermfg=blue
			hi NoiceCmdlinePopupBorderSearch guifg=#9cdcfe
			hi NoiceCmdlineIconSearch guifg=#9cdcfe
	  	]])
	end,
}

-- guibg=#9cdcfe
