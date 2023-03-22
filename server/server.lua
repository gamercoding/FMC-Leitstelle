-- Definieren Sie den playerSpawned-Event
AddEventHandler("playerSpawned", function()
    -- Rufen Sie den Jobrang des Spielers ab
    local jobrank = exports.jobs:getPlayerJobRank(source)

    -- Überprüfen Sie, ob der Jobrang ausreichend hoch ist (z.B. 3)
    if jobrank >= 3 then
        -- Erteilen Sie dem Spieler die Berechtigung zur Bedienung der Leitstelle
        TriggerClientEvent("leitstelle:playerAuthorized", source)
    end
end)

local function isPlayerAuthorized(player)
    local adminAce = "leitstelle.admin"
    local jobLevel = 3 -- oder 4, je nachdem, welches Joblevel zugriffsberechtigt ist

    -- Überprüfen, ob der Spieler ein Administrator ist
    if IsPlayerAceAllowed(player, adminAce) then
        return true
    end

    -- Überprüfen, ob der Spieler das erforderliche Joblevel besitzt
    local identifier = GetPlayerIdentifier(player, 0)
    local result = MySQL.Sync.fetchAll("SELECT job_grade FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1].job_grade >= jobLevel then
        return true
    end

    -- Wenn der Spieler weder Administrator noch mit dem erforderlichen Joblevel ist, ist er nicht zugriffsberechtigt
    return false
end

function showLeitstelleUI()
    local player = source

    if not isPlayerAuthorized(player) then
        return
    end

    function erledigeEinsatz(id)
        for i = 1, #laufendeEinsaetze do
          if laufendeEinsaetze[i].id == id then
            laufendeEinsaetze[i].status = 'erledigt'
            table.remove(laufendeEinsaetze, i)
            break
          end
        end
      end
      
    -- Create the HTML UI for the Leitstelle
    local leitstelleUI = [[
        <html>
            <head>
                <title>Leitstelle</title>
                <link rel="stylesheet" type="text/css" href="gui/style.css">
            </head>
            <body>
                <h1>Leitstelle</h1>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Notruf</th>
                            <th>Einsatz erstellen</th>
                            <th>Löschen</th>
                        </tr>
                    </thead>
                    <tbody id="notruf-liste">
                        <!-- Dynamically populated with JavaScript -->
                    </tbody>
                </table>
                <script src="gui/jquery.min.js"></script>
                <script src="gui/leitstelle.js"></script>
            </body>
        </html>
    ]]

    -- Create the browser and display the UI
    local browser = createBrowser(800, 600, false, false)
    loadBrowserURL(browser, "data:text/html," .. leitstelleUI)
    setElementData(player, "browser", browser)

    -- Show the cursor and disable the controls
    showCursor(player, true)
    setElementData(player, "controlDisabled", true)
end

function alarmiereGruppen(einsatz)
    local gruppen = einsatz.gruppen
    for i = 1, #gruppen do
      local job = gruppen[i]
      local spielerListe = getPlayersInJob(job)
      for j = 1, #spielerListe do
        local spieler = spielerListe[j]
        triggerClientEvent(spieler, 'alarmierung', resourceRoot, einsatz)
      end
    end
  end

  function createEinsatz(id)
    local text = getNotrufText(id)
    local einsatz = {
      id = id,
      text = text,
      gruppen = { 'polizei', 'feuerwehr', 'rettungsdienst' },
      status = 'offen'
    }
    table.insert(laufendeEinsaetze, einsatz)
    alarmiereGruppen(einsatz) -- Hier wird die Alarmierungsfunktion aufgerufen
  end
  
  function playAlarmSound()
    local sound = playSound("res/alarm1.mp3")
    setSoundVolume(sound, 0.5) -- Hier kann die Lautstärke des Alarms eingestellt werden
end

addEvent('alarmierung', true)
addEventHandler('alarmierung', root, function(einsatz)
    playAlarmSound()
end)