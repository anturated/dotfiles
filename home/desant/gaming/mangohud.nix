{ config, ... }:

{
  programs.mangohud = {
    inherit (config.ceirios.profiles.gaming) enable;

    settings = {
      ################ PERFORMANCE #################
      ### Limit the application FPS. Comma-separated list of one or more FPS values (e.g. 0,30,60). 0 means unlimited (unless VSynced)
      fps_limit = 0;

      ### Display the current GPU information
      ## gpu_mem_clock and gpu_mem_temp also need "vram" to be enabled
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_load_value = [
        60
        90
      ];
      gpu_load_color = [
        "39F900"
        "FDFD09"
        "B22222"
      ];

      ### Display the current CPU information
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;
      cpu_load_value = [
        60
        90
      ];
      cpu_load_color = [
        "39F900"
        "FDFD09"
        "B22222"
      ];

      ### Display the current CPU load & frequency for each core
      core_load = true;
      core_load_change = true;
      core_bars = true;

      ### Display system vram / ram / swap space usage
      vram = true;
      ram = true;
      swap = true;

      ### Display FPS and frametime
      fps = true;
      frametime = true;

      ### Display GPU throttling status based on Power, current, temp or "other"
      ## Only shows if throttling is currently happening
      throttling_status = true;
      ## Same as throttling_status but displays throttling on the frametime graph
      throttling_status_graph = true;

      ### Display the frametime line graph
      frame_timing = true;

      ### Change the hud font size
      font_size = 18;
      font_scale = 1.0;
      font_size_text = 50;

      ### Outline text
      text_outline = true;

      gamemode = true;

      ### Change the corner roundness
      round_corners = 10;

      ### Display compact version of MangoHud
      hud_compact = true;

      ### Display MangoHud in a horizontal position
      # horizontal
      # horizontal_stretch

      ### Disable / hide the hud by default
      no_display = true;

      ### Display current display session
      display_server = true;

      ## Color customization
      text_color = "FFFFFF";
      gpu_color = "2E9762";
      cpu_color = "2E97CB";
      vram_color = "AD64C1";
      ram_color = "C26693";
      engine_color = "EB5B5B";
      io_color = "A491D3";
      frametime_color = "00FF00";
      background_color = "020202";
      media_player_color = "FFFFFF";
      wine_color = "EB5B5B";
      battery_color = "FF9078";
      network_color = "E07B85";
      horizontal_separator_color = "AD64C1";

      ################ INTERACTION #################

      ### Change toggle keybinds for the hud & logging
      # toggle_hud=Shift_R+F12
      # toggle_hud_position=Shift_R+F11
      # toggle_preset=Shift_R+F10
      # toggle_fps_limit=Shift_L+F1
      # toggle_logging=Shift_L+F2
      # reload_cfg=Shift_L+F4
      # upload_log=Shift_L+F3
      # reset_fps_metrics=Shift_R+F9
    };
  };
}
