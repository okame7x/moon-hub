--[[
	Moon Hub - UI Library
	Black theme, responsive, single file. Icons: Lucide (818, by name).
	CreateWindow options: Title, SubTitle, ToggleKey, Width, Height, Snow = false (no snowfall),
	ToggleButton = false (hides the floating open/close pill).

	Running the file on its own opens a showcase window with every element:

		loadstring(readfile("ui hermes.lua"))()

	To use it only as a library, disable the showcase first:

		getgenv().MoonHubDemo = false
		local Library = loadstring(readfile("ui hermes.lua"))()

		local Window = Library:CreateWindow({ Title = "Moon Hub", SubTitle = "Blox Fruits" })
		local Main = Window:AddTab({ Name = "Main", Icon = "home", Description = "Farming" })
		Main:AddToggle({ Name = "Auto Farm", Icon = "swords", Flag = "autoFarm", Callback = print })
--]]

local cloneService = typeof(cloneref) == "function" and cloneref or function(object)
	return object
end

-- Services.
local playersService = cloneService(game:GetService("Players"))
local tweenService = cloneService(game:GetService("TweenService"))
local runService = cloneService(game:GetService("RunService"))
local userInputService = cloneService(game:GetService("UserInputService"))
local textService = cloneService(game:GetService("TextService"))
local httpService = cloneService(game:GetService("HttpService"))
local coreGui = cloneService(game:GetService("CoreGui"))
local contentProvider = cloneService(game:GetService("ContentProvider"))

local localPlayer = playersService.LocalPlayer

-- Constants.
local DESIGN_WIDTH = 720
local DESIGN_HEIGHT = 480
local SIDEBAR_WIDTH = 196
local TOPBAR_HEIGHT = 62
local MIN_SCALE = 0.5
local MAX_SCALE = 1.3
local FLAKE_COUNT = 34
local ICON_FLAKE_COUNT = 8
local CONFIG_FOLDER = "MoonHub"
local LOGO_URL = "https://raw.githubusercontent.com/okame7x/moon-hub/main/assets/logo.png"
local LOGO_FILE = "logo_v1.png"
local SHADOW_IMAGE = "rbxassetid://6014261993"
local GOTHAM = "rbxasset://fonts/families/GothamSSm.json"

