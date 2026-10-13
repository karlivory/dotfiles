-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- { import = "astrocommunity.pack.ansible" }, # annoying error messages
  -- { import = "astrocommunity.pack.helm" }, # annoying error messages
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.yaml" },
}
