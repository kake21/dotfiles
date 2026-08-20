{ ... }:

{
  # Local ad-blocking DNS resolver. Blocky listens on loopback only and
  # NetworkManager is told to prepend it to resolv.conf, with the
  # DHCP-provided nameservers kept as fallback if blocky is ever down.
  networking.networkmanager.insertNameservers = [ "127.0.0.1" ];

  services.blocky = {
    enable = true;
    settings = {
      ports = {
        dns = "127.0.0.1:53";
        http = "127.0.0.1:4000";
      };

      upstreams = {
        groups.default = [
          "1.1.1.1"
          "9.9.9.9"
        ];
        strategy = "parallel_best";
      };

      blocking = {
        denylists.ads = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
        clientGroupsBlock.default = [ "ads" ];
        blockType = "zeroIp";
        loading.refreshPeriod = "24h";
      };

      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };
}
