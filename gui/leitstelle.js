// Elemente aus dem HTML-Dokument holen
const notrufListe = document.getElementById('notruf-liste');
const melder = document.getElementById('melder');
const melderOnOff = document.getElementById('melder-on-off');
const melderDisplay = document.getElementById('melder-display');
const melderGroup = document.getElementById('melder-group');
const melderLastEinsatz = document.getElementById('melder-last-einsatz');
const melderLastEinsatzBtn = document.getElementById('melder-last-einsatz-btn');

// Funktion zum Hinzufügen eines Notrufs zur Tabelle
function addNotruf(id, text) {
  const row = document.createElement('tr');
  row.innerHTML = `
    <td>${id}</td>
    <td>${text}</td>
    <td><button class="btn-erstellen">Einsatz erstellen</button></td>
    <td><button class="btn-loeschen">Löschen</button></td>
  `;
  notrufListe.appendChild(row);
}

// Beispielhafte Notrufe zum Testen hinzufügen
addNotruf(1, 'Brand in der Innenstadt');
addNotruf(2, 'Verkehrsunfall auf der Autobahn');

// Funktion zum Löschen eines Notrufs aus der Tabelle
function loescheNotruf(id) {
  const row = document.querySelector(`tr:nth-child(${id})`);
  if (row) {
    notrufListe.removeChild(row);
  }
}

// Funktion zum Öffnen und Schließen des Melders
function toggleMelder() {
  melder.classList.toggle('show');
}

// Funktion zum Aktivieren und Deaktivieren des Melders
function toggleMelderOnOff() {
  if (melderOnOff.checked) {
    melderDisplay.innerText = 'on';
  } else {
    melderDisplay.innerText = '';
  }
}

// Funktion zum Anzeigen der aktuellen Gruppe auf dem Melder
function setMelderGroup() {
  const jobRank = 3; // Jobrank des Spielers, muss noch dynamisch geholt werden
  let group;
  switch (jobRank) {
    case 3:
      group = 'P';
      break;
    case 4:
      group = 'F';
      break;
    case 5:
      group = 'M';
      break;
    case 6:
      group = 'T';
      break;
    default:
      group = '-';
  }
  melderGroup.innerText = group;
}

// Funktion zum Anzeigen des letzten Einsatzes auf dem Melder
function showLastEinsatz() {
  melderLastEinsatz.classList.add('show');
  setTimeout(() => {
    melderLastEinsatz.classList.remove('show');
  }, 10000);
}

// Event-Listener für Knöpfe und Eingabefelder hinzufügen
document.getElementById('btn-open').addEventListener('click', function() {
  document.getElementById('leitstelle').style.display = 'block';
});

document.getElementById('btn-close').addEventListener('click', function() {
  document.getElementById('leitstelle').style.display = 'none';
});

document.getElementById('form-neuer-notruf').addEventListener('submit', function(e) {
  e.preventDefault();
  const inputText = document.getElementById('input-text');
  if (inputText.value === '') {
    alert('Bitte geben Sie einen Text ein!');
    return;
  }
  addNotruf(notrufListe.children.length + 1, inputText.value);
  inputText.value = '';
});

notrufListe.addEventListener('click', function(e) {
  if (e.target.classList.contains('btn-erstellen')) {
    const id = e.target.parentElement.parentElement.firstChild.textContent;
    createEinsatz(id);
  } else if (e.target.classList.contains('btn-loeschen')) {
    const row = e.target.parentElement.parentElement;
    const id = row.firstChild.textContent;
    loescheNotruf(id);
    loescheEinsatz(id);
  }
});

function createEinsatz(id) {
  // Notruf-Daten aus der Tabelle auslesen
  const notrufTabelle = document.getElementById('notruf-liste');
  const notrufZeile = notrufTabelle.querySelector(`tr[data-id="${id}"]`);
  const notrufText = notrufZeile.querySelector('td:nth-child(2)').innerText;

  // Einsatz erstellen
  const einsatz = {
    id: id,
    text: notrufText,
    erledigt: false
  };

  // Einsatz der Liste hinzufügen
  einsatzListe.push(einsatz);

  // Notruf aus der Tabelle löschen
  notrufTabelle.removeChild(notrufZeile);

  // Neueinsatz an die Leitstelle senden
  sendNewEinsatzToLeitstelle(einsatz);
}

function loescheEinsatz(id)
  const einsatzListe = document.getElementById('einsatz-liste');
  const einsatz = einsatzListe.querySelector(`[data-id="${id}"]`);
  if (einsatz) {
    einsatz.remove();
  }