-- Lucide icon ids (sourced from dawid-scripts/Fluent, Tarmac generated).
local IconIds = {
	["accessibility"]=10709751939, ["activity"]=10709752035, ["air-vent"]=10709752131, ["airplay"]=10709752254,
	["alarm-check"]=10709752405, ["alarm-clock"]=10709752630, ["alarm-clock-off"]=10709752508,
	["alarm-minus"]=10709752732, ["alarm-plus"]=10709752825, ["album"]=10709752906, ["alert-circle"]=10709752996,
	["alert-octagon"]=10709753064, ["alert-triangle"]=10709753149, ["align-center"]=10709753570,
	["align-center-horizontal"]=10709753272, ["align-center-vertical"]=10709753421,
	["align-end-horizontal"]=10709753692, ["align-end-vertical"]=10709753808,
	["align-horizontal-distribute-center"]=10747779791, ["align-horizontal-distribute-end"]=10747784534,
	["align-horizontal-distribute-start"]=10709754118, ["align-horizontal-justify-center"]=10709754204,
	["align-horizontal-justify-end"]=10709754317, ["align-horizontal-justify-start"]=10709754436,
	["align-horizontal-space-around"]=10709754590, ["align-horizontal-space-between"]=10709754749,
	["align-justify"]=10709759610, ["align-left"]=10709759764, ["align-right"]=10709759895,
	["align-start-horizontal"]=10709760051, ["align-start-vertical"]=10709760244,
	["align-vertical-distribute-center"]=10709760351, ["align-vertical-distribute-end"]=10709760434,
	["align-vertical-distribute-start"]=10709760612, ["align-vertical-justify-center"]=10709760814,
	["align-vertical-justify-end"]=10709761003, ["align-vertical-justify-start"]=10709761176,
	["align-vertical-space-around"]=10709761324, ["align-vertical-space-between"]=10709761434,
	["anchor"]=10709761530, ["angry"]=10709761629, ["annoyed"]=10709761722, ["aperture"]=10709761813,
	["apple"]=10709761889, ["archive"]=10709762233, ["archive-restore"]=10709762058, ["armchair"]=10709762327,
	["arrow-big-down"]=10747796644, ["arrow-big-left"]=10709762574, ["arrow-big-right"]=10709762727,
	["arrow-big-up"]=10709762879, ["arrow-down"]=10709767827, ["arrow-down-circle"]=10709763034,
	["arrow-down-left"]=10709767656, ["arrow-down-right"]=10709767750, ["arrow-left"]=10709768114,
	["arrow-left-circle"]=10709767936, ["arrow-left-right"]=10709768019, ["arrow-right"]=10709768347,
	["arrow-right-circle"]=10709768226, ["arrow-up"]=10709768939, ["arrow-up-circle"]=10709768432,
	["arrow-up-down"]=10709768538, ["arrow-up-left"]=10709768661, ["arrow-up-right"]=10709768787,
	["asterisk"]=10709769095, ["at-sign"]=10709769286, ["award"]=10709769406, ["axe"]=10709769508,
	["axis-3d"]=10709769598, ["baby"]=10709769732, ["backpack"]=10709769841, ["baggage-claim"]=10709769935,
	["banana"]=10709770005, ["banknote"]=10709770178, ["bar-chart"]=10709773755, ["bar-chart-2"]=10709770317,
	["bar-chart-3"]=10709770431, ["bar-chart-4"]=10709770560, ["bar-chart-horizontal"]=10709773669,
	["barcode"]=10747360675, ["baseline"]=10709773863, ["bath"]=10709773963, ["battery"]=10709774640,
	["battery-charging"]=10709774068, ["battery-full"]=10709774206, ["battery-low"]=10709774370,
	["battery-medium"]=10709774513, ["beaker"]=10709774756, ["bed"]=10709775036, ["bed-double"]=10709774864,
	["bed-single"]=10709774968, ["beer"]=10709775167, ["bell"]=10709775704, ["bell-minus"]=10709775241,
	["bell-off"]=10709775320, ["bell-plus"]=10709775448, ["bell-ring"]=10709775560, ["bike"]=10709775894,
	["binary"]=10709776050, ["bitcoin"]=10709776126, ["bluetooth"]=10709776655,
	["bluetooth-connected"]=10709776240, ["bluetooth-off"]=10709776344, ["bluetooth-searching"]=10709776501,
	["bold"]=10747813908, ["bomb"]=10709781460, ["bone"]=10709781605, ["book"]=10709781824,
	["book-open"]=10709781717, ["bookmark"]=10709782154, ["bookmark-minus"]=10709781919,
	["bookmark-plus"]=10709782044, ["bot"]=10709782230, ["box"]=10709782497, ["box-select"]=10709782342,
	["boxes"]=10709782582, ["briefcase"]=10709782662, ["brush"]=10709782758, ["bug"]=10709782845,
	["building"]=10709783051, ["building-2"]=10709782939, ["bus"]=10709783137, ["cake"]=10709783217,
	["calculator"]=10709783311, ["calendar"]=10709789505, ["calendar-check"]=10709783474,
	["calendar-check-2"]=10709783392, ["calendar-clock"]=10709783577, ["calendar-days"]=10709783673,
	["calendar-heart"]=10709783835, ["calendar-minus"]=10709783959, ["calendar-off"]=10709788784,
	["calendar-plus"]=10709788937, ["calendar-range"]=10709789053, ["calendar-search"]=10709789200,
	["calendar-x"]=10709789407, ["calendar-x-2"]=10709789329, ["camera"]=10709789686, ["camera-off"]=10747822677,
	["car"]=10709789810, ["carrot"]=10709789960, ["cast"]=10709790097, ["charge"]=10709790202,
	["check"]=10709790644, ["check-circle"]=10709790387, ["check-circle-2"]=10709790298,
	["check-square"]=10709790537, ["chef-hat"]=10709790757, ["cherry"]=10709790875, ["chevron-down"]=10709790948,
	["chevron-first"]=10709791015, ["chevron-last"]=10709791130, ["chevron-left"]=10709791281,
	["chevron-right"]=10709791437, ["chevron-up"]=10709791523, ["chevrons-down"]=10709796864,
	["chevrons-down-up"]=10709791632, ["chevrons-left"]=10709797151, ["chevrons-left-right"]=10709797006,
	["chevrons-right"]=10709797382, ["chevrons-right-left"]=10709797274, ["chevrons-up"]=10709797622,
	["chevrons-up-down"]=10709797508, ["chrome"]=10709797725, ["circle"]=10709798174, ["circle-dot"]=10709797837,
	["circle-ellipsis"]=10709797985, ["circle-slashed"]=10709798100, ["citrus"]=10709798276,
	["clapperboard"]=10709798350, ["clipboard"]=10709799288, ["clipboard-check"]=10709798443,
	["clipboard-copy"]=10709798574, ["clipboard-edit"]=10709798682, ["clipboard-list"]=10709798792,
	["clipboard-signature"]=10709798890, ["clipboard-type"]=10709798999, ["clipboard-x"]=10709799124,
	["clock"]=10709805144, ["clock-1"]=10709799535, ["clock-10"]=10709799718, ["clock-11"]=10709799818,
	["clock-12"]=10709799962, ["clock-2"]=10709803876, ["clock-3"]=10709803989, ["clock-4"]=10709804164,
	["clock-5"]=10709804291, ["clock-6"]=10709804435, ["clock-7"]=10709804599, ["clock-8"]=10709804784,
	["clock-9"]=10709804996, ["cloud"]=10709806740, ["cloud-cog"]=10709805262, ["cloud-drizzle"]=10709805371,
	["cloud-fog"]=10709805477, ["cloud-hail"]=10709805596, ["cloud-lightning"]=10709805727,
	["cloud-moon"]=10709805942, ["cloud-moon-rain"]=10709805838, ["cloud-off"]=10709806060,
	["cloud-rain"]=10709806277, ["cloud-rain-wind"]=10709806166, ["cloud-snow"]=10709806374,
	["cloud-sun"]=10709806631, ["cloud-sun-rain"]=10709806475, ["cloudy"]=10709806859, ["clover"]=10709806995,
	["code"]=10709810463, ["code-2"]=10709807111, ["codepen"]=10709810534, ["codesandbox"]=10709810676,
	["coffee"]=10709810814, ["cog"]=10709810948, ["coins"]=10709811110, ["columns"]=10709811261,
	["command"]=10709811365, ["compass"]=10709811445, ["component"]=10709811595, ["concierge-bell"]=10709811706,
	["connection"]=10747361219, ["contact"]=10709811834, ["contrast"]=10709811939, ["cookie"]=10709812067,
	["copy"]=10709812159, ["copyleft"]=10709812251, ["copyright"]=10709812311, ["corner-down-left"]=10709812396,
	["corner-down-right"]=10709812485, ["corner-left-down"]=10709812632, ["corner-left-up"]=10709812784,
	["corner-right-down"]=10709812939, ["corner-right-up"]=10709813094, ["corner-up-left"]=10709813185,
	["corner-up-right"]=10709813281, ["cpu"]=10709813383, ["croissant"]=10709818125, ["crop"]=10709818245,
	["cross"]=10709818399, ["crosshair"]=10709818534, ["crown"]=10709818626, ["cup-soda"]=10709818763,
	["curly-braces"]=10709818847, ["currency"]=10709818931, ["database"]=10709818996, ["delete"]=10709819059,
	["diamond"]=10709819149, ["dice-1"]=10709819266, ["dice-2"]=10709819361, ["dice-3"]=10709819508,
	["dice-4"]=10709819670, ["dice-5"]=10709819801, ["dice-6"]=10709819896, ["dices"]=10723343321,
	["diff"]=10723343416, ["disc"]=10723343537, ["divide"]=10723343805, ["divide-circle"]=10723343636,
	["divide-square"]=10723343737, ["dollar-sign"]=10723343958, ["download"]=10723344270,
	["download-cloud"]=10723344088, ["droplet"]=10723344432, ["droplets"]=10734883356, ["drumstick"]=10723344737,
	["edit"]=10734883598, ["edit-2"]=10723344885, ["edit-3"]=10723345088, ["egg"]=10723345518,
	["egg-fried"]=10723345347, ["electricity"]=10723345749, ["electricity-off"]=10723345643,
	["equal"]=10723345990, ["equal-not"]=10723345866, ["eraser"]=10723346158, ["euro"]=10723346372,
	["expand"]=10723346553, ["external-link"]=10723346684, ["eye"]=10723346959, ["eye-off"]=10723346871,
	["factory"]=10723347051, ["fan"]=10723354359, ["fast-forward"]=10723354521, ["feather"]=10723354671,
	["figma"]=10723354801, ["file"]=10723374641, ["file-archive"]=10723354921, ["file-audio"]=10723355148,
	["file-audio-2"]=10723355026, ["file-axis-3d"]=10723355272, ["file-badge"]=10723355622,
	["file-badge-2"]=10723355451, ["file-bar-chart"]=10723355887, ["file-bar-chart-2"]=10723355746,
	["file-box"]=10723355989, ["file-check"]=10723356210, ["file-check-2"]=10723356100,
	["file-clock"]=10723356329, ["file-code"]=10723356507, ["file-cog"]=10723356830, ["file-cog-2"]=10723356676,
	["file-diff"]=10723357039, ["file-digit"]=10723357151, ["file-down"]=10723357322, ["file-edit"]=10723357495,
	["file-heart"]=10723357637, ["file-image"]=10723357790, ["file-input"]=10723357933,
	["file-json"]=10723364435, ["file-json-2"]=10723364361, ["file-key"]=10723364605, ["file-key-2"]=10723364515,
	["file-line-chart"]=10723364725, ["file-lock"]=10723364957, ["file-lock-2"]=10723364861,
	["file-minus"]=10723365254, ["file-minus-2"]=10723365086, ["file-output"]=10723365457,
	["file-pie-chart"]=10723365598, ["file-plus"]=10723365877, ["file-plus-2"]=10723365766,
	["file-question"]=10723365987, ["file-scan"]=10723366167, ["file-search"]=10723366550,
	["file-search-2"]=10723366340, ["file-signature"]=10723366741, ["file-spreadsheet"]=10723366962,
	["file-symlink"]=10723367098, ["file-terminal"]=10723367244, ["file-text"]=10723367380,
	["file-type"]=10723367606, ["file-type-2"]=10723367509, ["file-up"]=10723367734, ["file-video"]=10723373884,
	["file-video-2"]=10723367834, ["file-volume"]=10723374172, ["file-volume-2"]=10723374030,
	["file-warning"]=10723374276, ["file-x"]=10723374544, ["file-x-2"]=10723374378, ["files"]=10723374759,
	["film"]=10723374981, ["filter"]=10723375128, ["fingerprint"]=10723375250, ["flag"]=10723375890,
	["flag-off"]=10723375443, ["flag-triangle-left"]=10723375608, ["flag-triangle-right"]=10723375727,
	["flame"]=10723376114, ["flashlight"]=10723376471, ["flashlight-off"]=10723376365,
	["flask-conical"]=10734883986, ["flask-round"]=10723376614, ["flip-horizontal"]=10723376884,
	["flip-horizontal-2"]=10723376745, ["flip-vertical"]=10723377138, ["flip-vertical-2"]=10723377026,
	["flower"]=10747830374, ["flower-2"]=10723377305, ["focus"]=10723377537, ["folder"]=10723387563,
	["folder-archive"]=10723384478, ["folder-check"]=10723384605, ["folder-clock"]=10723384731,
	["folder-closed"]=10723384893, ["folder-cog"]=10723385213, ["folder-cog-2"]=10723385036,
	["folder-down"]=10723385338, ["folder-edit"]=10723385445, ["folder-heart"]=10723385545,
	["folder-input"]=10723385721, ["folder-key"]=10723385848, ["folder-lock"]=10723386005,
	["folder-minus"]=10723386127, ["folder-open"]=10723386277, ["folder-output"]=10723386386,
	["folder-plus"]=10723386531, ["folder-search"]=10723386787, ["folder-search-2"]=10723386674,
	["folder-symlink"]=10723386930, ["folder-tree"]=10723387085, ["folder-up"]=10723387265,
	["folder-x"]=10723387448, ["folders"]=10723387721, ["form-input"]=10723387841, ["forward"]=10723388016,
	["frame"]=10723394389, ["framer"]=10723394565, ["frown"]=10723394681, ["fuel"]=10723394846,
	["function-square"]=10723395041, ["gamepad"]=10723395457, ["gamepad-2"]=10723395215, ["gauge"]=10723395708,
	["gavel"]=10723395896, ["gem"]=10723396000, ["ghost"]=10723396107, ["gift"]=10723396402,
	["gift-card"]=10723396225, ["git-branch"]=10723396676, ["git-branch-plus"]=10723396542,
	["git-commit"]=10723396812, ["git-compare"]=10723396954, ["git-fork"]=10723397049, ["git-merge"]=10723397165,
	["git-pull-request"]=10723397431, ["git-pull-request-closed"]=10723397268,
	["git-pull-request-draft"]=10734884302, ["glass"]=10723397788, ["glass-2"]=10723397529,
	["glass-water"]=10723397678, ["glasses"]=10723397895, ["globe"]=10723404337, ["globe-2"]=10723398002,
	["grab"]=10723404472, ["graduation-cap"]=10723404691, ["grape"]=10723404822, ["grid"]=10723404936,
	["grip-horizontal"]=10723405089, ["grip-vertical"]=10723405236, ["hammer"]=10723405360, ["hand"]=10723405649,
	["hand-metal"]=10723405508, ["hard-drive"]=10723405749, ["hard-hat"]=10723405859, ["hash"]=10723405975,
	["haze"]=10723406078, ["headphones"]=10723406165, ["heart"]=10723406885, ["heart-crack"]=10723406299,
	["heart-handshake"]=10723406480, ["heart-off"]=10723406662, ["heart-pulse"]=10723406795,
	["help-circle"]=10723406988, ["hexagon"]=10723407092, ["highlighter"]=10723407192, ["history"]=10723407335,
	["home"]=10723407389, ["hourglass"]=10723407498, ["ice-cream"]=10723414308, ["image"]=10723415040,
	["image-minus"]=10723414487, ["image-off"]=10723414677, ["image-plus"]=10723414827, ["import"]=10723415205,
	["inbox"]=10723415335, ["indent"]=10723415494, ["indian-rupee"]=10723415642, ["infinity"]=10723415766,
	["info"]=10723415903, ["inspect"]=10723416057, ["italic"]=10723416195, ["japanese-yen"]=10723416363,
	["joystick"]=10723416527, ["key"]=10723416652, ["keyboard"]=10723416765, ["lamp"]=10723417513,
	["lamp-ceiling"]=10723416922, ["lamp-desk"]=10723417016, ["lamp-floor"]=10723417131,
	["lamp-wall-down"]=10723417240, ["lamp-wall-up"]=10723417356, ["landmark"]=10723417608,
	["languages"]=10723417703, ["laptop"]=10723423881, ["laptop-2"]=10723417797, ["lasso"]=10723424235,
	["lasso-select"]=10723424058, ["laugh"]=10723424372, ["layers"]=10723424505, ["layout"]=10723425376,
	["layout-dashboard"]=10723424646, ["layout-grid"]=10723424838, ["layout-list"]=10723424963,
	["layout-template"]=10723425187, ["leaf"]=10723425539, ["library"]=10723425615, ["life-buoy"]=10723425685,
	["lightbulb"]=10723425852, ["lightbulb-off"]=10723425762, ["line-chart"]=10723426393, ["link"]=10723426722,
	["link-2"]=10723426595, ["link-2-off"]=10723426513, ["list"]=10723433811, ["list-checks"]=10734884548,
	["list-end"]=10723426886, ["list-minus"]=10723426986, ["list-music"]=10723427081,
	["list-ordered"]=10723427199, ["list-plus"]=10723427334, ["list-start"]=10723427494,
	["list-video"]=10723427619, ["list-x"]=10723433655, ["loader"]=10723434070, ["loader-2"]=10723433935,
	["locate"]=10723434557, ["locate-fixed"]=10723434236, ["locate-off"]=10723434379, ["lock"]=10723434711,
	["log-in"]=10723434830, ["log-out"]=10723434906, ["luggage"]=10723434993, ["magnet"]=10723435069,
	["mail"]=10734885430, ["mail-check"]=10723435182, ["mail-minus"]=10723435261, ["mail-open"]=10723435342,
	["mail-plus"]=10723435443, ["mail-question"]=10723435515, ["mail-search"]=10734884739,
	["mail-warning"]=10734885015, ["mail-x"]=10734885247, ["mails"]=10734885614, ["map"]=10734886202,
	["map-pin"]=10734886004, ["map-pin-off"]=10734885803, ["maximize"]=10734886735, ["maximize-2"]=10734886496,
	["medal"]=10734887072, ["megaphone"]=10734887454, ["megaphone-off"]=10734887311, ["meh"]=10734887603,
	["menu"]=10734887784, ["message-circle"]=10734888000, ["message-square"]=10734888228, ["mic"]=10734888864,
	["mic-2"]=10734888430, ["mic-off"]=10734888646, ["microscope"]=10734889106, ["microwave"]=10734895076,
	["milestone"]=10734895310, ["minimize"]=10734895698, ["minimize-2"]=10734895530, ["minus"]=10734896206,
	["minus-circle"]=10734895856, ["minus-square"]=10734896029, ["monitor"]=10734896881,
	["monitor-off"]=10734896360, ["monitor-speaker"]=10734896512, ["moon"]=10734897102,
	["more-horizontal"]=10734897250, ["more-vertical"]=10734897387, ["mountain"]=10734897956,
	["mountain-snow"]=10734897665, ["mouse"]=10734898592, ["mouse-pointer"]=10734898476,
	["mouse-pointer-2"]=10734898194, ["mouse-pointer-click"]=10734898355, ["move"]=10734900011,
	["move-3d"]=10734898756, ["move-diagonal"]=10734899164, ["move-diagonal-2"]=10734898934,
	["move-horizontal"]=10734899414, ["move-vertical"]=10734899821, ["music"]=10734905958,
	["music-2"]=10734900215, ["music-3"]=10734905665, ["music-4"]=10734905823, ["navigation"]=10734906744,
	["navigation-2"]=10734906332, ["navigation-2-off"]=10734906144, ["navigation-off"]=10734906580,
	["network"]=10734906975, ["newspaper"]=10734907168, ["octagon"]=10734907361, ["option"]=10734907649,
	["outdent"]=10734907933, ["package"]=10734909540, ["package-2"]=10734908151, ["package-check"]=10734908384,
	["package-minus"]=10734908626, ["package-open"]=10734908793, ["package-plus"]=10734909016,
	["package-search"]=10734909196, ["package-x"]=10734909375, ["paint-bucket"]=10734909847,
	["paintbrush"]=10734910187, ["paintbrush-2"]=10734910030, ["palette"]=10734910430, ["palmtree"]=10734910680,
	["paperclip"]=10734910927, ["party-popper"]=10734918735, ["pause"]=10734919336, ["pause-circle"]=10735024209,
	["pause-octagon"]=10734919143, ["pen-tool"]=10734919503, ["pencil"]=10734919691, ["percent"]=10734919919,
	["person-standing"]=10734920149, ["phone"]=10734921524, ["phone-call"]=10734920305,
	["phone-forwarded"]=10734920508, ["phone-incoming"]=10734920694, ["phone-missed"]=10734920845,
	["phone-off"]=10734921077, ["phone-outgoing"]=10734921288, ["pie-chart"]=10734921727,
	["piggy-bank"]=10734921935, ["pin"]=10734922324, ["pin-off"]=10734922180, ["pipette"]=10734922497,
	["pizza"]=10734922774, ["plane"]=10734922971, ["play"]=10734923549, ["play-circle"]=10734923214,
	["plus"]=10734924532, ["plus-circle"]=10734923868, ["plus-square"]=10734924219, ["podcast"]=10734929553,
	["pointer"]=10734929723, ["pound-sterling"]=10734929981, ["power"]=10734930466, ["power-off"]=10734930257,
	["printer"]=10734930632, ["puzzle"]=10734930886, ["quote"]=10734931234, ["radio"]=10734931596,
	["radio-receiver"]=10734931402, ["rectangle-horizontal"]=10734931777, ["rectangle-vertical"]=10734932081,
	["recycle"]=10734932295, ["redo"]=10734932822, ["redo-2"]=10734932586, ["refresh-ccw"]=10734933056,
	["refresh-cw"]=10734933222, ["refrigerator"]=10734933465, ["regex"]=10734933655, ["repeat"]=10734933966,
	["repeat-1"]=10734933826, ["reply"]=10734934252, ["reply-all"]=10734934132, ["rewind"]=10734934347,
	["rocket"]=10734934585, ["rocking-chair"]=10734939942, ["rotate-3d"]=10734940107, ["rotate-ccw"]=10734940376,
	["rotate-cw"]=10734940654, ["rss"]=10734940825, ["ruler"]=10734941018, ["russian-ruble"]=10734941199,
	["sailboat"]=10734941354, ["save"]=10734941499, ["scale"]=10734941912, ["scale-3d"]=10734941739,
	["scaling"]=10734942072, ["scan"]=10734942565, ["scan-face"]=10734942198, ["scan-line"]=10734942351,
	["scissors"]=10734942778, ["screen-share"]=10734943193, ["screen-share-off"]=10734942967,
	["scroll"]=10734943448, ["search"]=10734943674, ["send"]=10734943902, ["separator-horizontal"]=10734944115,
	["separator-vertical"]=10734944326, ["server"]=10734949856, ["server-cog"]=10734944444,
	["server-crash"]=10734944554, ["server-off"]=10734944668, ["settings"]=10734950309,
	["settings-2"]=10734950020, ["share"]=10734950813, ["share-2"]=10734950553, ["sheet"]=10734951038,
	["shield"]=10734951847, ["shield-alert"]=10734951173, ["shield-check"]=10734951367,
	["shield-close"]=10734951535, ["shield-off"]=10734951684, ["shirt"]=10734952036,
	["shopping-bag"]=10734952273, ["shopping-cart"]=10734952479, ["shovel"]=10734952773,
	["shower-head"]=10734952942, ["shrink"]=10734953073, ["shrub"]=10734953241, ["shuffle"]=10734953451,
	["sidebar"]=10734954301, ["sidebar-close"]=10734953715, ["sidebar-open"]=10734954000, ["sigma"]=10734954538,
	["signal"]=10734961133, ["signal-high"]=10734954807, ["signal-low"]=10734955080,
	["signal-medium"]=10734955336, ["signal-zero"]=10734960878, ["siren"]=10734961284, ["skip-back"]=10734961526,
	["skip-forward"]=10734961809, ["skull"]=10734962068, ["slack"]=10734962339, ["slash"]=10734962600,
	["slice"]=10734963024, ["sliders"]=10734963400, ["sliders-horizontal"]=10734963191,
	["smartphone"]=10734963940, ["smartphone-charging"]=10734963671, ["smile"]=10734964441,
	["smile-plus"]=10734964188, ["snowflake"]=10734964600, ["sofa"]=10734964852, ["sort-asc"]=10734965115,
	["sort-desc"]=10734965287, ["speaker"]=10734965419, ["sprout"]=10734965572, ["square"]=10734965702,
	["star"]=10734966248, ["star-half"]=10734965897, ["star-off"]=10734966097, ["stethoscope"]=10734966384,
	["sticker"]=10734972234, ["sticky-note"]=10734972463, ["stop-circle"]=10734972621,
	["stretch-horizontal"]=10734972862, ["stretch-vertical"]=10734973130, ["strikethrough"]=10734973290,
	["subscript"]=10734973457, ["sun"]=10734974297, ["sun-dim"]=10734973645, ["sun-medium"]=10734973778,
	["sun-moon"]=10734973999, ["sun-snow"]=10734974130, ["sunrise"]=10734974522, ["sunset"]=10734974689,
	["superscript"]=10734974850, ["swiss-franc"]=10734975024, ["switch-camera"]=10734975214,
	["sword"]=10734975486, ["swords"]=10734975692, ["syringe"]=10734975932, ["table"]=10734976230,
	["table-2"]=10734976097, ["tablet"]=10734976394, ["tag"]=10734976528, ["tags"]=10734976739,
	["target"]=10734977012, ["tent"]=10734981750, ["terminal"]=10734982144, ["terminal-square"]=10734981995,
	["text-cursor"]=10734982395, ["text-cursor-input"]=10734982297, ["thermometer"]=10734983134,
	["thermometer-snowflake"]=10734982571, ["thermometer-sun"]=10734982771, ["thumbs-down"]=10734983359,
	["thumbs-up"]=10734983629, ["ticket"]=10734983868, ["timer"]=10734984606, ["timer-off"]=10734984138,
	["timer-reset"]=10734984355, ["toggle-left"]=10734984834, ["toggle-right"]=10734985040,
	["tornado"]=10734985247, ["toy-brick"]=10747361919, ["train"]=10747362105, ["trash"]=10747362393,
	["trash-2"]=10747362241, ["tree-deciduous"]=10747362534, ["tree-pine"]=10747362748, ["trees"]=10747363016,
	["trending-down"]=10747363205, ["trending-up"]=10747363465, ["triangle"]=10747363621, ["trophy"]=10747363809,
	["truck"]=10747364031, ["tv"]=10747364593, ["tv-2"]=10747364302, ["type"]=10747364761,
	["umbrella"]=10747364971, ["underline"]=10747365191, ["undo"]=10747365484, ["undo-2"]=10747365359,
	["unlink"]=10747365771, ["unlink-2"]=10747397871, ["unlock"]=10747366027, ["upload"]=10747366434,
	["upload-cloud"]=10747366266, ["usb"]=10747366606, ["user"]=10747373176, ["user-check"]=10747371901,
	["user-cog"]=10747372167, ["user-minus"]=10747372346, ["user-plus"]=10747372702, ["user-x"]=10747372992,
	["users"]=10747373426, ["utensils"]=10747373821, ["utensils-crossed"]=10747373629,
	["venetian-mask"]=10747374003, ["verified"]=10747374131, ["vibrate"]=10747374489,
	["vibrate-off"]=10747374269, ["video"]=10747374938, ["video-off"]=10747374721, ["view"]=10747375132,
	["voicemail"]=10747375281, ["volume"]=10747376008, ["volume-1"]=10747375450, ["volume-2"]=10747375679,
	["volume-x"]=10747375880, ["wallet"]=10747376205, ["wand"]=10747376565, ["wand-2"]=10747376349,
	["watch"]=10747376722, ["waves"]=10747376931, ["webcam"]=10747381992, ["wifi"]=10747382504,
	["wifi-off"]=10747382268, ["wind"]=10747382750, ["wrap-text"]=10747383065, ["wrench"]=10747383470,
	["x"]=10747384394, ["x-circle"]=10747383819, ["x-octagon"]=10747384037, ["x-square"]=10747384217,
	["zoom-in"]=10747384552, ["zoom-out"]=10747384679,
}

