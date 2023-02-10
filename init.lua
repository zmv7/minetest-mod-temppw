local s  = core.get_mod_storage()
core.register_chatcommand("temppw",{
  description = "Set tempPW for player",
  params = "<playername> <password>",
  privs = {password=true},
  func = function(name,param)
	local pname, pw = param:match("(%S+) (.+)")
	if not (pname and pw) then
		return false, "Invlaid params"
	end
	local auth = core.get_auth_handler().get_auth(pname)
	if not (auth and auth.password) then
		return false, "Invalid player"
	end
	local exists = s:get(pname)
	if exists then
		return false, "TempPW is already set"
	end
	s:set_string(pname,auth.password)
	local hash = core.get_password_hash(pname,pw)
	core.set_player_password(pname, hash)
	return true, "TempPW for "..pname.." now set to "..pw
end})
core.register_chatcommand("restorepw",{
  description = "Restore original player's password",
  params = "<playername>",
  privs = {password=true},
  func = function(name,param)
	local auth = core.get_auth_handler().get_auth(param)
	if not (auth and auth.password) then
		return false, "Invalid player"
	end
	local orig_hash = s:get(param)
	if not orig_hash then
		return false, "TempPW wasn't set for "..param
	end
	core.set_player_password(param, orig_hash)
	s:set_string(param,"")
	return true, "Password of "..param.." restored"
end})
