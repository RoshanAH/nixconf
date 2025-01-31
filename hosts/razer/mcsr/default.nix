{ lib, pkgs, inputs, ... }: let
      minecraftRegex = "title:^(Minecraft)";
      eyeProjectorRegex = "title:(Windowed Projector).*(Eye)";
      ninbotRegex = "title:^(Ninjabrain Bot )$";
  in { 
  
  home.packages = (with pkgs; [
    jdk
  ]) ++ [
    inputs.ninjabrainbot.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  wayland.windowManager.hyprland = {
    settings = {
      windowrulev2 = [
        "noanim,${minecraftRegex} "
        "noborder,${minecraftRegex}"
        "noanim, ${eyeProjectorRegex}"
        "float, ${eyeProjectorRegex}"
        "size 40% 40%, ${eyeProjectorRegex}"
        "move 0% 30%, ${eyeProjectorRegex}"
        "nofocus, ${eyeProjectorRegex}"
        "noborder, ${eyeProjectorRegex}"
        "workspace name:mcsr silent, ${eyeProjectorRegex}"
        "noanim, ${ninbotRegex}$"
        "float, ${ninbotRegex}$"
        "move 100%-w-0 20%, ${ninbotRegex}$"
        "noborder, ${ninbotRegex}$"
        "workspace name:mcsr silent, ${ninbotRegex}$"
      ];
    };

    extraConfig =  let
      eyeMacroWidth = "384";
      eyeMacroHeight = "16384";

      thinMacroWidth = "500";
      wideMacroHeight = "400";

      zoomDPI = "100";
      normalDPI = "3200";

      resetMC = bind: ''
bind=,${bind},focuswindow,${minecraftRegex}
bind=,${bind},resizeactive,exact 100% 100%
bind=,${bind},centerwindow
bind=,${bind},submap,reset
      '';


      resizeMC = {bind, width, height} : ''
bind=,${bind},focuswindow,${minecraftRegex}
bind=,${bind},fullscreenstate,0
bind=,${bind},setfloating,active
bind=,${bind},resizeactive,exact ${width} ${height}
bind=,${bind},centerwindow
      '';

    in ''
bind=ALTSHIFT,m,submap,mcsr

submap = mcsr
    bind=,escape,submap,reset

    ${resizeMC {bind = "e"; width = eyeMacroWidth; height = eyeMacroHeight;}}
    bind=,e,pin,${eyeProjectorRegex}
    bind=,e,exec,polychromatic-cli -d mouse --dpi ${zoomDPI}
    bind=,e,submap,eye

    submap = eye
        bind=ALT,escape,submap,reset
        bind=,e,pin,${eyeProjectorRegex}
        bind=,e,movetoworkspacesilent,name:mcsr,${eyeProjectorRegex}
        bind=,e,exec,polychromatic-cli -d mouse --dpi ${normalDPI}
        ${resetMC "e"}
    submap = mcsr

    ${resizeMC {bind = "l"; width = thinMacroWidth; height = "100%";}}
    bind=,l,submap,thin

    submap = thin
        bind=ALT,escape,submap,reset
        ${resetMC "l"}
    submap = mcsr

    ${resizeMC {bind = "k"; width = "100%"; height = wideMacroHeight;}}
    bind=,k,submap,wide

    submap = wide
        bind=ALT,escape,submap,reset
        ${resetMC "k"}
    submap = mcsr

    bind=,c,closewindow,${eyeProjectorRegex} # close eye projector
    bind=,c,submap,reset

    bind=,p,pin,${eyeProjectorRegex} # manually toggle eye projector
    bind=,p,movetoworkspacesilent,name:mcsr,${eyeProjectorRegex}
    bind=,p,submap,reset
    
    bind=,n,pin,${ninbotRegex}$ # manually toggle ninjabrain bot
    bind=,n,movetoworkspacesilent,name:mcsr,${ninbotRegex}$
    bind=,n,submap,reset

    bind=,o,exec,obs # open
    bind=,o,exec,prismlauncher
    bind=,o,exec,NinjaBrain-Bot
    bind=,o,submap,reset
 
submap = reset
    '';
  };
}

