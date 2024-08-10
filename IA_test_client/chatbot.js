

function extractResponse(result) {
    // Extraire la réponse de la variable Reponse du résultat Prolog
    const match = result.match(/Reponse = \[([^\]]+)\]/);
    if (match) {
        return match[1].replace(/'/g, "").split(", ").join(" ");
    } else {
        return "Je n'ai pas compris la réponse.";
    }
  }
  
function displayResponse(responseText) {
    // Afficher la réponse dans un élément HTML avec l'ID 'response'
    document.getElementById('response').innerText = responseText.reponse;
  }
  
  // Ajout du gestionnaire d'événements pour le bouton
document.getElementById('submit_button_bot').addEventListener('click', function () {
    const userQuestion = document.getElementById('input').value;
    chatbot(userQuestion);
  });
  
  
function splitStringIntoWords(sentence) {
    // Split the sentence by spaces and filter out any empty strings
    return sentence.split(' ').filter(word => word.length > 0);
  }
  
function removeCommas(str) {
    return str.replace(/,/g, '');
  }
  
  // Exemple d'utilisation
let originalString = "Bonjour, comment ça va, aujourd'hui?";
let stringSansVirgules = removeCommas(originalString);
  console.log(stringSansVirgules); 