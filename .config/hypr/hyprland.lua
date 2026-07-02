hl.monitor({
	output = "",
	mode = "highres",
	position = "auto",
	scale = 1,
})

local browser = "brave"
local browserPrivate = "brave --incognito"
local terminal = "kitty"
local menu = "rofi -show drun -modi drun"

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.on("hyprland.start", function()
	hl.exec_cmd([[gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"]])
	hl.exec_cmd([[gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"]])
	hl.exec_cmd([[gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"]])

	hl.exec_cmd("gammastep")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("quickshell")
	hl.exec_cmd("fcitx5 -dr")
	hl.exec_cmd("copyq exit; copyq --start-server")
	hl.exec_cmd("dunst")
end)

hl.on("keybinds.submap", function(name)
	if name == "" then
		hl.exec_cmd("qs ipc call hyprland resetSubmap")
	else
		hl.exec_cmd("qs ipc call hyprland setSubmap " .. name)
	end
end)

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 20,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = true,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		rounding_power = 4,

		active_opacity = 0.95,
		inactive_opacity = 0.95,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("expressiveFastSpatial", { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.90 } } })
hl.curve("expressiveSlowSpatial", { type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.00 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("standardDecel", { type = "bezier", points = { { 0, 0 }, { 0, 1 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })

-- windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "emphasizedDecel", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "emphasizedDecel" })

-- layers
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.4, bezier = "menu_accel", style = "popin 94%" })

-- fade
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "menu_accel" })

-- workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })

-- specialWorkspace
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2.8,
	bezier = "emphasizedDecel",
	style = "slidevert",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.2,
	bezier = "emphasizedAccel",
	style = "slidevert",
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	misc = {
		focus_on_activate = true,
		force_default_wallpaper = 2,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

hl.config({
	input = {
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.2,
		},
	},
})

hl.config({
	gestures = {
		workspace_swipe_forever = true,
		workspace_swipe_direction_lock = false,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		hl.exec_cmd(menu)
	end,
})

hl.gesture({
	fingers = 3,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
	end,
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Return", function()
	hl.dispatch(hl.dsp.focus({ workspace = 2 }))
	hl.dispatch(hl.dsp.exec_cmd(terminal))
end)
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserPrivate))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("copyq show"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | wl-copy']]))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.window.pin())
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + CTRL + V", hl.dsp.layout("swapsplit")) -- dwindle
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	local handled = false

	local function resize(x, y)
		return function()
			handled = true
			hl.dispatch(hl.dsp.window.resize({ x = x, y = y, relative = true }))
		end
	end

	hl.bind("left", resize(-100, 0), { repeating = true })
	hl.bind("right", resize(100, 0), { repeating = true })
	hl.bind("up", resize(0, -100), { repeating = true })
	hl.bind("down", resize(0, 100), { repeating = true })
	hl.bind("H", resize(-10, 0), { repeating = true })
	hl.bind("L", resize(10, 0), { repeating = true })
	hl.bind("K", resize(0, -10), { repeating = true })
	hl.bind("J", resize(0, 10), { repeating = true })

	hl.bind("catchall", function()
		if handled then
			handled = false
			return
		end
		hl.dispatch(hl.dsp.submap("reset"))
	end)
end)

-- Toggle focus between floating and tiled windows
hl.bind(mainMod .. " + U", function()
	local win = hl.get_active_window()
	if win and win.floating then
		hl.dispatch(hl.dsp.focus({ window = "tiled" }))
	else
		hl.dispatch(hl.dsp.focus({ window = "floating" }))
	end
end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Swap window with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Switch to previous workspaces with mainMod + tab
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Move through existing workspaces with mainMod + CTRL + arrow keys
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ workspace = "e-1" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("qs ipc call brightness changeBrightness 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("qs ipc call brightness changeBrightness 5%-"),
	{ locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- disable opacity on google meet
hl.window_rule({
	name = "disable-opacity-on-meet",
	match = { title = "Meet - .*" },
	opacity = "1 override",
})

hl.window_rule({
	name = "xdg-desktop-portal-gtk",
	match = { initial_class = "xdg-desktop-portal-gtk" },

	float = true,
	center = true,
	size = { "(monitor_w*0.6)", "(monitor_h*0.6)" },
})

hl.window_rule({
	name = "float-copyq",
	match = { initial_class = "com.github.hluk.copyq" },

	float = true,
	center = true,
	size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
})

hl.window_rule({
	name = "float-pwvucontrol",
	match = { initial_class = "com.saivert.pwvucontrol" },

	float = true,
	center = true,
	size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
})

hl.window_rule({
	name = "colored pinned window",
	match = { pin = true },
	border_color = "rgb(ff757f) rgb(c53b53)",
})
