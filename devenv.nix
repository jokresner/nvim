{ pkgs, lib, config, ... }:

{
  packages = [
    pkgs.neovim
    pkgs.stylua
  ];

  # Unit tests for lua/core and lua/langs (mini.test, no plugins loaded).
  # Needs mini.nvim, which lazy.nvim installs on the first normal start of this config.
  scripts.run-tests.exec = ''
    nvim --headless -u NONE -l tests/run.lua
  '';

  scripts.format.exec = ''
    stylua lua tests init.lua
  '';

  # Runs the test suite before every commit (installed when you enter the devenv shell).
  git-hooks.hooks.run-tests = {
    enable = true;
    name = "nvim tests";
    entry = lib.getExe config.scripts.run-tests.package;
    language = "system";
    pass_filenames = false;
    files = "\\.lua$";
  };

  # `devenv test`
  enterTest = ''
    run-tests
  '';
}