-- Black palette with a purple accent.
local Theme = {
	backgroundTop = Color3.fromRGB(19, 19, 23),
	backgroundBottom = Color3.fromRGB(10, 10, 12),
	sidebar = Color3.fromRGB(14, 14, 17),
	surface = Color3.fromRGB(23, 23, 28),
	surfaceHover = Color3.fromRGB(29, 29, 35),
	surfaceAlt = Color3.fromRGB(34, 34, 41),
	track = Color3.fromRGB(44, 44, 52),
	stroke = Color3.fromRGB(38, 38, 46),
	strokeHover = Color3.fromRGB(74, 52, 104),
	text = Color3.fromRGB(242, 242, 246),
	subText = Color3.fromRGB(150, 150, 164),
	mutedText = Color3.fromRGB(98, 98, 112),
	knob = Color3.fromRGB(246, 246, 250),
	accent = Color3.fromRGB(168, 85, 247),
	accentSoft = Color3.fromRGB(38, 25, 56),
	accentDeep = Color3.fromRGB(118, 44, 214),
	accentText = Color3.fromRGB(214, 178, 255),
	flake = Color3.fromRGB(232, 234, 244),
	shadow = Color3.fromRGB(0, 0, 0),
	success = Color3.fromRGB(52, 211, 153),
	successSoft = Color3.fromRGB(18, 40, 32),
	warning = Color3.fromRGB(251, 191, 36),
	warningSoft = Color3.fromRGB(44, 35, 16),
	danger = Color3.fromRGB(248, 113, 113),
	dangerSoft = Color3.fromRGB(46, 20, 22),
	logoTile = Color3.fromRGB(6, 6, 8),
	logoEdge = Color3.fromRGB(48, 48, 58),
}

local Fonts = {
	regular = Font.new(GOTHAM, Enum.FontWeight.Regular),
	medium = Font.new(GOTHAM, Enum.FontWeight.Medium),
	semibold = Font.new(GOTHAM, Enum.FontWeight.SemiBold),
	bold = Font.new(GOTHAM, Enum.FontWeight.Bold),
}

local Motion = {
	quick = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	drag = TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
	ripple = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

local Library = {
	windows = {},
	notifications = nil,
	Theme = Theme,
	Icons = IconIds,
}
Library.__index = Library

--==============================================================
-- Utility
--==============================================================

local Util = {}

-- Single constructor so every instance shares the same defaults.
function Util.new(className, properties, children)
	local object = Instance.new(className)

	if object:IsA("GuiObject") then
		object.BorderSizePixel = 0
	end
	if object:IsA("TextButton") or object:IsA("ImageButton") then
		object.AutoButtonColor = false
	end
	if object:IsA("TextLabel") or object:IsA("TextBox") or object:IsA("TextButton") then
		object.FontFace = Fonts.medium
		object.TextColor3 = Theme.text
		object.TextSize = 13
		object.BackgroundTransparency = 1
		object.TextXAlignment = Enum.TextXAlignment.Left
	end
	if object:IsA("TextBox") then
		object.ClearTextOnFocus = false
		object.PlaceholderColor3 = Theme.mutedText
	end
	if object:IsA("ImageLabel") or object:IsA("ImageButton") then
		object.BackgroundTransparency = 1
	end

	for key, value in pairs(properties or {}) do
		object[key] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = object
	end

	return object
end

function Util.corner(parent, radius)
	return Util.new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

function Util.stroke(parent, color, thickness, transparency)
	return Util.new("UIStroke", {
		Color = color or Theme.stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

function Util.padding(parent, top, right, bottom, left)
	return Util.new("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or right or top or 0),
		Parent = parent,
	})
end

function Util.list(parent, padding, direction)
	return Util.new("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		FillDirection = direction or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

function Util.tween(object, info, goal)
	local animation = tweenService:Create(object, info, goal)
	animation:Play()
	return animation
end

-- Accepts a Lucide name ("home", "lucide-home") or a raw asset string.
function Util.icon(name)
	if type(name) ~= "string" or name == "" then
		return nil
	end
	if string.find(name, "rbxasset", 1, true) or string.find(name, "http", 1, true) then
		return name
	end

	local key = string.gsub(string.lower(name), "^lucide%-", "")
	local id = IconIds[key]
	return id and ("rbxassetid://" .. id) or nil
end

-- Asset ids can be moderated or fail to fetch; each id is checked once and any
-- broken one is hidden (with its tile) instead of showing a bugged square.
local iconState = {}

function Util.verifyIcon(image)
	local id = image.Image
	if id == "" then
		image.Visible = false
		return
	end

	local state = iconState[id]
	if state == true then
		return
	end
	if state == false then
		image.Image = ""
		image.Visible = false
		if image.Parent and image.Parent.Name == "IconTile" then
			image.Parent.Visible = false
		end
		return
	end
	if state then
		table.insert(state, image)
		return
	end

	local waiting = { image }
	iconState[id] = waiting

	task.spawn(function()
		local loaded = true
		pcall(function()
			contentProvider:PreloadAsync({ id }, function(_, status)
				if status == Enum.AssetFetchStatus.Failure then
					loaded = false
				end
			end)
		end)

		iconState[id] = loaded
		if loaded then
			return
		end
		warn("[Moon Hub] icon failed to load: " .. id)
		for _, pending in ipairs(waiting) do
			if pending.Parent then
				pending.Image = ""
				pending.Visible = false
				if pending.Parent.Name == "IconTile" then
					pending.Parent.Visible = false
				end
			end
		end
	end)
end

function Util.image(parent, iconName, size, color, properties)
	local image = Util.new("ImageLabel", {
		Image = Util.icon(iconName) or "",
		ImageColor3 = color or Theme.subText,
		Size = UDim2.fromOffset(size, size),
		ScaleType = Enum.ScaleType.Fit,
		Parent = parent,
	})
	for key, value in pairs(properties or {}) do
		image[key] = value
	end
	Util.verifyIcon(image)
	return image
end

function Util.textWidth(text, size)
	return textService:GetTextSize(text, size, Enum.Font.GothamBold, Vector2.new(2000, 100)).X
end

-- Callbacks never break the UI; errors are reported instead.
function Util.call(callback, ...)
	if type(callback) ~= "function" then
		return
	end
	local arguments = table.pack(...)
	task.spawn(function()
		local ok, err = pcall(callback, table.unpack(arguments, 1, arguments.n))
		if not ok then
			warn("[Moon Hub] callback error: " .. tostring(err))
		end
	end)
end

function Util.isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

function Util.isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

-- Material style ripple from the cursor position, sized in scale so UIScale never skews it.
function Util.ripple(button, color)
	button.MouseButton1Down:Connect(function()
		local mouse = userInputService:GetMouseLocation()
		local absolutePosition, absoluteSize = button.AbsolutePosition, button.AbsoluteSize
		if absoluteSize.X <= 0 then
			return
		end

		local circle = Util.new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color or Theme.accent,
			BackgroundTransparency = 0.85,
			Position = UDim2.fromScale(
				(mouse.X - absolutePosition.X) / absoluteSize.X,
				(mouse.Y - absolutePosition.Y) / absoluteSize.Y
			),
			Size = UDim2.fromScale(0, 0),
			ZIndex = 8,
			Parent = button,
		})
		Util.corner(circle, 999)
		Util.new("UIAspectRatioConstraint", {
			AspectRatio = 1,
			DominantAxis = Enum.DominantAxis.Width,
			Parent = circle,
		})

		Util.tween(circle, Motion.ripple, { Size = UDim2.fromScale(2.4, 2.4), BackgroundTransparency = 1 })
		task.delay(0.6, function()
			circle:Destroy()
		end)
	end)
end

-- Smooth drag for mouse and touch; the returned state tells clicks from drags.
function Util.draggable(handle, target)
	local state = { dragging = false, moved = false }
	local dragStart, startPosition

	handle.InputBegan:Connect(function(input)
		if not Util.isPress(input) then
			return
		end
		state.dragging = true
		state.moved = false
		dragStart = input.Position
		startPosition = target.Position

		local endConnection
		endConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				state.dragging = false
				endConnection:Disconnect()
			end
		end)
	end)

	userInputService.InputChanged:Connect(function(input)
		if not state.dragging or not Util.isMove(input) then
			return
		end

		local delta = input.Position - dragStart
		if delta.Magnitude > 5 then
			state.moved = true
		end

		Util.tween(target, Motion.drag, {
			Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			),
		})
	end)

	return state
end

-- The executor hidden container keeps the gui out of CoreGui listings.
function Util.parentGui(screenGui)
	if typeof(gethui) == "function" then
		screenGui.Parent = gethui()
		return
	end
	local ok = pcall(function()
		screenGui.Parent = coreGui
	end)
	if not ok then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end
end

-- JSON cannot hold Roblox types, so they are tagged on the way out.
function Util.encode(value)
	local kind = typeof(value)
	if kind == "Color3" then
		return { __type = "Color3", r = value.R, g = value.G, b = value.B }
	elseif kind == "EnumItem" then
		return { __type = "EnumItem", enum = tostring(value.EnumType), name = value.Name }
	end
	return value
end

