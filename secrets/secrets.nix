let
  tyllm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdsPdb4tRdqO/kcE8ofroHzzLSzU+XN3iXtea4GSv4M";
  users = [ tyllm ];
in
{
  "miniflux-creds.age".publicKeys = [ tyllm ];
}

