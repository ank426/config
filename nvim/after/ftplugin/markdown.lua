local function get_link_dest()
  local node = vim.treesitter.get_node({ ignore_injections = false })
  while node and node:type() ~= "inline_link" do
    node = node:parent()
  end
  if not node or node:type() ~= "inline_link" then
    return nil
  end
  for child in node:iter_children() do
    if child:type() == "link_destination" then
      return vim.treesitter.get_node_text(child, 0)
    end
  end
end

vim.keymap.set("n", "gf", function()
  local link_dest = get_link_dest()
  if link_dest then
    local path = vim.fn.expand("%:p:h").."/"..link_dest
    if vim.uv.fs_stat(path) then
      vim.cmd.edit(vim.fn.fnameescape(path))
    else
      vim.notify("File not found: "..path, vim.log.levels.WARN)
    end
  else
    vim.cmd.normal({ "gf", bang = true })
  end
end, { buffer = true, desc = "[G]o to [F]ile (Advanced)" })

vim.keymap.set("n", "<C-]>", function()
  local link_dest = get_link_dest()
  if link_dest and link_dest:sub(1, 1) == [[#]] then
    vim.cmd.normal({ "m'", bang = true })
    link_dest = link_dest:sub(2):gsub("-", "[- ]*"):gsub("_", "[_ ]*")
    vim.fn.search("\\c^#\\+ *"..link_dest, "w")
  else
    vim.cmd.normal({ "<C-]>", bang = true })
  end
end, { buffer = true, desc = "Go to Section (Advanced)"})