function Util.decode(value)
	if type(value) ~= "table" then
		return value
	end
	if value.__type == "Color3" then
		return Color3.new(value.r, value.g, value.b)
	elseif value.__type == "EnumItem" then
		local ok, item = pcall(function()
			return Enum[value.enum][value.name]
		end)
		return ok and item or nil
	end
	return value
end

--==============================================================
-- Decorations
--==============================================================

local Decor = {}

-- Soft 9-slice shadow, the thing that makes a white UI read on any background.
function Decor.shadow(parent, transparency, spread)
	spread = spread or 46
	return Util.new("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 6),
		Size = UDim2.new(1, spread, 1, spread),
		Image = SHADOW_IMAGE,
		ImageColor3 = Theme.shadow,
		ImageTransparency = transparency or 0.8,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0,
		Parent = parent,
	})
end

-- The Moon Hub mark (cat watching the moon) is hosted with the library and turned
-- into a local asset once; until it arrives, or without file support, a moon icon
-- stands in so the badge is never empty.
local Logo = { asset = nil, loading = false, waiting = {} }

function Logo.apply(image)
	image.Image = Logo.asset
	image.ImageColor3 = Color3.new(1, 1, 1)
	image.Size = UDim2.fromScale(0.86, 0.86)
	image.Visible = true
end

function Logo.request(image)
	if Logo.asset then
		Logo.apply(image)
		return
	end
	table.insert(Logo.waiting, image)

	if Logo.loading or typeof(getcustomasset) ~= "function" or typeof(writefile) ~= "function" then
		return
	end
	Logo.loading = true

	task.spawn(function()
		local ok, result = pcall(function()
			local path = CONFIG_FOLDER .. "/" .. LOGO_FILE
			if not (typeof(isfile) == "function" and isfile(path)) then
				local response = request({ Url = LOGO_URL, Method = "GET" })
				if type(response) ~= "table" or response.StatusCode ~= 200 then
					error("download failed (" .. tostring(response and response.StatusCode) .. ")")
				end
				if typeof(isfolder) == "function" and not isfolder(CONFIG_FOLDER) then
					makefolder(CONFIG_FOLDER)
				end
				writefile(path, response.Body)
			end
			return getcustomasset(path)
		end)

		if not ok or type(result) ~= "string" then
			warn("[Moon Hub] logo unavailable: " .. tostring(result))
			return
		end

		Logo.asset = result
		for _, pending in ipairs(Logo.waiting) do
			if pending.Parent then
				Logo.apply(pending)
			end
		end
		Logo.waiting = {}
	end)
end

function Decor.logo(parent, size)
	local tile = Util.new("Frame", {
		Name = "MoonHubLogo",
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = Theme.logoTile,
		Parent = parent,
	})
	Util.corner(tile, math.floor(size * 0.28))
	Util.stroke(tile, Theme.logoEdge, 1)

	local image = Util.image(tile, "moon", size, Theme.text, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),
	})
	Logo.request(image)

	return tile
end

--==============================================================
-- Falling snow
--==============================================================

local Snow = {}
Snow.__index = Snow

function Snow.new(parent, zIndex)
	local self = setmetatable({}, Snow)
	self.paused = false
	self.flakes = {}

	self.layer = Util.new("Frame", {
		Name = "Snowfall",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = zIndex or 3,
		Parent = parent,
	})

	for index = 1, FLAKE_COUNT + ICON_FLAKE_COUNT do
		local isIcon = index > FLAKE_COUNT
		local size = isIcon and math.random(9, 14) or math.random(2, 5)
		local object

		if isIcon then
			object = Util.image(self.layer, "snowflake", size, Theme.flake, {
				ImageTransparency = math.random(30, 60) / 100,
			})
		else
			object = Util.new("Frame", {
				BackgroundColor3 = Theme.flake,
				BackgroundTransparency = math.random(20, 60) / 100,
				Size = UDim2.fromOffset(size, size),
				Parent = self.layer,
			})
			Util.corner(object, size)
		end

		self.flakes[index] = {
			object = object,
			isIcon = isIcon,
			x = math.random(),
			y = math.random(),
			speed = math.random(30, 75) / 1000,
			phase = math.random() * math.pi * 2,
			swing = math.random(4, 14) / 1000,
			spin = math.random(-60, 60),
		}
	end

	self.connection = runService.RenderStepped:Connect(function(delta)
		if self.paused then
			return
		end
		local step = math.min(delta, 1 / 20)

		for _, flake in ipairs(self.flakes) do
			flake.y = flake.y + flake.speed * step * 1.2
			flake.phase = flake.phase + step * 2.2

			if flake.y > 1.04 then
				flake.y = -0.04
				flake.x = math.random()
			end

			flake.object.Position = UDim2.fromScale((flake.x + math.sin(flake.phase) * flake.swing) % 1, flake.y)
			if flake.isIcon then
				flake.object.Rotation = flake.object.Rotation + flake.spin * step
			end
		end
	end)

	return self
end

function Snow:destroy()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
	self.layer:Destroy()
end

--==============================================================
-- Elements
--==============================================================

local Elements = {}

-- Every row shares this skeleton: icon tile, title, description and a right slot.
function Elements.card(tab, options, rightWidth)
	local hasDescription = type(options.Description) == "string" and options.Description ~= ""
	local headerHeight = hasDescription and 56 or 44
	rightWidth = rightWidth or 60

	local card = Util.new("TextButton", {
		Name = options.Name or "Element",
		Text = "",
		BackgroundColor3 = Theme.surface,
		Size = UDim2.new(1, 0, 0, headerHeight),
		ClipsDescendants = true,
		Parent = tab.page,
	})
	Util.corner(card, 10)
	local stroke = Util.stroke(card, Theme.stroke)

	local textInset = 14
	local iconImage = nil

	if options.Icon then
		local tile = Util.new("Frame", {
			Name = "IconTile",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0, headerHeight / 2),
			Size = UDim2.fromOffset(28, 28),
			BackgroundColor3 = Theme.surfaceAlt,
			Parent = card,
		})
		Util.corner(tile, 8)

		iconImage = Util.image(tile, options.Icon, 15, Theme.subText, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
		textInset = 50
	end

	local title = Util.new("TextLabel", {
		Name = "Title",
		Position = UDim2.new(0, textInset, 0, hasDescription and 11 or 0),
		Size = UDim2.new(1, -textInset - rightWidth - 16, 0, hasDescription and 17 or headerHeight),
		Text = options.Name or "Element",
		FontFace = Fonts.semibold,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = card,
	})

	if hasDescription then
		Util.new("TextLabel", {
			Name = "Description",
			Position = UDim2.new(0, textInset, 0, 29),
			Size = UDim2.new(1, -textInset - rightWidth - 16, 0, 15),
			Text = options.Description,
			TextColor3 = Theme.subText,
			TextSize = 11,
			FontFace = Fonts.regular,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = card,
		})
	end

	card.MouseEnter:Connect(function()
		Util.tween(card, Motion.quick, { BackgroundColor3 = Theme.surfaceHover })
		Util.tween(stroke, Motion.quick, { Color = Theme.strokeHover })
		if iconImage then
			Util.tween(iconImage, Motion.quick, { ImageColor3 = Theme.accent })
		end
	end)
	card.MouseLeave:Connect(function()
		Util.tween(card, Motion.quick, { BackgroundColor3 = Theme.surface })
		Util.tween(stroke, Motion.quick, { Color = Theme.stroke })
		if iconImage then
			Util.tween(iconImage, Motion.quick, { ImageColor3 = Theme.subText })
		end
	end)

	tab:register(options.Name or "", card, true)

	return card, { headerHeight = headerHeight, stroke = stroke, title = title }
end

-- Shared tail for every control: flags and the returned handle.
function Elements.finish(tab, options, control)
	if options.Flag then
		tab.window.flags[options.Flag] = control
	end
	return control
end

function Elements.section(tab, text)
	local holder = Util.new("Frame", {
		Name = "Section",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 26),
		Parent = tab.page,
	})

	local upper = string.upper(text)
	local width = Util.textWidth(upper, 11)

	Util.new("TextLabel", {
		Position = UDim2.new(0, 2, 0, 8),
		Size = UDim2.new(0, width + 4, 0, 14),
		Text = upper,
		TextColor3 = Theme.subText,
		TextSize = 11,
		FontFace = Fonts.bold,
		Parent = holder,
	})

	local line = Util.new("Frame", {
		Position = UDim2.new(0, width + 14, 0, 15),
		Size = UDim2.new(1, -width - 16, 0, 1),
		BackgroundColor3 = Theme.stroke,
		Parent = holder,
	})
	Util.new("UIGradient", {
		Transparency = NumberSequence.new(0, 1),
		Parent = line,
	})

	tab:register(text, holder, false)
	return holder
end

function Elements.label(tab, text)
	local label = Util.new("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = text,
		TextColor3 = Theme.subText,
		TextSize = 12,
		FontFace = Fonts.regular,
		TextWrapped = true,
		Parent = tab.page,
	})
	Util.padding(label, 2, 4, 2, 4)

	tab:register(text, label, false)

	return {
		instance = label,
		Set = function(_, value)
			label.Text = tostring(value)
		end,
	}
end

function Elements.paragraph(tab, options)
	local card = Util.new("Frame", {
		Name = "Paragraph",
		BackgroundColor3 = Theme.surface,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = tab.page,
	})
	Util.corner(card, 10)
	Util.stroke(card, Theme.stroke)
	Util.padding(card, 13, 14, 14, options.Icon and 50 or 14)

	if options.Icon then
		local tile = Util.new("Frame", {
			Position = UDim2.new(0, -38, 0, -2),
			Size = UDim2.fromOffset(28, 28),
			BackgroundColor3 = Theme.accentSoft,
			Parent = card,
		})
		Util.corner(tile, 8)
		Util.image(tile, options.Icon, 15, Theme.accent, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end

	-- Text lives in its own stack so the list layout never grabs the icon tile.
	local stack = Util.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = card,
	})
	Util.list(stack, 5)

	local title = Util.new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		Text = options.Title or "Paragraph",
		FontFace = Fonts.bold,
		LayoutOrder = 1,
		Parent = stack,
	})

	local body = Util.new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = options.Content or "",
		TextColor3 = Theme.subText,
		TextSize = 12,
		FontFace = Fonts.regular,
		TextWrapped = true,
		LineHeight = 1.1,
		LayoutOrder = 2,
		Parent = stack,
	})

	tab:register(options.Title or "", card, false)

	return {
		instance = card,
		Set = function(_, newTitle, newContent)
			title.Text = newTitle or title.Text
			body.Text = newContent or body.Text
		end,
	}
end

function Elements.divider(tab)
	local holder = Util.new("Frame", {
		Name = "Divider",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 9),
		Parent = tab.page,
	})
	Util.new("Frame", {
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.stroke,
		Parent = holder,
	})
	tab:register("", holder, false)
	return holder
end

function Elements.button(tab, options)
	local card, parts = Elements.card(tab, options, 30)

	local arrow = Util.image(card, options.ButtonIcon or "chevron-right", 16, Theme.mutedText, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, parts.headerHeight / 2),
	})

	card.MouseEnter:Connect(function()
		Util.tween(arrow, Motion.quick, { ImageColor3 = Theme.accent, Position = UDim2.new(1, -11, 0, parts.headerHeight / 2) })
	end)
	card.MouseLeave:Connect(function()
		Util.tween(arrow, Motion.quick, { ImageColor3 = Theme.mutedText, Position = UDim2.new(1, -14, 0, parts.headerHeight / 2) })
	end)

	Util.ripple(card)
	card.MouseButton1Click:Connect(function()
		Util.call(options.Callback)
	end)

	return { instance = card }
end

function Elements.toggle(tab, options)
	local card, parts = Elements.card(tab, options, 44)

	local track = Util.new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, parts.headerHeight / 2),
		Size = UDim2.fromOffset(40, 22),
		BackgroundColor3 = Theme.track,
		Parent = card,
	})
	Util.corner(track, 11)

	local knob = Util.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Theme.knob,
		Parent = track,
	})
	Util.corner(knob, 8)
	Util.stroke(knob, Theme.shadow, 1, 0.88)

	local control = { instance = card, value = false }

	function control:Set(state, silent)
		self.value = state == true
		Util.tween(track, Motion.quick, { BackgroundColor3 = self.value and Theme.accent or Theme.track })
		Util.tween(knob, Motion.spring, {
			Position = self.value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		})
		if not silent then
			Util.call(options.Callback, self.value)
		end
	end

	Util.ripple(card)
	card.MouseButton1Click:Connect(function()
		control:Set(not control.value)
	end)

	control:Set(options.Default == true, true)
	return Elements.finish(tab, options, control)
end

