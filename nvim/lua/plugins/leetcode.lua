local python_classes = [[
class ListNode:
    def __init__(self, val: int = 0, next: ListNode | None = None) -> None:
        self.val = val
        self.next = next


class TreeNode:
    def __init__(self, val: int = 0, left: TreeNode | None = None, right: TreeNode | None = None) -> None:
        self.val = val
        self.left = left
        self.right = right


class NestedInteger:
    """
    This is the interface that allows for creating nested lists.
    You should not implement it, or speculate about its implementation
    """

    def __init__(self, value: int | None = None) -> None:
        """
        If value is not specified, initializes an empty list.
        Otherwise initializes a single integer equal to value.
        """

    def isInteger(self) -> bool:
        """
        @return True if this NestedInteger holds a single integer, rather than a nested list.
        :rtype bool
        """

    def add(self, elem: NestedInteger) -> None:
        """
        Set this NestedInteger to hold a nested list and adds a nested integer elem to it.
        :rtype void
        """

    def setInteger(self, value: int) -> None:
        """
        Set this NestedInteger to hold a single integer equal to value.
        :rtype void
        """

    def getInteger(self) -> int:
        """
        @return the single integer that this NestedInteger holds, if it holds a single integer.
        The result is undefined if this NestedInteger holds a nested list.
        :rtype int
        """

    def getList(self) -> list[NestedInteger]:
        """
        @return the nested list that this NestedInteger holds, if it holds a nested list.
        The result is undefined if this NestedInteger holds a single integer.
        :rtype List[NestedInteger]
        """
]]

