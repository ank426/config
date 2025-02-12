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
      -- for python, I have the defaults without * imports (throw warning in ruff) and without conflicts
      -- rest I have just a few common ones
      python3 = {
        -- before = true, -- Default imports which only work for python and java
        before = {
          "# Imports:",
          "import string # noqa: F401",
          "import re #noqa: F401",
          "import datetime #noqa: F401",
          "import collections #noqa: F401",
          "from collections import deque, defaultdict, namedtuple #noqa: F401",
          "import heapq #noqa: F401",
          "import bisect #noqa: F401",
          "import copy #noqa: F401",
          "import math #noqa: F401",
          "import random #noqa: F401",
          "import statistics #noqa: F401",
          "import itertools #noqa: F401",
          "import functools #noqa: F401",
          "import operator #noqa: F401",
          "import io #noqa: F401",
          "import sys #noqa: F401",
          "import json #noqa: F401",
          -- typing.__dir__() except things that start with '_' and things that conflict with above imports
          "from typing import ABCMeta, AbstractSet, Annotated, Any, AnyStr, AsyncGenerator, AsyncIterable, AsyncIterator, Awaitable, BinaryIO, ByteString, CT_co, Callable, ChainMap, ClassVar, Collection, Concatenate, Container, Coroutine, Counter, DefaultDict, Deque, Dict, EXCLUDED_ATTRIBUTES, Final, ForwardRef, FrozenSet, Generator, Generic, GenericAlias, Hashable, IO, ItemsView, Iterable, Iterator, KT, KeysView, List, Literal, LiteralString, Mapping, MappingView, MethodDescriptorType, MethodWrapperType, MutableMapping, MutableSequence, MutableSet, NamedTuple, NamedTupleMeta, Never, NewType, NoDefault, NoReturn, NotRequired, Optional, OrderedDict, ParamSpec, ParamSpecArgs, ParamSpecKwargs, Protocol, ReadOnly, Required, Reversible, Self, Sequence, Set, Sized, SupportsAbs, SupportsBytes, SupportsComplex, SupportsFloat, SupportsIndex, SupportsInt, SupportsRound, T, TYPE_CHECKING, T_co, T_contra, Text, TextIO, Tuple, Type, TypeAlias, TypeAliasType, TypeGuard, TypeIs, TypeVar, TypeVarTuple, TypedDict, Union, Unpack, VT, VT_co, V_co, ValuesView, WrapperDescriptorType, abstractmethod, assert_never, assert_type, cast, clear_overloads, copyreg, dataclass_transform, final, get_args, get_origin, get_overloads, get_protocol_members, get_type_hints, is_protocol, is_typeddict, no_type_check, no_type_check_decorator, overload, override, reveal_type, runtime_checkable, types # noqa: F401, E501",
        },
      },
      c = { -- There's also address sanitizer
        before = {
          "// Includes:",
          "// IWYU pragma: begin_keep",
          "#include <stdbool.h>",
          "#include <stdio.h>",
          "#include <stdlib.h>",
          "#include <ctype.h>",
          "#include <limits.h>",
          "#include <math.h>",
          "#include <string.h>",
          "#include <time.h>",
          -- "#include <uthash.h>", -- haven't installed
          "// IWYU pragma: end_keep",
        },
      },
      cpp = {
        before = {
          "// Includes:",
          "// IWYU pragma: begin_keep",
          "#include <iostream>",
          "#include <string>",
          "#include <vector>",
          "#include <algorithm>",
          "#include <map>",
          "#include <cmath>",
          "#include <memory>",
          "#include <fstream>",
          "#include <chrono>",
          "#include <thread>",
          "#include <stdexcept>",
          "// IWYU pragma: end_keep",
          "using namespace std;",
        },
      },
    },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)

    vim.keymap.set("n", "<leader>c", "<cmd>Leet console<cr>")
    vim.keymap.set("n", "<leader>d", "<cmd>Leet desc<cr>")
    vim.keymap.set("n", "<leader>D", "<cmd>Leet desc stats<cr>")
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
    vim.keymap.set("n", "<leader><leader>l", "<cmd>Leet list<cr>") -- optional args: status, difficulty (i think)
    vim.keymap.set("n", "<leader><leader>r", "<cmd>Leet random<cr>") -- optional args: status, difficulty, tags (i think)
    vim.keymap.set("n", "<leader><leader>t", "<cmd>Leet tabs<cr>")
    vim.keymap.set("n", "<leader><leader>y", "<cmd>Leet yank<cr>")
    vim.keymap.set("n", "<leader><leader>sn", "<cmd>Leet session create<cr>")
    vim.keymap.set("n", "<leader><leader>sc", "<cmd>Leet session change<cr>")
    vim.keymap.set("n", "<leader><leader>su", "<cmd>Leet session update<r>")
  end,
}

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
