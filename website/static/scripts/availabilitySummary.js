var timeline;
var trainerColors = {"New":"#fce5cf", "Team Lead":"#eafccc","Basic Trainer":"#d9e8ff"};
document.addEventListener("DOMContentLoaded", function () {
  console.log("alreadyAssigned: ");
  console.log(alreadyAssigned);
  var groups = new vis.DataSet();
  trainers.forEach(function(trainer) {
    let checkContainer= document.createElement("div");
    if(addCheckboxes){
      checkContainer = appendCheckboxes(trainer,checkContainer);
    }
    checkContainer.appendChild(document.createTextNode(trainer.nickname));
    if(alreadyAssigned["" + trainer.id]){
      var exclamation = document.createElement("div");
      exclamation.className = "warningIcon";
      exclamation.title = "This trainer is already assigned to " + alreadyAssigned["" + trainer.id] + " on this day.";
      exclamation.setAttribute("trainer", trainer.id);
      checkContainer.appendChild(exclamation);
    }

    groups.add({
      id: trainer.id,
      content: checkContainer, 
      style: "color: black; background-color: " + trainerColors[trainer.status] + ";"
    });
  });
  unavailables.forEach(function(trainer) {
    let checkContainer = document.createElement("div");
    if(addCheckboxes){
      checkContainer = appendCheckboxes(trainer,checkContainer);
    }
    checkContainer.appendChild(document.createTextNode(trainer.nickname));
    groups.add({
      id: trainer.id,
      content: checkContainer, 
      style: "color: black; background-color: " + trainerColors[trainer.status] + ";"
    });
  });

  // create items
  var items = new vis.DataSet();

  availability.forEach(function(entry){
    var start = new Date(entry.iso_formatted_start_date)
    var end = new Date(entry.iso_formatted_end_date)

    items.add({
        id: entry.id,
        group: entry.trainer_id,
        start: start,
        end: end,
        content: "" + entry.formatted_start_time + " - " + entry.formatted_end_time,
      });
  })

  //add event time frame
  if(eventStart !== "no" && eventEnd !== "no"){
    items.add({id: 'eventTime', start: eventStart, end: eventEnd, type: 'background',style:"background-color: rgba(255, 0, 0, 0.1);"})
  }

  // specify options
  var options = {
    width: '100%',
    margin: { axis: 5    },
    stack: true,
    verticalScroll: true,
    moveable: false,
    autoResize: true,
    zoomKey: "ctrlKey",
    start: day_start,
    end: day_end,
    editable: false,
    orientation: "top",
    format: {
        minorLabels: {
            hour:       'hA',
          },
        majorLabels: {
            hour:       'dddd'
          }
    },
    timeAxis: {scale: 'hour', step: 1}
  };
  // create a Timeline
  var container = document.getElementById("visualization");
  timeline = new vis.Timeline(container, items, groups, options);
});

function appendCheckboxes(trainer,contentDiv){
    let checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.className = "trainer-checkbox";
    checkbox.name = "check";
    checkbox.setAttribute("trainer", trainer.id);
    checkbox.value = trainer.nickname + " (ID: " + trainer.id + ")";
    checkbox.onchange=function(){
      copySelectedTrainers(checkbox,"" + trainer.id);
    }

    contentDiv.appendChild(checkbox);
    if (trainer.status == "Team Lead"){
      var radio = document.createElement("input");
      radio.title = "Select as team lead";
      radio.className = "starradio";
      radio.type = "radio";
      radio.name = "stars";
      radio.setAttribute("trainer",trainer.id);
      radio.value = trainer.nickname + " (ID: " + trainer.id + ")";
      radio.style.width = "15px";
      radio.style.height = "15px";
      radio.style.padding = "0px";
      radio.style.margin = "0px";
      radio.onchange = function(){
        radioFunc(this);
      }
      contentDiv.appendChild(radio);
    }
    return contentDiv;
}