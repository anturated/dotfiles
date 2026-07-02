{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  # TODO: there's a mangohud home-manager module
  config = mkIf gaming.enable {
    ceirios.packages = {
      inherit (pkgs) mangohud;
    };

    xdg.configFile."MangoHud/MangoHud.conf".text = ''
      ################ PERFORMANCE #################

      ### Limit the application FPS. Comma-separated list of one or more FPS values (e.g. 0,30,60). 0 means unlimited (unless VSynced)
      fps_limit=0

      ### VSync [0-3] 0 = adaptive; 1 = off; 2 = mailbox; 3 = on
      # vsync=-1

      ### Display the current GPU information
      ## Note: gpu_mem_clock and gpu_mem_temp also need "vram" to be enabled
      gpu_stats
      gpu_temp
      # gpu_junction_temp
      gpu_core_clock
      # gpu_mem_temp
      # gpu_mem_clock
      gpu_power
      # gpu_power_limit
      # gpu_text=
      gpu_load_change
      gpu_load_value=60,90
      gpu_load_color=39F900,FDFD09,B22222
      ## GPU fan in rpm on AMD, FAN in percent on NVIDIA
      # gpu_fan
      ## gpu_voltage only works on AMD GPUs
      # gpu_voltage
      ## Select list of GPUs to display
      # gpu_list=0,1
      # gpu_efficiency

      ### Display the current CPU information
      cpu_stats
      cpu_temp
      cpu_power
      # cpu_text=asd
      cpu_mhz
      cpu_load_change
      cpu_load_value=60,90
      cpu_load_color=39F900,FDFD09,B22222
      # cpu_efficiency

      ### Display the current CPU load & frequency for each core
      core_load
      core_load_change
      core_bars
      # core_type

      ### Display system vram / ram / swap space usage
      vram
      ram
      swap

      ### Display per process memory usage
      ## Show resident memory and other types, if enabled
      # procmem
      # procmem_shared
      # procmem_virt
      # proc_vram

      ### Display FPS and frametime
      fps
      # fps_sampling_period=500
      # fps_color_change
      # fps_value=30,60
      # fps_color=B22222,FDFD09,39F900
      # fps_text=""
      frametime
      # frame_count
      ## fps_metrics takes a list of decimal values or the value avg
      # fps_metrics=avg,0.01

      ### Display GPU throttling status based on Power, current, temp or "other"
      ## Only shows if throttling is currently happening
      throttling_status
      ## Same as throttling_status but displays throttling on the frametime graph
      throttling_status_graph

      ### Display the frametime line graph
      frame_timing
      # frame_timing_detailed
      # dynamic_frame_timing
      # histogram


      ### Change the hud font size
      font_size=18
      font_scale=1.0
      font_size_text=50
      # font_scale_media_player=0.55
      # no_small_font

      ### Outline text
      text_outline
      # text_outline_color = 000000
      # text_outline_thickness = 1.5

      gamemode

      ### Change the hud position
      # position=top-left

      ### Change the corner roundness
      round_corners=10

      ### Remove margins around MangoHud
      # hud_no_margin

      ### Display compact version of MangoHud
      hud_compact

      ### Display MangoHud in a horizontal position
      # horizontal
      # horizontal_stretch

      ### Disable / hide the hud by default
      no_display

      ### Display current display session
      display_server

      ### Hud position offset
      # offset_x=0
      # offset_y=0

      ### Hud dimensions
      # width=0
      # height=140
      # table_columns=3
      # cellpadding_y=-0.085

      ### Hud transparency / alpha
      # background_alpha=0.5
      # alpha=1.0

      ## Color customization
      text_color=FFFFFF
      gpu_color=2E9762
      cpu_color=2E97CB
      vram_color=AD64C1
      ram_color=C26693
      engine_color=EB5B5B
      io_color=A491D3
      frametime_color=00FF00
      background_color=020202
      media_player_color=FFFFFF
      wine_color=EB5B5B
      battery_color=FF9078
      network_color=E07B85
      horizontal_separator_color=AD64C1

      ### Control over socket
      ### Enable and set socket name, '%p' is replaced with process id
      ## example: mangohud
      ## example: mangohud-%p
      # control = -1

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

    '';
  };
}