local rust_structs = [[
#![allow(dead_code)]

#[derive(PartialEq, Eq, Clone, Debug)]
pub struct ListNode {
    pub val: i32,
    pub next: Option<Box<ListNode>>,
}

impl ListNode {
    #[inline]
    fn new(val: i32) -> Self {
        ListNode { next: None, val }
    }
}

#[derive(Debug, PartialEq, Eq)]
pub struct TreeNode {
    pub val: i32,
    pub left: Option<std::rc::Rc<std::cell::RefCell<TreeNode>>>,
    pub right: Option<std::rc::Rc<std::cell::RefCell<TreeNode>>>,
}

impl TreeNode {
    #[inline]
    pub fn new(val: i32) -> Self {
        TreeNode {
          val,
          left: None,
          right: None
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
pub enum NestedInteger {
    Int(i32),
    List(Vec<NestedInteger>)
}

struct Solution;
]]

-- Rust: keep <leetcode dir>/Cargo.toml in sync so rust-analyzer gets a real project
-- (and the crates LeetCode provides). See https://github.com/kawre/leetcode.nvim/issues/86
local leetcode_home = vim.fn.stdpath("data") .. "/leetcode"

local function sync_cargo_toml(question)
  if question.lang ~= "rust" then
    return
  end
  if vim.fn.isdirectory(leetcode_home) == 0 then
    return
  end

  local seen = {}
  for name, kind in vim.fs.dir(leetcode_home) do
    if kind == "file" and name:match("%.rs$") then
      seen[name] = true
    end
  end
  -- The hook may fire before leetcode.nvim has written the file to disk
  local current = vim.fs.basename(question:path())
  if current:match("%.rs$") then
    seen[current] = true
  end

  local files = vim.tbl_keys(seen)
  table.sort(files)

  local lines = {
    "[package]",
    'name = "leetcode"',
    'version = "0.1.0"',
    'edition = "2024"',
    "",
    "[dependencies]",
    'rand = "0.8"',
    'regex = "1"',
    'itertools = "0.14"',
    "",
  }
  for _, file in ipairs(files) do
    local bin_name = file:gsub("%.rs$", ""):gsub("[^%w_]", "_"):gsub("^(%d)", "_%1")
    vim.list_extend(lines, {
      "[[bin]]",
      string.format('name = "%s"', bin_name),
      string.format('path = "%s"', file),
      "",
    })
  end
  local content = table.concat(lines, "\n")

  -- Only touch the file when something changed, so rust-analyzer isn't reloaded needlessly
  local cargo_toml_path = leetcode_home .. "/Cargo.toml"
  local existing = io.open(cargo_toml_path, "r")
  local old = existing and existing:read("*a")
  if existing then
    existing:close()
  end
  if old == content then
    return
  end

  local out = io.open(cargo_toml_path, "w")
  if out then
    out:write(content)
    out:close()
    pcall(function()
      vim.cmd("LspRestart rust_analyzer")
    end)
  end
end

return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "leetcode.nvim",
      callback = function()
        vim.opt_local.showbreak = "NONE"
        vim.b.undo_ftplugin = "setlocal sbr<"
      end,
    })
  end,
  opts = {
    lang = "python3",
    injector = {
      python3 = {
        imports = function(default_imports)
          return vim.iter({
            {
              "# ruff: noqa: B905, E741, F401, F403, F405, I001, UP006, UP007, UP029, UP045, ANN001, ANN002, ANN003, ANN201, ANN202, ANN204, ANN205, ANN206, ANN401",
              "# ty: ignore[empty-body, invalid-assignment, invalid-return-type, unresolved-attribute, unused-ignore-comment]",
              "",
            },
            vim.list_slice(default_imports, 1, 7),
            {
              "from math import acos, acosh, asin, asinh, atan, atan2, atanh, cbrt, ceil, comb, copysign, cos, cosh, degrees, dist, e, erf, erfc, exp, exp2, expm1, fabs, factorial, floor, fma, fmod, frexp, fsum, gamma, gcd, hypot, inf, isclose, isfinite, isinf, isnan, isqrt, lcm, ldexp, lgamma, log, log10, log1p, log2, modf, nan, nextafter, perm, pi, prod, radians, remainder, sin, sinh, sqrt, sumprod, tan, tanh, tau, trunc, ulp # noqa: E501"
            }, -- pow fn collides with builtin
            vim.list_slice(default_imports, 9, 12),
            {
              "from operator import abs, add, and_, attrgetter, call, concat, contains, countOf, delitem, eq, floordiv, ge, getitem, gt, iadd, iand, iconcat, ifloordiv, ilshift, imatmul, imod, imul, index, indexOf, inv, invert, ior, ipow, irshift, is_, is_none, is_not, is_not_none, isub, itemgetter, itruediv, ixor, le, length_hint, lshift, lt, matmul, methodcaller, mod, mul, ne, neg, not_, or_, pos, rshift, setitem, sub, truediv, truth, xor # noqa: E501"
            }, -- pow fn collides with builtin
            vim.list_slice(default_imports, 14, #default_imports - 1),
            {
              "",
              "from typing import AbstractSet, Annotated, Any, AnyStr, AsyncGenerator, AsyncIterable, AsyncIterator, Awaitable, BinaryIO, ByteString, Callable, ChainMap, ClassVar, Collection, Concatenate, Container, Coroutine, DefaultDict, Deque, Dict, Final, FrozenSet, Generator, Generic, Hashable, IO, ItemsView, Iterable, Iterator, KeysView, List, Literal, LiteralString, Mapping, MappingView, Match, MutableMapping, MutableSequence, MutableSet, NamedTuple, Never, NewType, NoDefault, NoReturn, NotRequired, Optional, OrderedDict, ParamSpec, ParamSpecArgs, ParamSpecKwargs, Protocol, ReadOnly, Required, Reversible, Self, Sequence, Set, Sized, SupportsAbs, SupportsBytes, SupportsComplex, SupportsFloat, SupportsIndex, SupportsInt, SupportsRound, TYPE_CHECKING, Text, TextIO, Tuple, Type, TypeAlias, TypeAliasType, TypeGuard, TypeIs, TypeVar, TypeVarTuple, TypedDict, Union, Unpack, ValuesView, assert_never, assert_type, cast, clear_overloads, dataclass_transform, evaluate_forward_ref, final, get_args, get_origin, get_overloads, get_protocol_members, get_type_hints, is_protocol, is_typeddict, no_type_check, overload, override, reveal_type, runtime_checkable # noqa: UP035, E501",
              "",
            }, -- Counter collides with collections
            vim.split(python_classes, "\n"),
          }):flatten():totable()
        end,
      },
      c = {
        imports = function(_)
          return {
            "// IWYU pragma: begin_keep",
            "#include <stdbool.h>",
            "#include <stdio.h>",
            "#include <stdlib.h>",
            "#include <ctype.h>",
            "#include <inttypes.h>",
            "#include <limits.h>",
            "#include <math.h>",
            "#include <string.h>",
            "#include <time.h>",
            -- "#include <uthash.h>", -- haven't installed
            "// IWYU pragma: end_keep",
          }
        end
      },
      rust = {
        imports = function(_)
          return vim.split(rust_structs, "\n")
        end,
        after = {
          "fn main() {}",
        },
      }
    },
    hooks = {
      question_enter = { sync_cargo_toml },
    },
    -- image_support = true,
  },
  config = function(_, opts)
    require("leetcode").setup(opts)

    -- local image = require("image")
    -- local from_url = image.from_url
    -- local pending_inversions = {}
    --
    -- local function configure_leetcode_image(img, inverted_path, window, callback)
    --   img.path = inverted_path
    --   img.original_path = inverted_path
    --   img.resized_path = inverted_path
    --   img.cropped_path = inverted_path
    --   img.source_format = "png"
    --   img.last_modified = vim.fn.getftime(inverted_path)
    --   img.resize_hash = nil
    --   img.crop_hash = nil
    --   img.transform_key = nil
    --   img.transform_signature = nil
    --   img.pending_transform_key = nil
    --   img.geometry.width = vim.api.nvim_win_get_width(window)
    --   img.max_width_window_percentage = 100
    --   callback(img)
    -- end
    --
    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- image.from_url = function(url, image_opts, callback)
    --   local buffer = image_opts and image_opts.buffer
    --   if not buffer or not vim.api.nvim_buf_is_valid(buffer) or vim.bo[buffer].filetype ~= "leetcode.nvim" then
    --     return from_url(url, image_opts, callback)
    --   end
    --
    --   return from_url(url, image_opts, function(img)
    --     if not img or not image_opts.window or not vim.api.nvim_win_is_valid(image_opts.window) then
    --       return callback(img)
    --     end
    --
    --     local source_path = img.path
    --     if source_path:sub(-#"-inverted.png") == "-inverted.png" then
    --       return configure_leetcode_image(img, source_path, image_opts.window, callback)
    --     end
    --
    --     local inverted_path = source_path:gsub("(%.[^./]+)$", "-inverted.png")
    --     if source_path == inverted_path then
    --       vim.notify("Unable to determine an output path for LeetCode image inversion", vim.log.levels.ERROR)
    --       return callback(nil)
    --     end
    --
    --     if vim.uv.fs_stat(inverted_path) then
    --       return configure_leetcode_image(img, inverted_path, image_opts.window, callback)
    --     end
    --
    --     pending_inversions[inverted_path] = pending_inversions[inverted_path] or {}
    --     table.insert(pending_inversions[inverted_path], { image = img, window = image_opts.window, callback = callback })
    --     if #pending_inversions[inverted_path] > 1 then
    --       return
    --     end
    --
    --     vim.system({ "magick", source_path, "-channel", "RGB", "-negate", "+channel", inverted_path }, {}, function(result)
    --       vim.schedule(function()
    --         local waiters = pending_inversions[inverted_path]
    --         pending_inversions[inverted_path] = nil
    --
    --         if result.code ~= 0 then
    --           vim.notify("Failed to invert LeetCode image: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
    --           for _, waiter in ipairs(waiters) do
    --             waiter.callback(nil)
    --           end
    --           return
    --         end
    --
    --         for _, waiter in ipairs(waiters) do
    --           configure_leetcode_image(waiter.image, inverted_path, waiter.window, waiter.callback)
    --         end
    --       end)
    --     end)
    --   end)
    -- end

    vim.opt.signcolumn = "auto:1-9"

    vim.keymap.set("n", "<leader>c", "<cmd>Leet console<cr>")
    vim.keymap.set("n", "<leader>d", "<cmd>Leet desc<cr>")
    vim.keymap.set("n", "<leader>D", "<cmd>Leet desc stats<cr>")
    vim.keymap.set("n", "<leader>f", "<cmd>Leet fold<cr>")
    vim.keymap.set("n", "<leader>h", "<cmd>Leet hints<cr>")
    vim.keymap.set("n", "<leader>i", "<cmd>Leet info<cr>")
    vim.keymap.set("n", "<leader>I", "<cmd>Leet inject<cr>")
    vim.keymap.set("n", "<leader>l", "<cmd>Leet lang<cr>")
    vim.keymap.set("n", "<leader>L", "<cmd>Leet last_submit<cr>")
    vim.keymap.set("n", "<leader>m", "<cmd>Leet menu<cr>")
    vim.keymap.set("n", "<leader>o", "<cmd>Leet open<cr>")
    vim.keymap.set("n", "<leader>q", "<cmd>Leet exit<cr>")
    vim.keymap.set("n", "<leader>r", "<cmd>Leet restore<cr>")
    vim.keymap.set("n", "<leader>R", "<cmd>Leet reset<cr>")
    vim.keymap.set("n", "<leader>t", "<cmd>Leet test<cr>")
    vim.keymap.set("n", "<leader><cr>", "<cmd>Leet submit<cr>")
    vim.keymap.set("n", "<leader><leader>d", "<cmd>Leet daily<cr>")
    vim.keymap.set("n", "<leader><leader>r", "<cmd>Leet random<cr>") -- optional args: status, difficulty, tags (i think)
    vim.keymap.set("n", "<leader><leader>t", "<cmd>Leet tabs<cr>")
    vim.keymap.set("n", "<leader><leader>y", "<cmd>Leet yank<cr>")
    vim.keymap.set("n", "<leader><leader>sn", "<cmd>Leet session create<cr>")
    vim.keymap.set("n", "<leader><leader>sc", "<cmd>Leet session change<cr>")
    vim.keymap.set("n", "<leader><leader>su", "<cmd>Leet session update<cr>")
    vim.keymap.set("n", "<leader><leader>la", "<cmd>Leet list<cr>") -- optional args: status, difficulty (i think)
    vim.keymap.set("n", "<leader><leader>le", "<cmd>Leet list difficulty=easy<cr>")
    vim.keymap.set("n", "<leader><leader>lm", "<cmd>Leet list difficulty=medium<cr>")
    vim.keymap.set("n", "<leader><leader>lh", "<cmd>Leet list difficulty=hard<cr>")
    vim.keymap.set("n", "<leader><leader>e", "<cmd>Leet list difficulty=easy status=notac,todo<cr>")
    vim.keymap.set("n", "<leader><leader>m", "<cmd>Leet list difficulty=medium status=notac,todo<cr>")
    vim.keymap.set("n", "<leader><leader>h", "<cmd>Leet list difficulty=hard status=notac,todo<cr>")
  end,
}

-- Images working, but makes whole nvim really buggy when scrolling up

-- Old:
-- Images not working:
-- image_support option in leetcode.nvim
-- ueberzug works fine. the main problem is magick
-- the cli doesn't seem to work even with build = false
-- so you have to use luarocks
-- luarocks is installed by default
-- you need to install magick (it says dev version) for lua5.1. luajit is lua5.1. you don't need lua5.1 installed
-- you need to configure it to work locally, then modify a bunch of paths (luarocks --lua-version 5.1 path)
-- there might be a way to do the paths in nvim itself (check minimal-setup.lua)
-- test this out with $luajit, then require("magick")
-- then, you also need too do stuff to lazy-nvim.lua to make luarocks work (check leetcode.nvim docs)
-- follow image.nvim docs (use ueberzug and not kitty), then try the minimal setup
-- so far it is working
-- but it isn't integrating with leetcode.nvim. The line wrap is turning off (known bug), so it is doing something,
-- but image not displaying.
-- other options I tried are the html, css integratons in image.nvim, but no effect
