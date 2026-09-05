{ ... }:
{
  services.mako = {
    enable = true;

    settings = {
      anchor = "top-right";
      margin = 10;
      padding = 10;
      "border-size" = 2;
      "border-radius" = 8;
      "default-timeout" = 5000;

      # Toggled by the vshell quick settings panel via
      # `makoctl mode -t do-not-disturb`.
      "mode=do-not-disturb" = {
        invisible = true;
      };
    };
  };
}
