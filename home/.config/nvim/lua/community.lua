-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- { import = "astrocommunity.pack.ansible" }, # annoying error messages
  -- { import = "astrocommunity.pack.helm" }, # annoying error messages
  -- { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.yaml" },
  -- import/override with your plugins folder
}