function Elements.slider(tab, options)
	local minimum = options.Min or 0
	local maximum = options.Max or 100
	local decimals = options.Decimals or options.Rounding or 0

	local card, parts = Elements.card(tab, options, 70)
	local headerHeight = parts.headerHeight
	card.Size = UDim2.new(1, 0, 0, headerHeight + 14)

	local valueBox = Util.new("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, headerHeight / 2),
		Size = UDim2.fromOffset(62, 24),
		BackgroundColor3 = Theme.surfaceAlt,
		BackgroundTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Center,
		FontFace = Fonts.semibold,
		TextSize = 12,
		Text = "",
		Parent = card,
	})
	Util.corner(valueBox, 7)

	local track = Util.new("Frame", {
		Position = UDim2.new(0, 14, 0, headerHeight - 2),
		Size = UDim2.new(1, -28, 0, 6),
		BackgroundColor3 = Theme.track,
		Parent = card,
	})
	Util.corner(track, 3)

	local fill = Util.new("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = Theme.surface,
		Parent = track,
	})
	Util.corner(fill, 3)
	Util.new("UIGradient", {
		Color = ColorSequence.new(Theme.accentDeep, Theme.accent),
		Parent = fill,
	})

	local knob = Util.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Theme.knob,
		Parent = track,
	})
	Util.corner(knob, 7)
	Util.stroke(knob, Theme.accent, 2)

	local control = { instance = card, value = minimum }

	function control:Set(value, silent)
		local number = tonumber(value) or self.value
		local factor = 10 ^ decimals
		number = math.clamp(math.floor(number * factor + 0.5) / factor, minimum, maximum)
		self.value = number

		local alpha = (number - minimum) / math.max(maximum - minimum, 1e-6)
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
		valueBox.Text = tostring(number) .. (options.Suffix or "")

		if not silent then
			Util.call(options.Callback, number)
		end
	end

	-- Typing a number into the value pill sets it directly.
	valueBox.FocusLost:Connect(function()
		local typed = string.gsub(valueBox.Text, "[^%d%.%-]", "")
		control:Set(tonumber(typed) or control.value)
	end)

	local grabber = Util.new("TextButton", {
		Text = "",
		Position = UDim2.new(0, -6, 0, -9),
		Size = UDim2.new(1, 12, 1, 18),
		ZIndex = 3,
		Parent = track,
	})

	local dragging = false

	local function applyInput(input)
		local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		control:Set(minimum + (maximum - minimum) * alpha)
	end

	grabber.InputBegan:Connect(function(input)
		if not Util.isPress(input) then
			return
		end
		dragging = true
		Util.tween(knob, Motion.quick, { Size = UDim2.fromOffset(18, 18) })
		applyInput(input)
	end)

	userInputService.InputEnded:Connect(function(input)
		if dragging and Util.isPress(input) then
			dragging = false
			Util.tween(knob, Motion.quick, { Size = UDim2.fromOffset(14, 14) })
		end
	end)

	userInputService.InputChanged:Connect(function(input)
		if dragging and Util.isMove(input) then
			applyInput(input)
		end
	end)

	control:Set(options.Default or minimum, true)
	return Elements.finish(tab, options, control)
end

function Elements.dropdown(tab, options)
	local list = options.Options or options.Values or {}
	local multi = options.Multi == true
	local maxVisible = options.MaxVisible or 5

	local card, parts = Elements.card(tab, options, 150)
	local headerHeight = parts.headerHeight

	local chevron = Util.image(card, "chevron-down", 16, Theme.mutedText, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, headerHeight / 2),
	})

	local selectedLabel = Util.new("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -38, 0, headerHeight / 2),
		Size = UDim2.fromOffset(120, 18),
		Text = "None",
		TextColor3 = Theme.subText,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = card,
	})

	local body = Util.new("Frame", {
		Name = "Body",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, headerHeight),
		Size = UDim2.new(1, -20, 0, 0),
		Parent = card,
	})

	local divider = Util.new("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.stroke,
		Parent = body,
	})

	local searchBox = nil
	local listTop = 8

	-- Long lists get their own filter box.
	if #list > 6 or options.Searchable then
		local searchHolder = Util.new("Frame", {
			Position = UDim2.new(0, 0, 0, 8),
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundColor3 = Theme.surfaceAlt,
			Parent = body,
		})
		Util.corner(searchHolder, 7)
		Util.image(searchHolder, "search", 13, Theme.mutedText, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 9, 0.5, 0),
		})
		searchBox = Util.new("TextBox", {
			Position = UDim2.new(0, 28, 0, 0),
			Size = UDim2.new(1, -34, 1, 0),
			PlaceholderText = "Search...",
			Text = "",
			TextSize = 12,
			Parent = searchHolder,
		})
		listTop = 42
	end

	local scroller = Util.new("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, listTop),
		Size = UDim2.new(1, 0, 0, 0),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = body,
	})
	Util.list(scroller, 3)

	local control = { instance = card, value = multi and {} or nil, buttons = {} }
	local expanded = false

	local function describe()
		if not multi then
			return control.value and tostring(control.value) or "None"
		end
		local picked = {}
		for name, state in pairs(control.value) do
			if state then
				table.insert(picked, tostring(name))
			end
		end
		table.sort(picked)
		return #picked > 0 and table.concat(picked, ", ") or "None"
	end

	local function isSelected(name)
		if multi then
			return control.value[name] == true
		end
		return control.value == name
	end

	local function paint()
		selectedLabel.Text = describe()
		for name, entry in pairs(control.buttons) do
			local active = isSelected(name)
			Util.tween(entry.button, Motion.quick, {
				BackgroundColor3 = active and Theme.accentSoft or Theme.surface,
			})
			entry.button.TextColor3 = active and Theme.accentText or Theme.text
			entry.button.FontFace = active and Fonts.semibold or Fonts.medium
			Util.tween(entry.check, Motion.quick, { ImageTransparency = active and 0 or 1 })
		end
	end

	local function visibleCount()
		local count = 0
		for _, entry in pairs(control.buttons) do
			if entry.button.Visible then
				count = count + 1
			end
		end
		return count
	end

	local function resize(animated)
		local rows = math.min(visibleCount(), maxVisible)
		local listHeight = math.max(rows * 33 - 3, 0)
		local bodyHeight = expanded and (listTop + listHeight + 10) or 0
		local info = animated and Motion.smooth or TweenInfo.new(0)

		Util.tween(scroller, info, { Size = UDim2.new(1, 0, 0, listHeight) })
		Util.tween(body, info, { Size = UDim2.new(1, -20, 0, bodyHeight) })
		Util.tween(card, info, { Size = UDim2.new(1, 0, 0, headerHeight + bodyHeight) })
		Util.tween(chevron, Motion.smooth, {
			Rotation = expanded and 180 or 0,
			ImageColor3 = expanded and Theme.accent or Theme.mutedText,
		})
		divider.Visible = expanded
	end

	function control:Set(value, silent)
		if multi then
			self.value = type(value) == "table" and value or {}
		else
			self.value = value
		end
		paint()
		if not silent then
			Util.call(options.Callback, self.value)
		end
	end

	function control:Refresh(newList, keepSelection)
		list = newList or list
		for _, entry in pairs(control.buttons) do
			entry.button:Destroy()
		end
		control.buttons = {}

		for index, name in ipairs(list) do
			local button = Util.new("TextButton", {
				Name = tostring(name),
				BackgroundColor3 = Theme.surface,
				Size = UDim2.new(1, -4, 0, 30),
				Text = tostring(name),
				TextSize = 12,
				LayoutOrder = index,
				Parent = scroller,
			})
			Util.corner(button, 7)
			Util.padding(button, 0, 30, 0, 10)

			local check = Util.image(button, "check", 14, Theme.accent, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 22, 0.5, 0),
				ImageTransparency = 1,
			})

			button.MouseEnter:Connect(function()
				if not isSelected(name) then
					Util.tween(button, Motion.quick, { BackgroundColor3 = Theme.surfaceAlt })
				end
			end)
			button.MouseLeave:Connect(function()
				if not isSelected(name) then
					Util.tween(button, Motion.quick, { BackgroundColor3 = Theme.surface })
				end
			end)

			button.MouseButton1Click:Connect(function()
				if multi then
					control.value[name] = not control.value[name] or nil
					control:Set(control.value)
				else
					control:Set(name)
					expanded = false
					resize(true)
				end
			end)

			control.buttons[name] = { button = button, check = check }
		end

		if not keepSelection and not multi and control.value ~= nil and not table.find(list, control.value) then
			control.value = nil
		end

		paint()
		resize(false)
	end

	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = string.lower(searchBox.Text)
			for name, entry in pairs(control.buttons) do
				entry.button.Visible = query == "" or string.find(string.lower(tostring(name)), query, 1, true) ~= nil
			end
			resize(true)
		end)
	end

	card.MouseButton1Click:Connect(function()
		expanded = not expanded
		resize(true)
	end)

	control:Refresh(list)
	if options.Default ~= nil then
		control:Set(options.Default, true)
	end

	return Elements.finish(tab, options, control)
end

function Elements.input(tab, options)
	local card, parts = Elements.card(tab, options, 170)

	local field = Util.new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0, parts.headerHeight / 2),
		Size = UDim2.fromOffset(164, 28),
		BackgroundColor3 = Theme.surfaceAlt,
		Parent = card,
	})
	Util.corner(field, 7)
	local fieldStroke = Util.stroke(field, Theme.accent, 1, 1)

	Util.image(field, options.InputIcon or "pencil", 12, Theme.mutedText, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 9, 0.5, 0),
	})

	local box = Util.new("TextBox", {
		Position = UDim2.new(0, 27, 0, 0),
		Size = UDim2.new(1, -34, 1, 0),
		Text = options.Default or "",
		PlaceholderText = options.Placeholder or "Type here...",
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = field,
	})

	local control = { instance = card, value = box.Text }

	function control:Set(value, silent)
		box.Text = tostring(value)
		self.value = box.Text
		if not silent then
			Util.call(options.Callback, self.value)
		end
	end

	card.MouseButton1Click:Connect(function()
		box:CaptureFocus()
	end)

	box.Focused:Connect(function()
		Util.tween(fieldStroke, Motion.quick, { Transparency = 0 })
		Util.tween(field, Motion.quick, { BackgroundColor3 = Theme.surface })
	end)

	box.FocusLost:Connect(function(enterPressed)
		Util.tween(fieldStroke, Motion.quick, { Transparency = 1 })
		Util.tween(field, Motion.quick, { BackgroundColor3 = Theme.surfaceAlt })

		if options.Numeric then
			box.Text = string.gsub(box.Text, "[^%d%.%-]", "")
		end
		control.value = box.Text

		if enterPressed or not options.OnlyOnEnter then
			Util.call(options.Callback, box.Text)
		end
	end)

	return Elements.finish(tab, options, control)
end

function Elements.keybind(tab, options)
	local card, parts = Elements.card(tab, options, 90)

	local keycap = Util.new("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, parts.headerHeight / 2),
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Theme.surfaceAlt,
		BackgroundTransparency = 0,
		Text = "None",
		TextSize = 11,
		FontFace = Fonts.bold,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = card,
	})
	Util.corner(keycap, 6)
	Util.padding(keycap, 0, 10, 0, 10)
	Util.new("UISizeConstraint", { MinSize = Vector2.new(38, 24), Parent = keycap })
	local keyStroke = Util.stroke(keycap, Theme.stroke)

	local control = { instance = card, value = nil }
	local listening = false

	function control:Set(keyCode, silent)
		self.value = keyCode
		keycap.Text = keyCode and keyCode.Name or "None"
		if not silent then
			Util.call(options.ChangedCallback, keyCode)
		end
	end

	card.MouseButton1Click:Connect(function()
		listening = true
		keycap.Text = "..."
		Util.tween(keyStroke, Motion.quick, { Color = Theme.accent })
		keycap.TextColor3 = Theme.accent
	end)

	userInputService.InputBegan:Connect(function(input, processed)
		if listening and input.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			Util.tween(keyStroke, Motion.quick, { Color = Theme.stroke })
			keycap.TextColor3 = Theme.text
			control:Set(input.KeyCode ~= Enum.KeyCode.Backspace and input.KeyCode or nil)
			return
		end

		if processed or listening or not control.value then
			return
		end
		if input.KeyCode == control.value then
			Util.call(options.Callback or options.OnPress, control.value)
		end
	end)

	control:Set(options.Default, true)
	return Elements.finish(tab, options, control)
end

