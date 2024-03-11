document.addEventListener("DOMContentLoaded", function () {
  const container = document.getElementById("trainer-info-container");
  var inputs = container.querySelectorAll(
    'input[type="date"], input[type="time"]'
  );
  const trainerBoxes = document.querySelectorAll(".infoFilter li");
  var checkboxes = document.querySelectorAll(
    ".trainerFilterSection li input[type='checkbox']"
  );
  document.getElementById("clearButton").addEventListener("click", function () {
    clearInputs(inputs);
  });
  document
    .getElementById("filterButton")
    .addEventListener("click", async function () {
      var availabilityHide = await filterAvailability(container, trainerBoxes);
      getAvailabilitySummary(container);
      var statusHide = filterStatus(checkboxes);
      var unionArr = union(availabilityHide, statusHide);
      hideTrainers(trainerBoxes, unionArr);
    });

  trainerBoxes.forEach(function (box) {
    var status = box.getAttribute("data-type");
    if (status === "New") {
      box.style.borderColor = "#f5b642";
      box.querySelector(".update-status").style.color = "#ff7d03";
    } else if (status === "Team Lead") {
      box.style.borderColor = "#94b581";
      box.querySelector(".update-status").style.color = "#4c7a02";
    } else if (status === "Basic Trainer") {
      box.style.borderColor = "DodgerBlue";
      box.querySelector(".update-status").style.color = "#044dba";
    }
  });

  window.openTab = openTab;
});

function getAvailabilitySummary(container) {
  //get availabilitySummary
  const weekdays = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];
  let date = container.querySelector('input[name="date"]').value;
  let starttime = container.querySelector('input[name="start_time"]').value;
  let endtime = container.querySelector('input[name="end_time"]').value;
  var calendarViewButton= document.getElementById(
    "calendar-view-button"
  );
  var calendarViewAllButton= document.getElementById(
    "calendar-view-all-button"
  );
  if (date != "") {
    calendarViewButton.disabled = false;
    calendarViewAllButton.disabled = false;
    //valid date entered
    let weekday = weekdays[new Date(date).getDay()];
    if (starttime == "" || endtime == ""){
      starttime = "no";
      endtime = "no";
    };


    var availabilitySummaryIframe = document.getElementById(
      "availabilitySummaryIframe"
    );
    var allIframe = document.getElementById(
      "allIframe"
    );

    var addCheckboxes = "0";
    if(availabilitySummaryIframe.getAttribute("page") == "advancedSearch"){
      addCheckboxes = "1";
    }
    availabilitySummaryIframe.src = "/availabilitySummary/" + date + "/"+ starttime + "/" + endtime + "/0/" + addCheckboxes; //weekdays[parsedStart.getDay()];
    allIframe.src = "/availabilitySummary/" + date + "/"+ starttime + "/" + endtime + "/1/" + addCheckboxes; 
  }
  else{
    calendarViewButton.disabled = true;
    calendarViewAllButton.disabled = true;
  }
}

function clearInputs(inputs) {
  inputs.forEach(function (input) {
    input.value = "";
  });
}

function filterStatus(checkboxes) {
  var trainersToHide = [];
  checkboxes.forEach(function (checkbox) {
    if (!checkbox.checked) {
      var trainers = document.querySelectorAll(
        `.trainerList li[data-type="${checkbox.value}"]`
      );
      trainers.forEach(function (li) {
        trainersToHide.push(li.id);
      });
    }
  });
  return trainersToHide;
}

async function filterAvailability(container, trainerBoxes) {
  console.log("filterAvailability called");
  //return boxes to hide
  const weekdays = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];
  let date = container.querySelector('input[name="date"]').value;
  let starttime = container.querySelector('input[name="start_time"]').value;
  let endtime = container.querySelector('input[name="end_time"]').value;
  var d1 = Date.parse("20 Aug 2000 " + starttime);
  var d2 = Date.parse("20 Aug 2000 " + endtime);
  var hideIds = [];

  if (date != "") {
    getWarnings(date);
    let weekday = weekdays[new Date(date).getDay()];
    if (starttime == "" && endtime == ""){ //if time not provided, filter by day
      try {
        var data = await $.getJSON(
          `/trainer_availability/${weekday}`
        );

        var ids = data.map(function (trainer) {
          return "trainer_" + trainer["trainer_id"];
        });
        trainerBoxes.forEach(function (box) {
          if (!ids.includes(box.id)) {
            //only append trainers that were not returned by JSON call
            hideIds.push(box.id);
          }
        });
        return hideIds;
      } catch (error) {
        console.error("AJAX request failed: ", error);
        return hideIds;
      }
    }
    else if (starttime != "" && endtime != "" && d2 >= d1){
      //valid time frame entered
      try {
        var data = await $.getJSON(
          `/trainer_availability/${weekday}/${starttime}/${endtime}`
        );

        var ids = data.map(function (trainer) {
          return "trainer_" + trainer["trainer_id"];
        });
        trainerBoxes.forEach(function (box) {
          if (!ids.includes(box.id)) {
            //only append trainers that were not returned by JSON call
            hideIds.push(box.id);
          }
        });
        return hideIds;
      } catch (error) {
        console.error("AJAX request failed: ", error);
        return hideIds;
      }
    }
    else {
      if (!(date == "" && starttime == "" && endtime == "")) {
        //fields are incomplete
        alert("Please enter a valid date and time interval.");
      } //If all fields are empty, no warning needed. Just show all trainers.
    }
  }
  return hideIds;
}

function union(arr1, arr2) {
  const arr3 = [...new Set([...arr1, ...arr2])];

  return arr3;
}

function hideTrainers(listItems, hideList) {
  for (var i = 0; i < listItems.length; i++) {
    var currentItem = listItems[i];
    if (hideList.includes(currentItem.id)) {
      removeClass(currentItem, "showItem");
      addClass(currentItem, "hideItem");
    } else {
      removeClass(currentItem, "hideItem");
      addClass(currentItem, "showItem");
    }
  }
}

function openTab(evt, tabId) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  document.getElementById(tabId).style.display = "block";
  evt.currentTarget.className += " active";
}

async function getWarnings(date){
  try {
    console.log("getWarnings");
    var data = await $.getJSON(
      `/alreadyAssigned/${date}`
    );
    let keys = Object.keys(data);
    let warnings = document.querySelectorAll('div[name="warning"]');
    warnings.forEach(function(warningDiv){
      let trainerId = warningDiv.getAttribute("trainer");
      if(keys.includes(trainerId)){
        warningDiv.className = "warningIcon";
        warningDiv.title = "This trainer is already assigned to " + data["" + trainerId] + " on this day.";
      }
      else{
        warningDiv.className = "";
        warningDiv.title = "";
      }
    })
  }catch (error) {
    console.error("AJAX request failed: ", error);
    return;
  }
}