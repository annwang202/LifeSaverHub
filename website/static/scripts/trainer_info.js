document.addEventListener("DOMContentLoaded", function () {
    // Get the current URL
  var currentURL = window.location.href;

  // Get the <a> elements inside the nav
  var navLinks = document.querySelectorAll('.nav-link');

  // Loop through each <a> element and check if its href matches the current URL
  navLinks.forEach(function(link) {
      if (link.href === currentURL) {
          link.classList.add('active'); // Add 'active' class to the current tab
      }
  });
  const container = document.getElementById("trainer-info-container");
  var inputs = container.querySelectorAll(
    'input[type="date"], input[type="time"]'
  );
  const trainerBoxes = document.querySelectorAll(".infoFilter li");
  var typeCheckboxes = document.querySelectorAll(
    ".trainerFilterSection li input[type='checkbox'][name='type']"
  );
  var statusCheckboxes = document.querySelectorAll(
    ".trainerFilterSection li input[type='checkbox'][name='status']"
  );
  var skillCheckboxes = document.querySelectorAll(
    ".trainerFilterSection li input[type='checkbox'][name='skill']"
  );
  document.getElementById("clearButton").addEventListener("click", function () {
    clearInputs(inputs);
  });
  document
    .getElementById("filterButton")
    .addEventListener("click", async function () {
      var availabilityHide = await filterAvailability(container, trainerBoxes);
      getAvailabilitySummary(container); //retrieve calendar views based on weekday and timeframe
      var typeHide = filterType(typeCheckboxes);
      var statusHide = filterStatus(statusCheckboxes);
      var skillHide = filterSkills(skillCheckboxes);
      var unionArr = union(availabilityHide, typeHide, statusHide, skillHide);
      hideTrainers(trainerBoxes, unionArr);
      var noTrainers = document.getElementById("noTrainers");
      if(unionArr.length == trainerBoxes.length){
        noTrainers.style = "display:block;";
      }
      else{
        noTrainers.style = "display:none;";
      }
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
    } else if (status === "Adult manikin" || status === "Pediatric manikin" || status === "Infant manikin"){
      box.style.borderColor = "#4c700c";
    } else if (status === "AED trainer"){
      box.style.borderColor = "#161b9e";
    } else if (status === "STB kit"){
      box.style.borderColor = "#ba1818";
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

function filterType(checkboxes) {
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

function filterStatus(checkboxes) {
  var trainersToHide = [];
  checkboxes.forEach(function (checkbox) {
    if (!checkbox.checked) {
      var trainers = document.querySelectorAll(
        `.trainerList li[status="${checkbox.value}"]`
      );
      trainers.forEach(function (li) {
        trainersToHide.push(li.id);
      });
    }
  });
  return trainersToHide;
}

function filterSkills(checkboxes) {
  var trainersToHide = [];
  checkboxes.forEach(function (checkbox) {
    if (!checkbox.checked) {
      var trainers = document.querySelectorAll(
        `.trainerList li[skill="${checkbox.value}"]`
      );
      trainers.forEach(function (li) {
        trainersToHide.push(li.getAttribute("trainer"));
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
          return trainer["id"];
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
          return trainer["id"];
        });
        console.log(ids);
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

function union(arr1, arr2, arr3,arr4) {
  const arr = [...new Set([...arr1, ...arr2, ...arr3, ...arr4])];

  return arr;
}

function hideTrainers(listItems, hideList) {
  console.log("hiding:" + hideList);
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

async function getWarnings(date){
  try {
    console.log("getWarnings");
    var data = await $.getJSON(
      `/alreadyAssigned/${date}`
    );
    let keys = Object.keys(data);
    let warnings = document.querySelectorAll('div[name="warning"]');
    warnings.forEach(function(warningDiv){
      let trainerId = warningDiv.getAttribute("warning");
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