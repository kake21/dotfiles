{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "nvex";
        sshUser = "remotebuild";
        sshKey = "/root/.ssh/remotemachine";

        system = "x86_64-linux";

        supportedFeatures = [
          "nixos-test"
          "big-parallel"
          "kvm"
        ];

        maxJobs = 1;
      }
    ];

    settings.builders-use-substitutes = true;
  };
}