function Elements.colorPicker(tab, options)
	local card, parts = Elements.card(tab, options, 60)
	local headerHeight = parts.headerHeight
	local expandedHeight = 168

	local swatch = Util.new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, headerHeight / 2),
		Size = UDim2.fromOffset(36, 22),
		BackgroundColor3 = Theme.accent,
		Parent = card,
	})
	Util.corner(swatch, 6)
	Util.stroke(swatch, Theme.shadow, 1, 0.85)

	local panel = Util.new("Frame", {
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, headerHeight),
		Size = UDim2.new(1, -28, 0, expandedHeight),
		Parent = card,
	})

	local field = Util.new("Frame", {
		Size = UDim2.new(1, 0, 0, 104),
		BackgroundColor3 = Color3.fromHSV(0.55, 1, 1),
		Parent = panel,
	})
	Util.corner(field, 8)

	-- Saturation runs left to right, value top to bottom.
	local whiteLayer = Util.new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = field })
	Util.corner(whiteLayer, 8)
	Util.new("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = whiteLayer })

	local blackLayer = Util.new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Parent = field })
	Util.corner(blackLayer, 8)
	Util.new("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = blackLayer })

	local fieldCursor = Util.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(12, 12),
		ZIndex = 3,
		Parent = field,
	})
	Util.corner(fieldCursor, 6)
	Util.stroke(fieldCursor, Color3.new(1, 1, 1), 2)

	local hueBar = Util.new("Frame", {
		Position = UDim2.new(0, 0, 0, 114),
		Size = UDim2.new(1, 0, 0, 10),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Parent = panel,
	})
	Util.corner(hueBar, 5)

	local hueKeys = {}
	for index = 0, 6 do
		table.insert(hueKeys, ColorSequenceKeypoint.new(index / 6, Color3.fromHSV(index / 6 % 1, 1, 1)))
	end
	Util.new("UIGradient", { Color = ColorSequence.new(hueKeys), Parent = hueBar })

	local hueCursor = Util.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(6, 16),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Parent = hueBar,
	})
	Util.corner(hueCursor, 3)
	Util.stroke(hueCursor, Theme.shadow, 1, 0.7)

	local hexHolder = Util.new("Frame", {
		Position = UDim2.new(0, 0, 0, 134),
		Size = UDim2.fromOffset(110, 26),
		BackgroundColor3 = Theme.surfaceAlt,
		Parent = panel,
	})
	Util.corner(hexHolder, 7)
	Util.image(hexHolder, "hash", 12, Theme.mutedText, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 8, 0.5, 0),
	})
	local hexBox = Util.new("TextBox", {
		Position = UDim2.new(0, 24, 0, 0),
		Size = UDim2.new(1, -28, 1, 0),
		Text = "",
		TextSize = 12,
		FontFace = Fonts.semibold,
		Parent = hexHolder,
	})

	local control = { instance = card, value = Theme.accent }
	local hue, saturation, brightness = 0, 1, 1
	local expanded = false
	local dragTarget = nil

	local function paint()
		local color = Color3.fromHSV(hue, saturation, brightness)
		field.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		fieldCursor.Position = UDim2.fromScale(saturation, 1 - brightness)
		hueCursor.Position = UDim2.fromScale(hue, 0.5)
		swatch.BackgroundColor3 = color
		hexBox.Text = string.upper(color:ToHex())
		return color
	end

	function control:Set(color, silent)
		if typeof(color) ~= "Color3" then
			return
		end
		hue, saturation, brightness = color:ToHSV()
		self.value = paint()
		if not silent then
			Util.call(options.Callback, self.value)
		end
	end

	local function commit()
		control.value = paint()
		Util.call(options.Callback, control.value)
	end

	local function applyInput(input)
		if dragTarget == field then
			saturation = math.clamp((input.Position.X - field.AbsolutePosition.X) / field.AbsoluteSize.X, 0, 1)
			brightness = 1 - math.clamp((input.Position.Y - field.AbsolutePosition.Y) / field.AbsoluteSize.Y, 0, 1)
		elseif dragTarget == hueBar then
			hue = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 0.999)
		end
		commit()
	end

	-- Transparent buttons on top catch input reliably above the gradient layers.
	for _, target in ipairs({ field, hueBar }) do
		local catcher = Util.new("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, target == hueBar and -4 or 0),
			Size = UDim2.new(1, 0, 1, target == hueBar and 8 or 0),
			ZIndex = 5,
			Parent = target,
		})
		catcher.InputBegan:Connect(function(input)
			if Util.isPress(input) then
				dragTarget = target
				applyInput(input)
			end
		end)
	end

	userInputService.InputChanged:Connect(function(input)
		if dragTarget and Util.isMove(input) then
			applyInput(input)
		end
	end)

	userInputService.InputEnded:Connect(function(input)
		if Util.isPress(input) then
			dragTarget = nil
		end
	end)

	hexBox.FocusLost:Connect(function()
		local ok, color = pcall(Color3.fromHex, (string.gsub(hexBox.Text, "#", "")))
		if ok then
			control:Set(color)
		else
			paint()
		end
	end)

	card.MouseButton1Click:Connect(function()
		expanded = not expanded
		Util.tween(card, Motion.smooth, {
			Size = UDim2.new(1, 0, 0, headerHeight + (expanded and expandedHeight or 0)),
		})
	end)

	control:Set(options.Default or Theme.accent, true)
	return Elements.finish(tab, options, control)
end

--==============================================================
-- Tab
--==============================================================

local Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
	local self = setmetatable({}, Tab)
	self.window = window
	self.name = config.Name or config.Title or "Tab"
	self.icon = config.Icon or "layout-grid"
	self.description = config.Description or ""
	self.elements = {}
	self.active = false

	self.button = Util.new("TextButton", {
		Name = self.name,
		Text = "",
		BackgroundColor3 = Theme.accentSoft,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = #window.tabs + 1,
		Parent = window.tabList,
	})
	Util.corner(self.button, 9)

	self.indicator = Util.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 0),
		BackgroundColor3 = Theme.accent,
		Parent = self.button,
	})
	Util.corner(self.indicator, 2)

	self.iconImage = Util.image(self.button, self.icon, 17, Theme.mutedText, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 13, 0.5, 0),
	})

	self.label = Util.new("TextLabel", {
		Position = UDim2.new(0, 40, 0, 0),
		Size = UDim2.new(1, -46, 1, 0),
		Text = self.name,
		TextColor3 = Theme.subText,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = self.button,
	})

	self.page = Util.new("ScrollingFrame", {
		Name = self.name,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.mutedText,
		ScrollBarImageTransparency = 0.3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Visible = false,
		Parent = window.pageHolder,
	})
	Util.list(self.page, 8)
	Util.padding(self.page, 14, 18, 16, 18)

	self.button.MouseEnter:Connect(function()
		if not self.active then
			Util.tween(self.button, Motion.quick, { BackgroundTransparency = 0, BackgroundColor3 = Theme.surfaceAlt })
			Util.tween(self.label, Motion.quick, { TextColor3 = Theme.text })
		end
	end)
	self.button.MouseLeave:Connect(function()
		if not self.active then
			Util.tween(self.button, Motion.quick, { BackgroundTransparency = 1 })
			Util.tween(self.label, Motion.quick, { TextColor3 = Theme.subText })
		end
	end)
	self.button.MouseButton1Click:Connect(function()
		window:SelectTab(self)
	end)

	return self
end

function Tab:register(name, instance, searchable)
	table.insert(self.elements, {
		name = string.lower(tostring(name)),
		instance = instance,
		searchable = searchable,
	})
end

function Tab:SetActive(active)
	self.active = active
	self.page.Visible = active
	self.label.FontFace = active and Fonts.semibold or Fonts.medium

	Util.tween(self.button, Motion.quick, {
		BackgroundTransparency = active and 0 or 1,
		BackgroundColor3 = Theme.accentSoft,
	})
	Util.tween(self.label, Motion.quick, { TextColor3 = active and Theme.accentText or Theme.subText })
	Util.tween(self.iconImage, Motion.quick, { ImageColor3 = active and Theme.accent or Theme.mutedText })
	Util.tween(self.indicator, Motion.spring, { Size = UDim2.fromOffset(3, active and 18 or 0) })
end

-- Hides everything that does not match; headers vanish while a query is active.
function Tab:filter(query)
	query = string.lower(query or "")
	for _, element in ipairs(self.elements) do
		if query == "" then
			element.instance.Visible = true
		else
			element.instance.Visible = element.searchable and string.find(element.name, query, 1, true) ~= nil
		end
	end
end

function Tab:AddSection(text)
	return Elements.section(self, text)
end

function Tab:AddLabel(text)
	return Elements.label(self, text)
end

function Tab:AddParagraph(options)
	return Elements.paragraph(self, options)
end

function Tab:AddDivider()
	return Elements.divider(self)
end

function Tab:AddButton(options)
	return Elements.button(self, options)
end

function Tab:AddToggle(options)
	return Elements.toggle(self, options)
end

function Tab:AddSlider(options)
	return Elements.slider(self, options)
end

function Tab:AddDropdown(options)
	return Elements.dropdown(self, options)
end

function Tab:AddInput(options)
	return Elements.input(self, options)
end

function Tab:AddKeybind(options)
	return Elements.keybind(self, options)
end

function Tab:AddColorPicker(options)
	return Elements.colorPicker(self, options)
end

--==============================================================
-- Window
--==============================================================

local Window = {}
Window.__index = Window

function Window.new(options)
	local self = setmetatable({}, Window)
	self.title = options.Title or "Moon Hub"
	self.subTitle = options.SubTitle or "Snow Edition"
	self.tabs = {}
	self.flags = {}
	self.connections = {}
	self.activeTab = nil
	self.minimized = false
	self.visible = true
	self.targetScale = 1
	self.toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
	self.size = Vector2.new(options.Width or DESIGN_WIDTH, options.Height or DESIGN_HEIGHT)

	self.gui = Util.new("ScreenGui", {
		Name = "MoonHub_" .. tostring(math.random(10000, 99999)),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 9999,
	})
	Util.parentGui(self.gui)

	-- The holder carries scale and position; root and the snow cap live inside it.
	self.holder = Util.new("Frame", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(self.size.X, self.size.Y),
		BackgroundTransparency = 1,
		Parent = self.gui,
	})
	self.scale = Util.new("UIScale", { Parent = self.holder })
	self.shadow = Decor.shadow(self.holder, 0.78, 60)

	self.root = Util.new("Frame", {
		Name = "Root",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = self.holder,
	})
	Util.corner(self.root, 14)
	Util.stroke(self.root, Theme.stroke, 1)
	Util.new("UIGradient", {
		Color = ColorSequence.new(Theme.backgroundTop, Theme.backgroundBottom),
		Rotation = 90,
		Parent = self.root,
	})

	self:buildSidebar()
	if options.Snow ~= false then
		self.snow = Snow.new(self.root, 3)
	end
	self:buildContent()
	self:buildToggleButton(options)

	self:bindResponsive()
	self:bindToggleKey()

	-- Entrance: grow in from slightly smaller while the shadow fades up.
	self.scale.Scale = self.targetScale * 0.9
	self.shadow.ImageTransparency = 1
	Util.tween(self.scale, Motion.spring, { Scale = self.targetScale })
	Util.tween(self.shadow, Motion.smooth, { ImageTransparency = 0.78 })

	table.insert(Library.windows, self)
	return self
end

function Window:buildSidebar()
	local sidebar = Util.new("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Theme.sidebar,
		Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
		ZIndex = 2,
		Parent = self.root,
	})
	Util.corner(sidebar, 14)

	-- Square off the right side so only the window corners stay rounded.
	Util.new("Frame", {
		BackgroundColor3 = Theme.sidebar,
		Position = UDim2.new(1, -14, 0, 0),
		Size = UDim2.new(0, 14, 1, 0),
		Parent = sidebar,
	})
	Util.new("Frame", {
		BackgroundColor3 = Theme.stroke,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = sidebar,
	})

	-- Brand block, also a drag handle.
	local brand = Util.new("Frame", {
		Name = "Brand",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TOPBAR_HEIGHT + 4),
		Parent = sidebar,
	})

	local logo = Decor.logo(brand, 40)
	logo.Position = UDim2.fromOffset(14, 13)

	Util.new("TextLabel", {
		Position = UDim2.new(0, 64, 0, 18),
		Size = UDim2.new(1, -72, 0, 18),
		Text = self.title,
		TextSize = 16,
		FontFace = Fonts.bold,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = brand,
	})

	Util.new("TextLabel", {
		Position = UDim2.new(0, 64, 0, 37),
		Size = UDim2.new(1, -72, 0, 14),
		Text = self.subTitle,
		TextColor3 = Theme.subText,
		TextSize = 11,
		FontFace = Fonts.regular,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = brand,
	})

	-- Everything listed here is hidden while the window is minimized.
	self.expandedOnly = {}

	self.expandedOnly.menuLabel = Util.new("TextLabel", {
		Position = UDim2.new(0, 18, 0, 76),
		Size = UDim2.new(1, -36, 0, 14),
		Text = "MENU",
		TextColor3 = Theme.mutedText,
		TextSize = 10,
		FontFace = Fonts.bold,
		Parent = sidebar,
	})

	self.tabList = Util.new("ScrollingFrame", {
		Name = "Tabs",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 96),
		Size = UDim2.new(1, -20, 1, -96 - 74),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = sidebar,
	})
	Util.list(self.tabList, 4)

	-- Profile card with the player's headshot.
	self.expandedOnly.tabList = self.tabList

	local profile = Util.new("Frame", {
		Name = "Profile",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 10, 1, -12),
		Size = UDim2.new(1, -20, 0, 50),
		BackgroundColor3 = Theme.surface,
		Parent = sidebar,
	})
	Util.corner(profile, 11)
	Util.stroke(profile, Theme.stroke)
	self.expandedOnly.profile = profile

	local avatar = Util.new("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 9, 0.5, 0),
		Size = UDim2.fromOffset(32, 32),
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.surfaceAlt,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150",
		Parent = profile,
	})
	Util.corner(avatar, 16)

	local onlineDot = Util.new("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 1, 1, 1),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Theme.success,
		Parent = avatar,
	})
	Util.corner(onlineDot, 5)
	Util.stroke(onlineDot, Theme.surface, 2)

	Util.new("TextLabel", {
		Position = UDim2.new(0, 50, 0, 9),
		Size = UDim2.new(1, -58, 0, 16),
		Text = localPlayer.DisplayName,
		FontFace = Fonts.semibold,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = profile,
	})

	Util.new("TextLabel", {
		Position = UDim2.new(0, 50, 0, 25),
		Size = UDim2.new(1, -58, 0, 14),
		Text = "@" .. localPlayer.Name,
		TextColor3 = Theme.subText,
		TextSize = 11,
		FontFace = Fonts.regular,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = profile,
	})

	Util.draggable(brand, self.holder)
end

