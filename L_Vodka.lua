local effil = require('effil') -- ���������� ���������� effil ��� �������� ��������
local hook = require 'lib.samp.events'
local encoding = require('encoding') -- ���������� ���������� encoding ��� �������� ������ �� Windows-1251 � UTF-8
local u8 = encoding.UTF8
encoding.default = 'CP1251'
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local imgui = require "imgui"
local togglebut = require 'imgui_addons'
local main_window = imgui.ImBool(false)
local main_window2 = imgui.ImBool(false)
local main_window3 = imgui.ImBool(false)
local ex, ey = getScreenResolution()
local selected_rank1 = 0
local selected_rank2 = 1
local nick = ""
local PlayerID = ""
local PlayerRank = ""
local RankPrice = "5"
local KaznaMoney = "1.000.000"
local PriceVip = "1.000.000"
local BuyRang = "5"
local BuyRangTime = "1"
local Auth = false

local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������� �� �� (��� ������� ������ ���� �������� ���� � ��������)
local webhook_auth = "https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8" -- ������ ����� � ����
local webhook_invite = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ �������
local webhook_uval = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ �����
local webhook_up_rank = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ��������� �����
local webhook_down_rank = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ��������� �����
local webhook_received_bank = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ��������� ����� �� ����
local webhook_newsredak = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ���������� /newsredak
local webhook_settag = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ���������� /settag
local webhook_sell_rank = "https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8" -- ������ ������� ������
local webhook_payday = 'https://discord.com/api/webhooks/1191633147155197992/EgfmR5F4hg5uJ23WkMjP45D6Ef0rAL-KTK95RvUkr2qfBiU5CJI15fZ1KgQazjZ61-O8' -- ������ ��������� payday
local webhook_fwarn = 'https://discord.com/api/webhooks/1191632481288474624/yfCHcxdlQSVdzOqnPX9FXWHgHc-TOqYZfeWDTEGoqyjw1WZh19vOKRcUBkvFvFrgwed5' -- ������ ������ ��������
local webhook_unfwarn = 'https://discord.com/api/webhooks/1191632481288474624/yfCHcxdlQSVdzOqnPX9FXWHgHc-TOqYZfeWDTEGoqyjw1WZh19vOKRcUBkvFvFrgwed5' -- ������ ������ ��������
local webhook_fraction_balance = 'https://discord.com/api/webhooks/1191634998877503528/YzeVVCuXR5uDCxIvCkzgwForRm9Tgopa5MpMM0iGpFjz_7boTz8cq_gwCMoRNqjKt_SK' -- ������ ���������� ������� ����
local webhook_fraction_balance2 = 'https://discord.com/api/webhooks/1191634998877503528/YzeVVCuXR5uDCxIvCkzgwForRm9Tgopa5MpMM0iGpFjz_7boTz8cq_gwCMoRNqjKt_SK' -- ������ ������ ����� � ����
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

update_state = false

local script_vers = 3
local script_vers_text = "3.0"

local update_url = "https://raw.githubusercontent.com/RaccoonWhite/script/main/dslog.ini"
local update_path = getWorkingDirectory() .. "/dslog.ini"

local script_url = "https://github.com/RaccoonWhite/script/raw/main/L_Vodka.luac"
local script_path = thisScript().path

