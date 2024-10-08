return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
	config = function ()
			local function truncate_branch_name(branch)
				if not branch or branch == "" then
					return ""
				end

				-- Match the branch name to the specified format
				local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

				-- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
				if ticket_number then
					return "sko-" .. ticket_number
				else
					return branch
				end
			end

		require('lualine').setup({
			options = {
				theme = "catppuccin",
				globalstatus = true,
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_b = {
					{ "branch", icon = "", fmt = truncate_branch_name },
					"diagnostics",
				},
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					"filetype",
				},
			},
		})
	end,
}
