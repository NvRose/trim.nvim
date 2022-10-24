return function(trim)
	local patterns = {}
	local group = vim.api.nvim_create_augroup('NvRoseTrim', { clear = true })

	if trim.trailing then
		table.insert(patterns, 1, [[ %s/\s\+$//e ]])
	end

	if trim.last_line then
		table.insert(patterns, [[%s/\($\n\s*\)\+\%$//]])
	end

	if trim.first_line then
		table.insert(patterns, [[%s/\%^\n\+//]])
	end

	vim.api.nvim_create_autocmd('BufWritePre', {
		group = group,
		pattern = '*',
		callback = function()
			local view = vim.fn.winsaveview()

			for _, v in ipairs(patterns) do
				vim.api.nvim_exec('keepjumps keeppatterns silent!' .. v, false)
			end

			vim.fn.winrestview(view)
		end
	})
end
