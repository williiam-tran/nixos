[0;1;32m●[0m lan-mouse.service
     Loaded: loaded (]8;;file://william/etc/systemd/user/lan-mouse.service\/etc/systemd/user/lan-mouse.service]8;;\; [0;1;32menabled[0m; preset: ignored)
     Active: [0;1;32mactive (running)[0m since Fri 2025-05-16 01:21:28 +07; 1s ago
 Invocation: ec2649c99a3f498a85f1b4229b6e76f4
   Main PID: 395315 (lan-mouse-start)
      Tasks: 3[0;38;5;245m (limit: 28362)[0m
     Memory: 4.1M (peak: 4.6M)
        CPU: 35ms
     CGroup: /user.slice/user-1001.slice/user@1001.service/app.slice/lan-mouse.service
             ├─[0;38;5;245m395315 /nix/store/xg75pc4yyfd5n2fimhb98ps910q5lm5n-bash-5.2p37/bin/bash /nix/store/wr6wh0rr0jrngsj19gvwpqxiymjfykaq-unit-script-lan-mouse-start/bin/lan-mouse-start[0m
             └─[0;38;5;245m395317 lan-mouse daemon[0m

May 16 01:21:28 william systemd[16831]: Started lan-mouse.service.
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  lan_mouse] using config: "/home/william/.config/lan-mouse/config.toml"
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  lan_mouse] Press [KeyI, KeyE, KeyA] to release the mouse
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  lan_mouse::emulation] creating input emulation ...
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  input_emulation] using emulation backend: wlroots
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z WARN  input_capture] input-capture-portal input capture backend unavailable: error creating input-capture-portal backend: `xdg-desktop-portal: `A portal frontend implementing `org.freedesktop.portal.InputCapture` was not found``
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  input_capture] using capture backend: layer-shell
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  input_capture::layer_shell] active outputs:
May 16 01:21:28 william lan-mouse-start[395317]: [2025-05-15T18:21:28Z INFO  input_capture::layer_shell]  * eDP-1 1920x1080 @pos (0, 0) (AU Optronics 0x2E8D  (eDP-1))
