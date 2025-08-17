return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local sn = ls.snippet_node
    local isn = ls.indent_snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local events = require("luasnip.util.events")
    local ai = require("luasnip.nodes.absolute_indexer")
    local extras = require("luasnip.extras")
    local l = extras.lambda
    local rep = extras.rep
    local p = extras.partial
    local m = extras.match
    local n = extras.nonempty
    local dl = extras.dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local conds = require("luasnip.extras.expand_conditions")
    local postfix = require("luasnip.extras.postfix").postfix
    local types = require("luasnip.util.types")
    local parse = require("luasnip.util.parser").parse_snippet

    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- C snippets
    ls.add_snippets("c", {
      s("main", {
        t({"#include <stdio.h>", "", "int main() {", "    "}),
        i(1, "// Your code here"),
        t({"", "    return 0;", "}"}),
      }),
      
      s("inc", {
        t("#include <"),
        i(1, "stdio.h"),
        t(">"),
      }),
      
      s("incl", {
        t('#include "'),
        i(1, "header.h"),
        t('"'),
      }),
      
      s("for", {
        t("for (int "),
        i(1, "i"),
        t(" = "),
        i(2, "0"),
        t("; "),
        rep(1),
        t(" < "),
        i(3, "n"),
        t("; "),
        rep(1),
        t("++) {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("while", {
        t("while ("),
        i(1, "condition"),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("if", {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("func", {
        i(1, "int"),
        t(" "),
        i(2, "function_name"),
        t("("),
        i(3, "void"),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("struct", {
        t("typedef struct {"),
        t({"", "    "}),
        i(1, "int member;"),
        t({"", "} "}),
        i(2, "struct_name"),
        t(";"),
      }),
    })

    -- C++ snippets
    ls.add_snippets("cpp", {
      s("main", {
        t({"#include <iostream>", "", "int main() {", "    "}),
        i(1, "// Your code here"),
        t({"", "    return 0;", "}"}),
      }),
      
      s("competitive", {
        t({
          "#include <iostream>",
          "#include <vector>",
          "#include <string>",
          "#include <algorithm>",
          "#include <map>",
          "#include <set>",
          "#include <queue>",
          "#include <stack>",
          "#include <cmath>",
          "#include <climits>",
          "",
          "using namespace std;",
          "",
          "int main() {",
          "    ios_base::sync_with_stdio(false);",
          "    cin.tie(NULL);",
          "    ",
        }),
        i(1, "// Your code here"),
        t({"", "    return 0;", "}"}),
      }),
      
      s("class", {
        t("class "),
        i(1, "ClassName"),
        t(" {"),
        t({"", "private:", "    "}),
        i(2, "// Private members"),
        t({"", "", "public:", "    "}),
        i(3, "// Constructor"),
        t({"", "    "}),
        rep(1),
        t("() {"),
        t({"", "        "}),
        i(4, "// Constructor body"),
        t({"", "    }", "", "    "}),
        i(5, "// Destructor"),
        t({"", "    ~"}),
        rep(1),
        t("() {"),
        t({"", "        "}),
        i(6, "// Destructor body"),
        t({"", "    }", "", "    "}),
        i(0, "// Other methods"),
        t({"", "};"}),
      }),
      
      s("inc", {
        t("#include <"),
        i(1, "iostream"),
        t(">"),
      }),
      
      s("incl", {
        t('#include "'),
        i(1, "header.h"),
        t('"'),
      }),
      
      s("for", {
        t("for (int "),
        i(1, "i"),
        t(" = "),
        i(2, "0"),
        t("; "),
        rep(1),
        t(" < "),
        i(3, "n"),
        t("; "),
        rep(1),
        t("++) {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("foreach", {
        t("for (auto "),
        i(1, "item"),
        t(" : "),
        i(2, "container"),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("vector", {
        t("vector<"),
        i(1, "int"),
        t("> "),
        i(2, "vec"),
        t(";"),
      }),
      
      s("map", {
        t("map<"),
        i(1, "string"),
        t(", "),
        i(2, "int"),
        t("> "),
        i(3, "m"),
        t(";"),
      }),
      
      s("func", {
        i(1, "int"),
        t(" "),
        i(2, "function_name"),
        t("("),
        i(3, ""),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("template", {
        t("template<typename "),
        i(1, "T"),
        t(">"),
        t({"", ""}),
        i(2, "void function_name"),
        t("("),
        i(3, "T param"),
        t(") {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("namespace", {
        t("namespace "),
        i(1, "name"),
        t(" {"),
        t({"", "    "}),
        i(0),
        t({"", "}"}),
      }),
      
      s("try", {
        t("try {"),
        t({"", "    "}),
        i(1, "// Code that might throw"),
        t({"", "} catch (const "}),
        i(2, "std::exception"),
        t("& "),
        i(3, "e"),
        t(") {"),
        t({"", "    "}),
        i(0, "// Handle exception"),
        t({"", "}"}),
      }),
    })

    -- Key mappings for snippets
    vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true, desc = "Expand snippet"})
    vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true, desc = "Jump to next snippet placeholder"})
    vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true, desc = "Jump to previous snippet placeholder"})
    vim.keymap.set({"i", "s"}, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, {silent = true, desc = "Change snippet choice"})
  end,
}