function Window:buildContent()
	local content = Util.new("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, SIDEBAR_WIDTH + 1, 0, 0),
		Size = UDim2.new(1, -SIDEBAR_WIDTH - 1, 1, 0),
		ZIndex = 4,
		Parent = self.root,
	})
	self.content = content

	local topbar = Util.new("Frame", {
		Name = "Topbar",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TOPBAR_HEIGHT),
		Parent = content,
	})

	local tabTile = Util.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(34, 34),
		BackgroundColor3 = Theme.accentSoft,
		Parent = topbar,
	})
	Util.corner(tabTile, 10)

	self.topIcon = Util.image(tabTile, "layout-grid", 17, Theme.accent, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	})

	self.topTitle = Util.new("TextLabel", {
		Position = UDim2.new(0, 62, 0, 13),
		Size = UDim2.new(1, -330, 0, 20),
		Text = "",
		TextSize = 17,
		FontFace = Fonts.bold,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = topbar,
	})

	self.topDescription = Util.new("TextLabel", {
		Position = UDim2.new(0, 62, 0, 34),
		Size = UDim2.new(1, -330, 0, 14),
		Text = "",
		TextColor3 = Theme.subText,
		TextSize = 11,
		FontFace = Fonts.regular,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = topbar,
	})

	-- Window buttons.
	local buttons = {
		{ icon = "x", action = "close", hover = Theme.dangerSoft, tint = Theme.danger },
		{ icon = "minus", action = "minimize", hover = Theme.surfaceAlt, tint = Theme.text },
	}
	for index, info in ipairs(buttons) do
		local button = Util.new("TextButton", {
			Name = info.action,
			Text = "",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16 - (index - 1) * 36, 0.5, 0),
			Size = UDim2.fromOffset(30, 30),
			BackgroundColor3 = Theme.surface,
			Parent = topbar,
		})
		Util.corner(button, 8)
		local buttonStroke = Util.stroke(button, Theme.stroke)

		local icon = Util.image(button, info.icon, 15, Theme.subText, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
		if info.action == "minimize" then
			self.minimizeIcon = icon
		end

		button.MouseEnter:Connect(function()
			Util.tween(button, Motion.quick, { BackgroundColor3 = info.hover })
			Util.tween(buttonStroke, Motion.quick, { Transparency = 1 })
			Util.tween(icon, Motion.quick, { ImageColor3 = info.tint })
		end)
		button.MouseLeave:Connect(function()
			Util.tween(button, Motion.quick, { BackgroundColor3 = Theme.surface })
			Util.tween(buttonStroke, Motion.quick, { Transparency = 0 })
			Util.tween(icon, Motion.quick, { ImageColor3 = Theme.subText })
		end)

		button.MouseButton1Click:Connect(function()
			if info.action == "close" then
				self:Destroy()
			else
				self:SetMinimized(not self.minimized)
			end
		end)
	end

	-- Search filters the elements of the open tab.
	local search = Util.new("Frame", {
		Name = "Search",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -90, 0.5, 0),
		Size = UDim2.fromOffset(170, 32),
		BackgroundColor3 = Theme.surface,
		Parent = topbar,
	})
	Util.corner(search, 9)
	local searchStroke = Util.stroke(search, Theme.stroke)

	local searchIcon = Util.image(search, "search", 14, Theme.mutedText, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
	})

	self.searchBox = Util.new("TextBox", {
		Position = UDim2.new(0, 31, 0, 0),
		Size = UDim2.new(1, -38, 1, 0),
		PlaceholderText = "Search...",
		Text = "",
		TextSize = 12,
		Parent = search,
	})

	self.searchBox.Focused:Connect(function()
		Util.tween(searchStroke, Motion.quick, { Color = Theme.accent })
		Util.tween(searchIcon, Motion.quick, { ImageColor3 = Theme.accent })
	end)
	self.searchBox.FocusLost:Connect(function()
		Util.tween(searchStroke, Motion.quick, { Color = Theme.stroke })
		Util.tween(searchIcon, Motion.quick, { ImageColor3 = Theme.mutedText })
	end)
	self.searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if self.activeTab then
			self.activeTab:filter(self.searchBox.Text)
		end
	end)

	local divider = Util.new("Frame", {
		Position = UDim2.new(0, 18, 0, TOPBAR_HEIGHT),
		Size = UDim2.new(1, -36, 0, 1),
		BackgroundColor3 = Theme.stroke,
		Parent = content,
	})
	Util.new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.8, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = divider,
	})
	self.expandedOnly.divider = divider

	-- CanvasGroup lets a whole page fade in as one piece on tab change.
	self.pageHolder = Util.new("CanvasGroup", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, TOPBAR_HEIGHT + 1),
		Size = UDim2.new(1, 0, 1, -TOPBAR_HEIGHT - 1),
		Parent = content,
	})

	Util.draggable(topbar, self.holder)
end

-- Floating pill that opens and closes the window on any device, WindUI style.
-- It can be dragged anywhere; a drag never counts as a click.
function Window:buildToggleButton(options)
	-- Fixed width from the title; AutomaticSize next to a scaled shadow can feed back on itself.
	local width = 6 + 30 + 9 + Util.textWidth(self.title, 13) + 9 + 7 + 16

	local holder = Util.new("Frame", {
		Name = "ToggleButton",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.fromOffset(width, 40),
		BackgroundTransparency = 1,
		Visible = options.ToggleButton ~= false,
		Parent = self.gui,
	})
	Decor.shadow(holder, 0.7, 28)

	local button = Util.new("TextButton", {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme.surface,
		ZIndex = 1,
		Parent = holder,
	})
	Util.corner(button, 20)
	local buttonStroke = Util.stroke(button, Theme.stroke)
	Util.padding(button, 0, 16, 0, 6)
	Util.list(button, 9, Enum.FillDirection.Horizontal).VerticalAlignment = Enum.VerticalAlignment.Center

	local mark = Decor.logo(button, 30)
	mark.LayoutOrder = 1

	Util.new("TextLabel", {
		Size = UDim2.fromOffset(0, 40),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = self.title,
		FontFace = Fonts.bold,
		TextSize = 13,
		LayoutOrder = 2,
		Parent = button,
	})

	local stateDot = Util.new("Frame", {
		Size = UDim2.fromOffset(7, 7),
		BackgroundColor3 = Theme.success,
		LayoutOrder = 3,
		Parent = button,
	})
	Util.corner(stateDot, 4)

	button.MouseEnter:Connect(function()
		Util.tween(button, Motion.quick, { BackgroundColor3 = Theme.surfaceHover })
		Util.tween(buttonStroke, Motion.quick, { Color = Theme.strokeHover })
	end)
	button.MouseLeave:Connect(function()
		Util.tween(button, Motion.quick, { BackgroundColor3 = Theme.surface })
		Util.tween(buttonStroke, Motion.quick, { Color = Theme.stroke })
	end)

	local dragState = Util.draggable(button, holder)
	button.MouseButton1Click:Connect(function()
		if not dragState.moved then
			self:Toggle()
		end
	end)

	self.toggleButton = holder
	self.toggleDot = stateDot
	self.toggleScale = Util.new("UIScale", { Parent = holder })
end

function Window:AddTab(config, icon, description)
	if type(config) == "string" then
		config = { Name = config, Icon = icon, Description = description }
	end

	local tab = Tab.new(self, config or {})
	table.insert(self.tabs, tab)

	if not self.activeTab then
		self:SelectTab(tab)
	else
		tab:SetActive(false)
	end

	return tab
end

function Window:SelectTab(tab)
	if self.activeTab == tab then
		return
	end

	for _, other in ipairs(self.tabs) do
		if other ~= tab then
			other:SetActive(false)
		end
	end
	tab:SetActive(true)
	self.activeTab = tab

	tab:filter(self.searchBox.Text)

	-- Header swaps with a short fade so the change is noticed.
	self.topTitle.Text = tab.name
	self.topDescription.Text = tab.description ~= "" and tab.description or self.subTitle
	self.topIcon.Image = Util.icon(tab.icon) or ""
	self.topIcon.Visible = true
	Util.verifyIcon(self.topIcon)

	self.topTitle.TextTransparency = 1
	self.topDescription.TextTransparency = 1
	self.topIcon.ImageTransparency = 1
	Util.tween(self.topTitle, Motion.smooth, { TextTransparency = 0 })
	Util.tween(self.topDescription, Motion.smooth, { TextTransparency = 0 })
	Util.tween(self.topIcon, Motion.smooth, { ImageTransparency = 0 })

	self.pageHolder.GroupTransparency = 1
	tab.page.Position = UDim2.fromOffset(0, 14)
	Util.tween(self.pageHolder, Motion.smooth, { GroupTransparency = 0 })
	Util.tween(tab.page, Motion.smooth, { Position = UDim2.fromOffset(0, 0) })
end

-- The holder is center anchored, so the position shifts by half the height change
-- to keep the top edge still; otherwise the bar would slide to the middle.
function Window:SetMinimized(state)
	if self.minimized == state then
		return
	end
	self.minimized = state

	local collapsedHeight = TOPBAR_HEIGHT + 4
	local shift = (self.size.Y - collapsedHeight) / 2 * self.scale.Scale * (state and -1 or 1)
	local position = self.holder.Position

	self.pageHolder.Visible = not state
	for _, object in pairs(self.expandedOnly) do
		object.Visible = not state
	end
	if self.minimizeIcon then
		self.minimizeIcon.Image = Util.icon(state and "maximize-2" or "minus") or ""
	end

	Util.tween(self.holder, Motion.smooth, {
		Size = UDim2.fromOffset(self.size.X, state and collapsedHeight or self.size.Y),
		Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + shift),
	})
end

function Window:SetVisible(state)
	self.visible = state
	if self.snow then
		self.snow.paused = not state
	end

	-- The pill dot shows at a glance whether the window is open.
	Util.tween(self.toggleDot, Motion.quick, { BackgroundColor3 = state and Theme.success or Theme.mutedText })

	if state then
		self.holder.Visible = true
		self.scale.Scale = self.targetScale * 0.92
		Util.tween(self.scale, Motion.spring, { Scale = self.targetScale })
		return
	end

	Util.tween(self.scale, Motion.quick, { Scale = self.targetScale * 0.92 })
	task.delay(0.15, function()
		if not self.visible then
			self.holder.Visible = false
		end
	end)
end

function Window:SetToggleButtonVisible(state)
	self.toggleButton.Visible = state
end

function Window:Toggle()
	self:SetVisible(not self.visible)
end

function Window:Notify(options)
	return Library:Notify(options)
end

-- Fits the design size to any viewport, phones included.
function Window:bindResponsive()
	local camera = workspace.CurrentCamera

	local function apply()
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local factor = math.min(viewport.X / (self.size.X + 80), viewport.Y / (self.size.Y + 80))

		self.targetScale = math.clamp(factor, MIN_SCALE, MAX_SCALE)
		self.scale.Scale = self.targetScale
		self.toggleScale.Scale = math.clamp(self.targetScale, 0.8, 1.1)

		-- Pull the window back in if a resize left it off screen.
		local center = self.holder.AbsolutePosition + self.holder.AbsoluteSize / 2
		if center.X < 0 or center.Y < 0 or center.X > viewport.X or center.Y > viewport.Y then
			self.holder.Position = UDim2.fromScale(0.5, 0.5)
		end
	end

	apply()
	if camera then
		table.insert(self.connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(apply))
	end
end

function Window:bindToggleKey()
	table.insert(self.connections, userInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.toggleKey then
			self:Toggle()
		end
	end))
end

function Window:SetToggleKey(keyCode)
	self.toggleKey = keyCode
end

--==============================================================
-- Configs
--==============================================================

function Window:SaveConfig(name)
	if typeof(writefile) ~= "function" then
		return false, "writefile unavailable"
	end

	local data = {}
	for flag, control in pairs(self.flags) do
		if control.value ~= nil then
			data[flag] = Util.encode(control.value)
		end
	end

	if typeof(isfolder) == "function" and not isfolder(CONFIG_FOLDER) then
		makefolder(CONFIG_FOLDER)
	end
	writefile(CONFIG_FOLDER .. "/" .. name .. ".json", httpService:JSONEncode(data))
	return true
end

function Window:LoadConfig(name)
	local path = CONFIG_FOLDER .. "/" .. name .. ".json"
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile(path) then
		return false, "config not found"
	end

	local ok, data = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)
	if not ok or type(data) ~= "table" then
		return false, "config is corrupted"
	end

	for flag, value in pairs(data) do
		local control = self.flags[flag]
		if control and control.Set then
			control:Set(Util.decode(value))
		end
	end
	return true
end

function Window:ListConfigs()
	local names = {}
	if typeof(listfiles) ~= "function" or typeof(isfolder) ~= "function" or not isfolder(CONFIG_FOLDER) then
		return names
	end
	for _, path in ipairs(listfiles(CONFIG_FOLDER)) do
		local name = string.match(path, "([^/\\]+)%.json$")
		if name then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end

function Window:Destroy()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	if self.snow then
		self.snow:destroy()
	end

	Util.tween(self.scale, Motion.quick, { Scale = self.targetScale * 0.9 })
	Util.tween(self.shadow, Motion.quick, { ImageTransparency = 1 })
	task.delay(0.16, function()
		self.gui:Destroy()
	end)

	for index, window in ipairs(Library.windows) do
		if window == self then
			table.remove(Library.windows, index)
			break
		end
	end
end

--==============================================================
-- Public API
--==============================================================

local NotifyTypes = {
	Info = { icon = "info", color = Theme.accent, soft = Theme.accentSoft },
	Success = { icon = "check-circle", color = Theme.success, soft = Theme.successSoft },
	Warning = { icon = "alert-triangle", color = Theme.warning, soft = Theme.warningSoft },
	Error = { icon = "x-circle", color = Theme.danger, soft = Theme.dangerSoft },
}

function Library:CreateWindow(options)
	return Window.new(options or {})
