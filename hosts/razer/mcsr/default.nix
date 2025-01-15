{ lib, ... }: { wayland.windowManager.hyprland.settings = let
    eyeMacroWidth = 384;
    eyeMacroHeight = 16384;
    in {
    windowrulev2 = [
      "noanim,class:(Minecraft) "
    ];
    extraConfig = ''
bind=ALTSHIFT,m,submap,mcsr

submap = mcsr
    bind=,escape,submap,reset

    bind=,e,focuswindow,class:(Minecraft) # eye zoom macro
    bind=,e,fullscreenstate,0
    bind=,e,setfloating,active
    bind=,e,resizeactive,exact 384 16384
    bind=,e,centerwindow
    bind=,e,submap,eye

    submap = eye
        bind=,e,focuswindow,class:(Minecraft)
        bind=,e,resizeactive,exact 50% 50%
        bind=,e,centerwindow
        bind=,e,fullscreenstate,2
        bind=,e,submap,reset
    submap = mcsr

    bind=,l,focuswindow,class:(Minecraft) # thin macro
    bind=,l,fullscreenstate,0
    bind=,l,setfloating,active
    bind=,l,resizeactive,exact 500 100%
    bind=,l,centerwindow
    bind=,l,submap,thin

    submap = thin
        bind=,l,focuswindow,class:(Minecraft)
        bind=,l,resizeactive,exact 50% 50%
        bind=,l,centerwindow
        bind=,l,fullscreenstate,2
        bind=,l,submap,reset
    submap = mcsr


    bind=,k,focuswindow,class:(Minecraft) # wide macro
    bind=,k,fullscreenstate,0
    bind=,k,setfloating,active
    bind=,k,resizeactive,exact 100% 400
    bind=,k,centerwindow
    bind=,k,submap,wide

    submap = wide
        bind=,k,focuswindow,class:(Minecraft)
        bind=,k,resizeactive,exact 50% 50%
        bind=,k,centerwindow
        bind=,k,fullscreenstate,2
        bind=,k,submap,reset
    submap = mcsr

submap = reset
    '';
  };
}

