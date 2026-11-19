local patch = function(plugin)
  local file = plugin.dir .. "/lua/competitest/commands.lua"
  local lines = vim.fn.readfile(file)

  local unpatched = {}
  local patched = {}

  for i, line in ipairs(lines) do
    if line:match("^%s*if add_testcase then%s*$") then
      -- Confirm this block belongs to M.edit_testcase.
      local in_edit_testcase = false

      for j = i - 1, 1, -1 do
        if lines[j]:match("^%s*function M%.edit_testcase%(") then
          in_edit_testcase = true
          break
        end
      end

      if in_edit_testcase then
        local assignment = lines[i + 1]
        local loop = lines[i + 2]
        local increment = lines[i + 3]

        if assignment and loop and increment
          and loop:match("^%s*while tctbl%[tcnum%] do%s*$")
          and increment:match("^%s*tcnum = tcnum %+ 1%s*$")
        then
          if assignment:match("^%s*tcnum = 0%s*$") then
            table.insert(unpatched, i + 1)
          elseif assignment:match("^%s*tcnum = 1%s*$") then
            table.insert(patched, i + 1)
          end
        end
      end
    end
  end

  if #unpatched == 1 and #patched == 0 then
    lines[unpatched[1]] = lines[unpatched[1]]:gsub("tcnum = 0", "tcnum = 1")
    vim.fn.writefile(lines, file)
  elseif #unpatched == 0 and #patched == 1 then
    -- Already patched.
    return
  else
    error(
      "CompetiTest: expected exactly one testcase numbering block; found "
      .. #unpatched .. " unpatched and " .. #patched .. " patched"
    )
  end
end

return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  build = patch,
  opts = {
    compile_command = {
      rust = {
        exec = "cargo",
        args = {"build", "--quiet"},
      },
    },
    run_command = {
      rust = {
        exec = "env",
        args = {"RUST_BACKTRACE=1", "cargo", "run", "--quiet"},
      },
    },
    testcases_directory = "tests",
    testcases_input_file_format = "sample-$(TCNUM).in",
    testcases_output_file_format = "sample-$(TCNUM).out",
  },
}
