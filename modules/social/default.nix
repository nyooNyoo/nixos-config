{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    discordo
  ];
}
