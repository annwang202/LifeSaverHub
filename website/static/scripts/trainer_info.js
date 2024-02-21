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
      var statusHide = filterStatus(checkboxes);
      console.log("Hides based on availability: " + availabilityHide);
      console.log("Hides based on status: " + statusHide);
      var unionArr = union(availabilityHide, statusHide);
      console.log("Union hides: " + unionArr);
      hideTrainers(trainerBoxes,unionArr);
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
});

function clearInputs(inputs) {
  inputs.forEach(function (input) {
    input.value = "";
  });
};

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
};

async function filterAvailability(container, trainerBoxes) {
  //return boxes to hide
  console.log("filterAvailability called");
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

  if (date != "" && starttime != "" && endtime != "" && d2 >= d1) {
    //valid date entered
    let weekday = weekdays[new Date(date).getDay()];
    console.log({ weekday }, { date }, { starttime }, { endtime });

    try {
      const data = await $.getJSON(
        `/trainer_availability/${weekday}/${starttime}/${endtime}`
      );

      console.log("AJAX request successful");
      console.log(data);
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
  } else {
    if (!(date == "" && starttime == "" && endtime == "")) {
      //fields are incomplete
      alert("Please enter a valid date and time interval.");
    } //If all fields are empty, no warning needed. Just show all trainers.
    return hideIds;
  }
};

function union(arr1, arr2) {
  const arr3 = [...new Set([...arr1, ...arr2])];

  return arr3;
};

function hideTrainers(listItems, hideList) {
  for (var i = 0; i < listItems.length; i++) {
    var currentItem = listItems[i];
    if (hideList.includes(currentItem.id)) {
      console.log("Hiding: " + currentItem.id);
      removeClass(currentItem, "showItem");
      addClass(currentItem, "hideItem");
    } else {
      removeClass(currentItem, "hideItem");
      addClass(currentItem, "showItem");
    }
  }
};
