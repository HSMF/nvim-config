local function Harpoon_files()
  local harpoon = require("harpoon")
  local contents = {}
  local marks_length = harpoon:list():length()
  local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  for index = 1, marks_length do
    local harpoon_file_path = harpoon:list():get(index).value
    local file_name = harpoon_file_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ":t")

    if current_file_path == harpoon_file_path then
      contents[index] = string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, file_name)
    else
      contents[index] = string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, file_name)
    end
  end

  return table.concat(contents)
end

return {
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --
  --   config = function()
  --     require("harpoon"):setup()
  --   end,
  -- },
}
