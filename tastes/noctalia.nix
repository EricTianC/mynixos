{lib, pkgs, config, ...}:
{
  programs.noctalia-shell = {
    enable = true;
    # this may also be a string or a path to a JSON file.
  };
}