end

function Library:GetIcon(name)
	return Util.icon(name)
end

-- Notifications sit on their own gui so they outlive any window.
function Library:Notify(options)
	options = options or {}
	local style = NotifyTypes[options.Type or "Info"] or NotifyTypes.Info

	if not self.notifications then
		local gui = Util.new("ScreenGui", {
			Name = "MoonHubNotifications",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 10000,
		})
		Util.parentGui(gui)

		self.notifications = Util.new("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -18, 1, -18),
			Size = UDim2.fromOffset(300, 500),
			BackgroundTransparency = 1,
			Parent = gui,
		})
		local layout = Util.list(self.notifications, 16)
		layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

		-- Smaller on phones so a card never covers half the screen.
		local notifyScale = Util.new("UIScale", { Parent = self.notifications })
		local camera = workspace.CurrentCamera
		local function fit()
			local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
			notifyScale.Scale = math.clamp(math.min(viewport.X / 1100, viewport.Y / 700), 0.65, 1.1)
		end
		fit()
		if camera then
			camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
		end
	end

	-- Height is measured up front so nothing depends on AutomaticSize.
	local content = options.Content or options.Text or ""
	local textWidth = 300 - 58 - 38
	local contentHeight = content ~= "" and textService:GetTextSize(
		content,
		12,
		Enum.Font.Gotham,
		Vector2.new(textWidth, 1000)
	).Y or 0
	local cardHeight = math.max(14 + 16 + (content ~= "" and 4 + contentHeight or 0) + 20, 62)

	-- The slot is what the layout moves; the mover slides inside it with its shadow.
	local slot = Util.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, cardHeight),
		Parent = self.notifications,
	})

	local mover = Util.new("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(340, 0),
		Size = UDim2.fromScale(1, 1),
		Parent = slot,
	})
	Decor.shadow(mover, 0.82, 34)

	local card = Util.new("Frame", {
		BackgroundColor3 = Theme.surface,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1,
		Parent = mover,
	})
	Util.corner(card, 12)
	Util.stroke(card, Theme.stroke)

	local tile = Util.new("Frame", {
		Position = UDim2.fromOffset(14, 13),
		Size = UDim2.fromOffset(32, 32),
		BackgroundColor3 = style.soft,
		Parent = card,
	})
	Util.corner(tile, 9)
	Util.image(tile, options.Icon or style.icon, 16, style.color, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	})

	Util.new("TextLabel", {
		Position = UDim2.fromOffset(58, 14),
		Size = UDim2.new(1, -96, 0, 16),
		Text = options.Title or "Moon Hub",
		FontFace = Fonts.bold,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = card,
	})

	Util.new("TextLabel", {
		Position = UDim2.fromOffset(58, 34),
		Size = UDim2.new(0, textWidth, 0, contentHeight),
		Text = content,
		TextColor3 = Theme.subText,
		TextSize = 12,
		FontFace = Fonts.regular,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = card,
	})

	local closeButton = Util.new("ImageButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.fromOffset(14, 14),
		Image = Util.icon("x") or "",
		ImageColor3 = Theme.mutedText,
		Parent = card,
	})

	local bar = Util.new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 14, 1, -7),
		Size = UDim2.new(1, -28, 0, 3),
		BackgroundColor3 = style.color,
		Parent = card,
	})
	Util.corner(bar, 2)

	local duration = options.Duration or 5
	local closed = false

	local function close()
		if closed then
			return
		end
		closed = true
		Util.tween(mover, Motion.smooth, { Position = UDim2.fromOffset(340, 0) })
		task.wait(0.3)
		slot:Destroy()
	end

	closeButton.MouseButton1Click:Connect(function()
		task.spawn(close)
	end)

	closeButton.MouseEnter:Connect(function()
		Util.tween(closeButton, Motion.quick, { ImageColor3 = Theme.danger })
	end)
	closeButton.MouseLeave:Connect(function()
		Util.tween(closeButton, Motion.quick, { ImageColor3 = Theme.mutedText })
	end)

	Util.tween(mover, Motion.spring, { Position = UDim2.fromOffset(0, 0) })
	Util.tween(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) })
	task.delay(duration, close)
end

function Library:Destroy()
	for index = #self.windows, 1, -1 do
		self.windows[index]:Destroy()
	end
	if self.notifications then
		self.notifications.Parent:Destroy()
		self.notifications = nil
	end
end

--==============================================================
-- Showcase
--==============================================================

function Library:Demo()
	local window = self:CreateWindow({
		Title = "Moon Hub",
		SubTitle = "Blox Fruits",
		ToggleKey = Enum.KeyCode.RightShift,
	})

	-- Home.
	local home = window:AddTab({ Name = "Home", Icon = "home", Description = "Welcome to Moon Hub" })

	home:AddParagraph({
		Title = "Welcome back, " .. localPlayer.DisplayName,
		Content = "This window shows every element the library offers. Use the search box at the top to filter the open tab.",
		Icon = "snowflake",
	})

	home:AddSection("Quick Actions")

	home:AddButton({
		Name = "Info Notification",
		Description = "Default style, ice blue",
		Icon = "info",
		Callback = function()
			self:Notify({ Title = "Info", Content = "Something worth knowing happened.", Type = "Info" })
		end,
	})

	home:AddButton({
		Name = "Success Notification",
		Icon = "check-circle",
		Callback = function()
			self:Notify({ Title = "Success", Content = "Everything went fine.", Type = "Success" })
		end,
	})

	home:AddButton({
		Name = "Warning Notification",
		Icon = "alert-triangle",
		Callback = function()
			self:Notify({ Title = "Warning", Content = "Careful with that setting.", Type = "Warning" })
		end,
	})

	home:AddButton({
		Name = "Error Notification",
		Icon = "x-circle",
		Callback = function()
			self:Notify({ Title = "Error", Content = "Something failed, check the console.", Type = "Error" })
		end,
	})

	-- Farm.
	local farm = window:AddTab({ Name = "Auto Farm", Icon = "swords", Description = "Levels, mastery and materials" })
	farm:AddSection("Main")

	local status = farm:AddLabel("Status: idle")

	farm:AddToggle({
		Name = "Auto Farm Level",
		Description = "Takes quests and farms the best mob for your level",
		Icon = "trending-up",
		Flag = "autoFarm",
		Callback = function(state)
			status:Set(state and "Status: farming..." or "Status: idle")
		end,
	})

	farm:AddToggle({ Name = "Auto Quest", Icon = "scroll", Default = true, Flag = "autoQuest" })
	farm:AddToggle({ Name = "Bring Mobs", Icon = "magnet", Flag = "bringMobs" })

	farm:AddDropdown({
		Name = "Farm Mode",
		Icon = "layers",
		Options = { "Level", "Mastery", "Bones", "Fragments" },
		Default = "Level",
		Flag = "farmMode",
	})

	farm:AddDropdown({
		Name = "Weapon",
		Description = "Long lists get a search box",
		Icon = "sword",
		Options = { "Melee", "Sword", "Gun", "Blox Fruit", "Godhuman", "Cursed Dual Katana", "Soul Guitar", "Dragon Trident" },
		Default = "Melee",
		Flag = "weapon",
	})

	farm:AddSection("Tuning")

	farm:AddSlider({
		Name = "Farm Distance",
		Icon = "move-vertical",
		Min = 0,
		Max = 60,
		Default = 25,
		Suffix = "m",
		Flag = "farmDistance",
	})

	farm:AddSlider({
		Name = "Attack Delay",
		Description = "Seconds between hits, two decimals",
		Icon = "timer",
		Min = 0,
		Max = 2,
		Default = 0.15,
		Decimals = 2,
		Suffix = "s",
		Flag = "attackDelay",
	})

	-- Fruits.
	local fruits = window:AddTab({ Name = "Fruits", Icon = "apple", Description = "Sniping and storage" })
	fruits:AddSection("Storage")

	fruits:AddDropdown({
		Name = "Auto Store",
		Description = "Multi select",
		Icon = "package",
		Options = { "Dough", "Leopard", "Kitsune", "Dragon", "Venom", "Shadow", "Portal", "Buddha" },
		Multi = true,
		Flag = "storeFruits",
	})

	fruits:AddToggle({ Name = "Fruit Notifier", Icon = "bell", Default = true, Flag = "fruitNotifier" })
	fruits:AddToggle({ Name = "Teleport To Fruit", Icon = "map-pin", Flag = "fruitTeleport" })

	-- Visuals.
	local visuals = window:AddTab({ Name = "Visuals", Icon = "eye", Description = "ESP and world" })
	visuals:AddSection("ESP")

	visuals:AddToggle({ Name = "Player ESP", Icon = "user", Flag = "playerEsp" })
	visuals:AddToggle({ Name = "Fruit ESP", Icon = "apple", Default = true, Flag = "fruitEsp" })
	visuals:AddToggle({ Name = "Chest ESP", Icon = "box", Flag = "chestEsp" })

	visuals:AddColorPicker({
		Name = "ESP Color",
		Description = "Click to open the picker",
		Icon = "palette",
		Default = Theme.accent,
		Flag = "espColor",
	})

	visuals:AddSection("World")

	visuals:AddSlider({
		Name = "Field of View",
		Icon = "scan",
		Min = 40,
		Max = 120,
		Default = 70,
		Flag = "fov",
		Callback = function(value)
			if workspace.CurrentCamera then
				workspace.CurrentCamera.FieldOfView = value
			end
		end,
	})

	-- Player.
	local player = window:AddTab({ Name = "Player", Icon = "user", Description = "Movement and teleports" })
	player:AddSection("Movement")

	player:AddSlider({ Name = "Walk Speed", Icon = "gauge", Min = 16, Max = 300, Default = 16, Flag = "walkSpeed" })
	player:AddSlider({ Name = "Jump Power", Icon = "arrow-up", Min = 50, Max = 400, Default = 50, Flag = "jumpPower" })
	player:AddToggle({ Name = "Infinite Jump", Icon = "chevrons-up", Flag = "infJump" })
	player:AddToggle({ Name = "No Clip", Icon = "ghost", Flag = "noClip" })

	player:AddSection("Teleport")

	player:AddInput({
		Name = "Target Player",
		Icon = "at-sign",
		Placeholder = "username",
		Flag = "targetPlayer",
	})

	player:AddInput({
		Name = "Island",
		Description = "Fires only when you press Enter",
		Icon = "compass",
		Placeholder = "island name",
		OnlyOnEnter = true,
		Flag = "island",
		Callback = function(text)
			self:Notify({ Title = "Teleport", Content = "Going to " .. text, Type = "Success" })
		end,
	})

	player:AddDivider()

	player:AddKeybind({
		Name = "Panic Key",
		Description = "Click, then press a key. Backspace clears",
		Icon = "keyboard",
		Default = Enum.KeyCode.P,
		Flag = "panicKey",
		Callback = function()
			self:Notify({ Title = "Panic", Content = "Everything disabled.", Type = "Warning" })
		end,
	})

	-- Settings.
	local settings = window:AddTab({ Name = "Settings", Icon = "settings", Description = "Interface and configs" })
	settings:AddSection("Interface")

	settings:AddKeybind({
		Name = "Toggle UI",
		Icon = "monitor",
		Default = Enum.KeyCode.RightShift,
		ChangedCallback = function(keyCode)
			if keyCode then
				window:SetToggleKey(keyCode)
			end
		end,
	})

	settings:AddToggle({
		Name = "Open/Close Button",
		Description = "Floating pill at the top of the screen",
		Icon = "mouse-pointer-click",
		Default = true,
		Callback = function(state)
			window:SetToggleButtonVisible(state)
		end,
	})

	settings:AddButton({
		Name = "Minimize Window",
		Icon = "minimize-2",
		Callback = function()
			window:SetMinimized(not window.minimized)
		end,
	})

	settings:AddSection("Configs")

	local configName = settings:AddInput({
		Name = "Config Name",
		Icon = "file-text",
		Placeholder = "default",
		Default = "default",
	})

	local configList = settings:AddDropdown({
		Name = "Saved Configs",
		Icon = "folder",
		Options = window:ListConfigs(),
	})

	settings:AddButton({
		Name = "Save Config",
		Icon = "save",
		Callback = function()
			local name = configName.value ~= "" and configName.value or "default"
			local ok, err = window:SaveConfig(name)
			configList:Refresh(window:ListConfigs())
			self:Notify({
				Title = "Configs",
				Content = ok and ("Saved '" .. name .. "'") or tostring(err),
				Type = ok and "Success" or "Error",
			})
		end,
	})

	settings:AddButton({
		Name = "Load Config",
		Icon = "download",
		Callback = function()
			local name = configList.value or configName.value
			local ok, err = window:LoadConfig(name)
			self:Notify({
				Title = "Configs",
				Content = ok and ("Loaded '" .. name .. "'") or tostring(err),
				Type = ok and "Success" or "Error",
			})
		end,
	})

	settings:AddSection("Danger Zone")

	settings:AddButton({
		Name = "Unload Moon Hub",
		Description = "Closes the window and every notification",
		Icon = "power",
		Callback = function()
			self:Destroy()
		end,
	})

	self:Notify({ Title = "Moon Hub", Content = "Loaded. Press RightShift to hide.", Type = "Success" })
	return window
end

-- Running the file on its own opens the showcase. To use it only as a library,
-- set getgenv().MoonHubDemo = false before loading it.
if not (typeof(getgenv) == "function" and getgenv().MoonHubDemo == false) then
	Library.demoWindow = Library:Demo()
end

return Library
