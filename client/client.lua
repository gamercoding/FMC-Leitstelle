-- Zu Beginn des Scripts
local Config = exports.leitstelle:getConfig()
-- Beispiel: Zugriff auf die Position des Melders
local melderX = Config.melderPosition.x
local melderY = Config.melderPosition.y
---------------------------------------------
function getPlayerJobRank(player)
    local job = exports.jobs:getPlayerJob(player)
    if job then
      return job.rank
    else
      return 0
    end
  end
  ---------------------------------
  function openLeitstelle()
    local player = source
    local jobRank = getPlayerJobRank(player)
    if jobRank >= 3 then
      -- Hier Code, um die Leitstelle zu öffnen
    else
      TriggerClientEvent('chatMessage', player, '^1Fehler:', {255, 255, 255}, 'Sie haben nicht die erforderliche Berechtigung, um die Leitstelle zu öffnen.')
    end
  end
  -----------------------------------------------------
  RegisterServerEvent('leitstelle:open')
  AddEventHandler('leitstelle:open', openLeitstelle)

-- Definieren Sie den onClientKey-Event
AddEventHandler("onClientKey", function(key, down)
    -- Überprüfen Sie, ob der Spieler die Taste "Ä" gedrückt hat und autorisiert ist
    if down and key == 192 and isPlayerAuthorized(source) then
        -- Öffnen Sie das Leitstellen-GUI-Fenster
        TriggerClientEvent("leitstelle:openGUI", source)
    end
end)

-- Funktion zur Überprüfung, ob der Spieler autorisiert ist
function isPlayerAuthorized(playerId)
    -- Überprüfen Sie, ob der Spieler autorisiert ist (z.B. durch eine boolean-Variable)
    -- Hier können Sie auch auf Datenbanken oder andere Methoden zur Spieleridentifikation zugreifen
    return authorizedPlayers[playerId] == true
end
