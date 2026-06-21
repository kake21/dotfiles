{ config, lib, pkgs, ... }:

let
  llama-cpp = (pkgs.llama-cpp.override {
    cudaSupport = true;
    blasSupport = true;
  }).overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-DGGML_NATIVE=ON"
    ];
    preConfigure = ''
      export NIX_ENFORCE_NO_NATIVE=0
      ${oldAttrs.preConfigure or ""}
    '';
  });
in
{
  environment.systemPackages = [ llama-cpp pkgs.llama-swap ];

  systemd.services.llama-swap = {
    description = "llama-swap - OpenAI compatible proxy with automatic model swapping";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "vegard";
      Group = "users";
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen 0.0.0.0:9292 --watch-config";
      Restart = "always";
      RestartSec = 10;
      Environment = [
        "PATH=/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib"
      ];
    };
  };

  environment.etc."llama-swap/config.yaml".text = ''
    globalTTL: 300
    models:
      "qwen-3.5:9b":
        cmd: |
          ${llama-cpp}/bin/llama-server \
            -m /home/vegard/KI/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q6_K.gguf \
            --port ''${PORT} \
            --ctx-size 32768 \
            --n-gpu-layers 999
  '';
}
