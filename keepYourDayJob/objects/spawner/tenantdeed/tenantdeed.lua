require "/objects/spawner/colonydeed/colonydeed.lua"

local oldInit = init
function init()
	storage = config.getParameter("scriptStorage")
	oldInit()
end