function SendWebhook(URL, DATA, callback_ok, callback_error) -- ������� �������� �������
    local function asyncHttpRequest(method, url, args, resolve, reject)
        local request_thread = effil.thread(function (method, url, args)
           local requests = require 'requests'
           local result, response = pcall(requests.request, method, url, args)
           if result then
              response.json, response.xml = nil, nil
              return true, response
           else
              return false, response
           end
        end)(method, url, args)
        if not resolve then resolve = function() end end
        if not reject then reject = function() end end
        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                           resolve(response)
                        else
                           reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        return reject(status)
                    end
                else
                    return reject(err)
                end
                wait(0)
            end
        end)
    end
    asyncHttpRequest('POST', URL, {headers = {['content-type'] = 'application/json'}, data = u8(DATA)}, callback_ok, callback_error)
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function main()
    
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

	sampAddChatMessage('{ffffff}������ "{ff0000}Logger{ffffff}" �������� � ����� � ������! | ������: 3.0 | Login: {ffff00}Vodka',-1)
	sampAddChatMessage('{002aff}Discord: {d97400}Mass Media CNN LV | Arizona RP Sun-City[20]',-1)
	
	sampRegisterChatCommand("sellr", function()
		main_window.v = not main_window.v
		imgui.Process = main_window.v
	end)
	
	sampRegisterChatCommand("kazna", function()
		main_window2.v = not main_window2.v
		imgui.Process = main_window2.v
	end)
	
	sampRegisterChatCommand("sellvip", function()
		main_window3.v = not main_window3.v
		imgui.Process = main_window3.v
	end)
	
	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage("���� ����������! ������: " .. updateIni.info.vers_text, -1)
				update_state = true
			end
			os.remove(update_path)
		end
	end)
	
	while true do
		wait(0)

		if update_state then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("������ ������� ��������!", -1)
					thisScript():reload()
				end
			end)
			break	
		end

	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function hook.onDisplayGameText(style, time, text)
	
	
	if text:find('~n~~n~~n~~n~~n~~n~~w~Welcome~n~~b~(%w+_%w+)') and not Auth then
		nick = text:match('~n~~n~~n~~n~~n~~n~~w~Welcome~n~~b~(%w+_%w+)')
		SendWebhook(webhook_auth, ([[{
            "content": null,
             "embeds": [
				{
				  "title": "���������� ��� ���� � ����",
				  "description": "**%s** � ����\n����������� �������� ������������!\n������ �������: **3.0**",
				  "color": 16776960
				}
			  ],
            "attachments": []
          }]]):format(nick))
		Auth = true
		return false
		
		
	end
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function hook.onServerMessage(_,text)
	
	if text:find("{FFFFFF}(.-) ������ ���� ����������� �������� � ��� � �����������.") then
        local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		local PlayerName = text:match("{FFFFFF}(.-) ������ ���� ����������� �������� � ��� � �����������.")
        SendWebhook(webhook_invite, ([[{
            "content": null,
             "embeds": [
				{
				  "title": "���������� ��� ������ ����������",
				  "description": "** %s ** ���������(-�) � ����������� ������ ������: **%s**",
				  "color": 16776960
				}
			],
            "attachments": []
          }]]):format(MyName, PlayerName))
	end
	
	if text:find("�� ������� (.-). �������: (.+)") then
		local PlayerName,Reason = text:match("�� ������� (.-). �������: (.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        SendWebhook(webhook_uval, ([[{
            "content": null,
             "embeds": [
				{
				  "title": "���������� ��� ���������� ����������",
				  "description": "** %s ** ������(-�) �� ����������� ������: **%s**\n�������: **%s**",
				  "color": 16776960
				}
			],
            "attachments": []
          }]]):format(MyName, PlayerName,Reason))
	end
	
	if text:find("�� ���� ������� ������ (.-) � �������� (.+)") then
		local PlayerName,Reason = text:match("�� ���� ������� ������ (.-) � �������� (.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		SendWebhook(webhook_fwarn, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ������ ��������",
			  "description": "** %s ** �����(-�) ������� ������ **%s**\n������� ������ ��������: **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName,Reason))
	end
	
	if text:find("�� ����� ������� ������ (.+)") then
		local PlayerName = text:match("�� ����� ������� ������ (.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        SendWebhook(webhook_unfwarn, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ������ ��������",
			  "description": "**%s** ����(-�) ������� ������ **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName))
	end
	
	if text:find("�� �������� ������ (.-) �� (%d+) �����") then
		local PlayerName, NewRank = text:match("�� �������� ������ (.-) �� (%d+) �����")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        SendWebhook(webhook_up_rank, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ��������� ������",
			  "description": "**%s** �������(-�) ������ **%s** �� **%s** �����",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName, NewRank))
	end
	
	if text:find("�� �������� ������ (.-) �� (%d+) �����") then
		local PlayerName, NewRank = text:match("�� �������� ������ (.-) �� (%d+) �����")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        SendWebhook(webhook_down_rank, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ��������� ������",
			  "description": "**%s** �������(-�) ������ **%s** �� **%s** �����",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName, NewRank))
	end
	
	if text:find("{9ACD32}��������������� ��������: $(.+)") then
		local Money = text:match("{9ACD32}��������������� ��������: $(.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        SendWebhook(webhook_payday, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ��������� ��",
			  "description": "**%s** ������� ���������� ����� **%s**$",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, Money))
	end

	if text:find("��� �������� ������� �� ��� ���� � ������� $(.+) �� ������ (.+)") then
		local Money, PlayerName = text:match("��� �������� ������� �� ��� ���� � ������� $(.+) �� ������ (.+)")
			SendWebhook(webhook_received_bank, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ���������� ����� �� ������ ����",
			  "description": "�� ���� �������� ������� � �����: **%s** $\n������ ������������: **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(Money, PlayerName))
		  
	end

	if text:find("�� ������ ���������� (.+) ���������� ������� � /newsredak �� ���� (.+) �����.") then
		local PlayerName, TimeNewsRedak = text:match("�� ������ ���������� (.+) ���������� ������� � /newsredak �� ���� (.+) �����.")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			SendWebhook(webhook_newsredak, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� BlockRedak",
			  "description": "**%s**\n������������ ������ � /newsredak ������: **%s**\n��: **%s** �����(�)",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName, TimeNewsRedak))
		  
	end

	if text:find("�� ����� ���������� (.+) ���������� ������� � /newsredak.") then
		local PlayerName = text:match("�� ����� ���������� (.+) ���������� ������� � /newsredak.")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			SendWebhook(webhook_newsredak, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� BlockRedak",
			  "description": "**%s**\n������������� ������ � /newsredak ������: **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName))
		  
	end

	if text:find("�� ���������� ������ (.+) ����� ���: {cccccc}(.+)") then
		local PlayerName, Tag = text:match("�� ���������� ������ (.+) ����� ���: {cccccc}(.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			SendWebhook(webhook_settag, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� SetTag",
			  "description": "**%s**\n����� ������: **%s**\n���: **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName, Tag))
		  
	end

	if text:find("�� ������� ������ (.+) ��� ���: {cccccc}(.+)") then
		local PlayerName, Tag = text:match("�� ������� ������ (.+) ��� ���: {cccccc}(.+)")
		local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			SendWebhook(webhook_settag, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� SetTag",
			  "description": "**%s**\n���� � ������: **%s**\n���: **%s**",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(MyName, PlayerName, Tag))
		  
	end
	
	if text:find("{FFFFFF}(.-) {73B461}�������� ���� ����������� �� {FFFFFF}$(.+)") then
		
		local PlayerName, Money = text:match("{FFFFFF}(.-) {73B461}�������� ���� ����������� �� {FFFFFF}$(.+)")
			SendWebhook(nil, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� ���������� �����",
			  "description": "**%s** ��������(-�) ���� ����������� �� ����� **%s** $",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(PlayerName, Money))
		  
	end

	if text:find("{ECB534}(.-) ���� � ����������� $(.+)") then
		
		local PlayerName, Money = text:match("{ECB534}(.-) ���� � ����������� $(.+)")
	    SendWebhook(nil, ([[{
            "content": null,
            "embeds": [
			{
			  "title": "���������� ��� �������� �����",
			  "description": "**%s** ����(-�) �� ����� ����������� **%s** $",
			  "color": 16776960
			}
		  ],
            "attachments": []
          }]]):format(PlayerName, Money))
		  
	end
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function imgui.OnDrawFrame()
	
	imgui_theme()
	
	local text = imgui.ImBuffer(PlayerID,256)
	local text3 = imgui.ImBuffer(KaznaMoney,256)
	local text2 = imgui.ImBuffer(RankPrice,256)
	local textvip1 = imgui.ImBuffer(BuyRang,256)
	local textvip2 = imgui.ImBuffer(BuyRangTime,256)
	local textvip3 = imgui.ImBuffer(PriceVip,256)
	
	local selected_rank1_int = imgui.ImInt(selected_rank1)
	local selected_rank2_int = imgui.ImInt(selected_rank2)
	
	if not main_window.v and not main_window2.v and not main_window3.v then
		imgui.Process = false
	end
	
	if main_window.v then
		
		imgui.SetNextWindowPos(imgui.ImVec2(ex / 2, ey / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(260, 263), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("������ ������� ������"),main_window, imgui.WindowFlags.NoCollapse)
		
		if imgui.BeginChild("1",imgui.ImVec2(250, 50),true) then
			
			
			imgui.CenterText(u8" ������� id ������")
			--(35) 
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText('',text) then
				player_id = text.v
			end
			
			if not PlayerID == nil then
				PlayerNick = sampGetPlayerNickname(PlayerID)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(PlayerNick)) 
			elseif player_id ~= nil and player_id:find('%d') and not player_id:find('%D') and string.len(player_id) >= 0 and string.len(player_id) <= 3 and sampIsPlayerConnected(player_id) then
				PlayerID = player_id
				PlayerNick = sampGetPlayerNickname(player_id)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(player_id)) 
			end
			
		end imgui.EndChild()
		
		if imgui.BeginChild("2",imgui.ImVec2(250, 55),true) then
					
			imgui.CenterText(u8" ������� ��������� ����� ")

			imgui.Text(u8" ��������� � ")
			
			imgui.SameLine()

			imgui.PushItemWidth(40) 
		
			if imgui.Combo('', selected_rank1_int, {'1', '2', '3', '4','5','6','7','8','9'}, 9) then
				selected_rank1 = selected_rank1_int.v
			end
			
			imgui.SameLine()
			
			imgui.Text(u8" �� ")
			
			imgui.SameLine()
			
			imgui.PushItemWidth(40) 
			
			if imgui.Combo(' ', selected_rank2_int, {'1', '2', '3', '4','5','6','7','8','9'}, 9) then
				selected_rank2 = selected_rank2_int.v
			end
			
			imgui.SameLine()
			
			imgui.Text(u8"����")
			
			
		end imgui.EndChild()
		
		if imgui.BeginChild("3",imgui.ImVec2(250, 80),true) then
				
			imgui.CenterText(u8" ������� ���� ������� (� ��)")
			imgui.CenterText(u8"(��� . � ,) �� ������� ����� 5��")
			
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText('',text2) then
				RankPrice = text2.v
			end
			

		end imgui.EndChild()
		
		if imgui.BeginChild("4",imgui.ImVec2(250, 30),true) then
				
			local width = imgui.GetWindowWidth()
			local calc = imgui.CalcTextSize(u8" ��������� ��� ")
			imgui.SetCursorPosX( width / 2 - calc.x / 2 )
			if imgui.Button(u8" ��������� ��� ") then
				
				
				local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
				local OldRank = selected_rank1 + 1
				local NewRank = selected_rank2 + 1
				
				local percentage = 15
				local percentage_text = "15%"
				local Profit = ((RankPrice * 1000000) * (percentage / 100)) / 1000000
				if Profit % 1 == 0 then else
				  Profit = string.format("%.1f", Profit)
				end
				
				SendWebhook(webhook_sell_rank, ([[{
					"content": null,
					"embeds": [
						{
						  "title": "����������� ������� �����",
						  "description": "**%s** ������(-�) **%s** ���� ������ **%s** �� **%s��$**.\n����� � ������ **%s** ��� **%s** ����.",
						  "color": 16776960
						}
					],
					"attachments": []
				}]]):format(MyName,NewRank,PlayerNick,RankPrice,PlayerNick,OldRank))
				
				
				sampAddChatMessage("��� ���������!",-1)
				
				main_window.v = false
				
			
				
			end
			

		end imgui.EndChild()

		imgui.End()
	
	end
	
	if main_window2.v then
		
		imgui.SetNextWindowPos(imgui.ImVec2(ex / 2, ey / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(260, 173), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("������ ����� �������"),main_window2, imgui.WindowFlags.NoCollapse)
		
		if imgui.BeginChild("1",imgui.ImVec2(250, 50),true) then
			
			
			imgui.CenterText(u8" ������� ��� ������� ������ (id ������)")
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText('',text) then
				player_id = text.v
			end
			
			if not PlayerID == nil then
				PlayerNick = sampGetPlayerNickname(PlayerID)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(PlayerNick)) 
			elseif player_id ~= nil and player_id:find('%d') and not player_id:find('%D') and string.len(player_id) >= 0 and string.len(player_id) <= 3 and sampIsPlayerConnected(player_id) then
				PlayerID = player_id
				PlayerNick = sampGetPlayerNickname(player_id)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(player_id)) 
			end
			
		end imgui.EndChild()
		
		if imgui.BeginChild("2",imgui.ImVec2(250, 50),true) then
			
			
			imgui.CenterText(u8" ������� �����")
			
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText(' ',text3) then
				KaznaMoney = text3.v
			end
			
		end imgui.EndChild()
		
		if imgui.BeginChild("3",imgui.ImVec2(250, 30),true) then
				
			local width = imgui.GetWindowWidth()
			local calc = imgui.CalcTextSize(u8" ��������� ��� ")
			imgui.SetCursorPosX( width / 2 - calc.x / 2 )
			if imgui.Button(u8" ��������� ��� ") then
				
				
				SendWebhook(webhook_fraction_balance, ([[{
					"content": null,
					 "embeds": [
						{
						  "title": "���������� ��� ���������� �����",
						  "description": "**%s** ��������(-�) ���� ����������� �� ����� **%s** $",
						  "color": 16776960
						}
					],
					"attachments": []
				  }]]):format(PlayerNick,KaznaMoney))
				
				sampAddChatMessage("��� ���������!",-1)
				
				main_window2.v = false
				
			
				
			end
			

		end imgui.EndChild()

		imgui.End()
	
	end
	
	if main_window3.v then
		
		imgui.SetNextWindowPos(imgui.ImVec2(ex / 2, ey / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(280, 320), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("������ ������� VIP �������"),main_window3, imgui.WindowFlags.NoCollapse)
		
		if imgui.BeginChild("1",imgui.ImVec2(270, 50),true) then
			
			
			imgui.CenterText(u8" ������� id ������")
			--(35) 
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText('',text) then
				player_id = text.v
			end
			
			if not PlayerID == nil then
				PlayerNick = sampGetPlayerNickname(PlayerID)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(PlayerNick)) 
			elseif player_id ~= nil and player_id:find('%d') and not player_id:find('%D') and string.len(player_id) >= 0 and string.len(player_id) <= 3 and sampIsPlayerConnected(player_id) then
				PlayerID = player_id
				PlayerNick = sampGetPlayerNickname(player_id)
				imgui.SameLine() imgui.CenterText(sampGetPlayerNickname(player_id)) 
			end
			
		end imgui.EndChild()
		
		if imgui.BeginChild("2",imgui.ImVec2(270, 50),true) then
				
			imgui.CenterText(u8" ������� ����� �����(5-8): ")
			
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText(' ',textvip1) then
				BuyRang = textvip1.v
			end
			

		end imgui.EndChild()
		
		if imgui.BeginChild("3",imgui.ImVec2(270, 70),true) then
				
			imgui.CenterText(u8" ������� ������: ")
			imgui.CenterText(u8" (1,2,3,4 ������,4 ������(��� �����)): ")
			
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText(' ',textvip2) then
				BuyRangTime = textvip2.v
			end
			

		end imgui.EndChild()
		
		if imgui.BeginChild("5",imgui.ImVec2(270, 70),true) then
				
			imgui.CenterText(u8" ������� ���������� �����: ")
			imgui.CenterText(u8" � �������: 1.000.000 ")
			
			imgui.SetCursorPosX(10)
			imgui.PushItemWidth(230)
			
			if imgui.InputText(' ',textvip3) then
				PriceVip = textvip3.v
			end
			

		end imgui.EndChild()
		
		if imgui.BeginChild("4",imgui.ImVec2(270, 30),true) then
				
			local width = imgui.GetWindowWidth()
			local calc = imgui.CalcTextSize(u8" ��������� ��� ")
			imgui.SetCursorPosX( width / 2 - calc.x / 2 )
			if imgui.Button(u8" ��������� ��� ") then
				
				
				local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
				
				SendWebhook(webhook_sell_rank, ([[{
					"content": null,
					"embeds": [
						{
						  "title": "����������� ������� VIP",
						  "description": "**%s**: ������(-�) **%s** ����.\n�� �������: **VIP ������** ������: **%s** �� **%s $**.\n��: **%s** ������(-�).",
						  "color": 16776960
						}
					],
					"attachments": []
				}]]):format(MyName,BuyRang,PlayerNick,PriceVip,BuyRangTime))
				
				
				sampAddChatMessage("��� ���������!",-1)
				
				main_window3.v = false
				
			
				
			end
			

		end imgui.EndChild()

		imgui.End()
	
	end
	
end
function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui_theme()
	imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col 
		local ImVec4 = imgui.ImVec4
		local ImVec2 = imgui.ImVec2

		style.WindowTitleAlign = ImVec2(0.5, 0.5)
		style.WindowPadding = ImVec2(6, 4)
		style.WindowRounding = 5.0
		style.FramePadding = ImVec2(4, 3)
		style.FrameRounding = 6.0
		style.ItemSpacing = ImVec2(5, 6)
		style.ItemInnerSpacing = ImVec2(1, 1)
		style.IndentSpacing = 25.0
		style.ScrollbarSize = 13.0
		style.ScrollbarRounding = 10.0
		style.GrabMinSize = 100.0
		style.GrabRounding = 3.0

		colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
		colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
		colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
		colors[clr.Button] = ImVec4(0.5, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CloseButton] = ImVec4(0.10, 0.09, 0.12, 0.60)
		colors[clr.CloseButtonHovered] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.CloseButtonActive] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.0)
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function sampGetPlayerIdByNickname(nick)
  nick = tostring(nick)
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if nick == sampGetPlayerNickname(myid) then return myid end
  for i = 0, 1003 do
    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then
      return i
    end
  end
end