-------------------------------
--    "Sky" awesome theme    --
--  By Andrei "Garoth" Thorp --
-------------------------------
-- If you want SVGs and extras, get them from garoth.com/awesome/sky-theme

-- BASICS
theme = {}
theme.font          = "sans 8"

--theme.bg_focus      = "#727272"
theme.bg_focus      = "#1E2320"
theme.bg_normal     = "#222222"
theme.bg_urgent     = "#fce94f"
theme.bg_minimize   = "#7abcff"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#BABABA"
--theme.fg_focus      = "#00FFFF"
theme.fg_focus      = "#0011FF"
theme.fg_urgent     = "#2e3436"
theme.fg_minimize   = "#2e3436"

theme.border_width  = 2
theme.border_normal = "#dae3e0"
theme.border_focus  = "#729fcf"
theme.border_marked = "#eeeeec"

-- IMAGES
theme.layout_fairh           = "~/.config/awesome/themes/hotvic/layouts/fairh.png"
theme.layout_fairv           = "~/.config/awesome/themes/hotvic/layouts/fairv.png"
theme.layout_floating        = "~/.config/awesome/themes/hotvic/layouts/floating.png"
theme.layout_magnifier       = "~/.config/awesome/themes/hotvic/layouts/magnifier.png"
theme.layout_max             = "~/.config/awesome/themes/hotvic/layouts/max.png"
theme.layout_fullscreen      = "~/.config/awesome/themes/hotvic/layouts/fullscreen.png"
theme.layout_tilebottom      = "~/.config/awesome/themes/hotvic/layouts/tilebottom.png"
theme.layout_tileleft        = "~/.config/awesome/themes/hotvic/layouts/tileleft.png"
theme.layout_tile            = "~/.config/awesome/themes/hotvic/layouts/tile.png"
theme.layout_tiletop         = "~/.config/awesome/themes/hotvic/layouts/tiletop.png"
theme.layout_spiral          = "~/.config/awesome/themes/hotvic/layouts/spiral.png"
theme.layout_dwindle         = "~/.config/awesome/themes/hotvic/layouts/dwindle.png"

-- User images
theme.awesome_icon           = "~/.config/awesome/themes/hotvic/awesome-icon.png"
theme.arch_icon              = "/usr/share/icons/Faenza/places/22/distributor-logo-archlinux.png"
theme.bookmakrs_icon         = "/usr/share/icons/Faenza/places/16/user-bookmarks.png"
theme.aurora_icon            = "/usr/share/icons/hicolor/16x16/apps/aurora.png"
theme.carrier_icon           = "/usr/share/icons/hicolor/16x16/apps/carrier.png"
theme.exaile_icon            = "/usr/share/icons/Faenza/apps/16/exaile.png"
theme.gimp_icon              = "/usr/share/icons/Faenza/apps/16/gimp.png"

-- from default for now...
theme.menu_submenu_icon     = "/usr/share/awesome/themes/default/submenu.png"
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- MISC
theme.wallpaper             = "~/.config/awesome/themes/hotvic/layouts/wallpaper_arch_gray.png"
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height           = 15
theme.menu_width            = 100

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
