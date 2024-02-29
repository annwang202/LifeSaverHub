function numberSlots(container){
  var slotNum = 2;
  const slotLabels = container.querySelectorAll(".slot-label");
  slotLabels.forEach(function(label){
    label.textContent = "Trainer " + slotNum++;
  })
}

function deleteTrainerSlot(button,search_class) {
  var slot = button.closest(search_class);
  slot.parentNode.removeChild(slot);
}
function addTrainerSlot(search_class,container) {
  const slotsContainer = document.getElementById(container);
  const slotEntry = document.querySelector(search_class).cloneNode(true);

  const input = slotEntry.querySelector('input[type="text"]');
  input.value = "";
  //add delete-slot button
  const deleteButton = document.createElement("button");
  deleteButton.type = "button";
  deleteButton.className = "delete-slot";
  deleteButton.textContent = "X";
  deleteButton.addEventListener("click", function () {
    deleteTrainerSlot(this,search_class);
    numberSlots(slotsContainer);
  });
  // Append the button to the slot
  slotEntry.appendChild(deleteButton);

  slotsContainer.appendChild(slotEntry);
    $.getJSON(`/trainerdata`, function (data) {
      let trainer_names = data
        .filter((person) => person.status !== "Suspended")
        .map((person) => `${person.name} (ID: ${person.id})`);
      let leader_names = data
      .filter((person) => person.status === "Team Lead")
      .map((person) => `${person.name} (ID: ${person.id})`);
      autocomplete(document.querySelectorAll(".trainerInput"), trainer_names);
      autocomplete(document.querySelectorAll(".leaderInput"), leader_names);
  });
  return input;
}
function openTab(evt, tabId) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(tabId).style.display = "block";
  evt.currentTarget.className += " active";
}
function showEditModalfunction({
  eventId,
  title,
  learners,
  startDate,
  endDate,
  formatted_start_date,
  formatted_end_time,
  eventStatus,
  adminNotes,
  leader,
  trainers,
} = {}) {
  var modal = $("#update-assignment");
  modal.find(".modal-title").text(title);
  modal.find(".time").text(`${formatted_start_date} - ${formatted_end_time}`);
  modal.find(".numLearners").text(`${learners}`);
  modal.find(".targetTrainers").text(`${Math.ceil(learners/4)}`)
  var borderColor = "grey";
  var currStatus = document.querySelector("#current-status");
  currStatus.value = eventStatus;
  currStatus.textContent = eventStatus;
  var currAdminNote = document.querySelector("#admin_notes_input")
  currAdminNote.value = adminNotes;
  currAdminNote.textContent = adminNotes;

  modal.find(".modal-content").css("border-color", borderColor);
  $("#update-assignment-event-id").val(eventId);
  $("#update-assignment-start-date").val(startDate);
  $("#update-assignment-end-date").val(endDate);
  $("#update-assignment-formatted-start-date").val(formatted_start_date);
  $("#update-assignment-formatted-end-time").val(formatted_end_time);
  //delete all previously copied slots
  const trainerSlotsContainer = document.getElementById("update-trainer-slots");
  const currentSlots =
    trainerSlotsContainer.querySelectorAll(".update.trainer-search");
  // Remove all but the first slot
  for (let i = 1; i < currentSlots.length; i++) {
    trainerSlotsContainer.removeChild(currentSlots[i]);
  }
  //copy the correct number of slots
  for (let j = 1; j < trainers.length; j++) {
    addTrainerSlot(".update.trainer-search","update-trainer-slots");
  }
  numberSlots(trainerSlotsContainer);
  const newSlots = trainerSlotsContainer.querySelectorAll(".update.trainer-search");
  for (index = 0; index < newSlots.length; index++) {
    let slot = newSlots[index];
    let input = slot.querySelector('input[type="text"]');
    input.value = trainers[index];
  }
  const leadSlot = trainerSlotsContainer.querySelector(".update.leader-search");
  let leadInput = leadSlot.querySelector('input[type="text"]');
  leadInput.value = leader;

  modal.modal();
}

function initializeAdvancedSearch(iframeDocument,modal){
    var modal1 = modal;
    var modal2 = $("#modal2");
    const openAdvancedSearch = modal1.querySelector('a[name="open-advanced-search"]');
    openAdvancedSearch.addEventListener("click", function () {
      //get date and time from og modal
      var startDateInput = modal1.querySelector('input[name="start-date"]').value;
      var endDateInput = modal1.querySelector('input[name="end-date"]').value;
      //parse the values into date objects
      var parsedStart = new Date(startDateInput);
      var parsedEnd = new Date(endDateInput);
      var startDate = parsedStart.toISOString().split('T')[0];
      var endDate = parsedEnd.toISOString().split('T')[0];
      const startHours = parsedStart.getHours();
      const startMinutes = String(parsedStart.getMinutes()).padStart(2, '0');
      const startTime = `${startHours}:${startMinutes}`;
      const endHours = parsedEnd.getHours();
      const endMinutes = String(parsedEnd.getMinutes()).padStart(2, '0');
      const endTime = `${endHours}:${endMinutes}`;

      //clear selected trainers
      var checkboxesAndRadios = iframeDocument.querySelectorAll('.trainer-checkbox, .starradio');
      checkboxesAndRadios.forEach(function (box) {
          box.checked = false;
      });

      //pre-select trainers that are already named in slots
      var lead = modal1.querySelector('input[name="leader-slot"]').value;
      var regex = /ID: (\d+)/;
      var leadMatch = lead.match(regex);
      if(leadMatch){
        var leadId = leadMatch[1];
        var input = iframeDocument.querySelector('input[name="stars"][trainer="' + leadId + '"]')
        input.checked = true;
      } 
      else {
        console.log(lead);
        console.log("No match found");
      }

      var trainers = modal1.querySelectorAll('input[name="trainer-slot[]"]');
      trainers.forEach(function(trainer){
        let trainerMatch = trainer.value.match(regex);
        if(trainerMatch){
          var trainerId = trainerMatch[1];
          iframeDocument.querySelector('input[name="check"][trainer="' + trainerId + '"]').checked = true;
        } 
        else {
          console.log("No match found");
        }
      })

      //get inputs from advancedSearch.html
      var dateFilter = iframeDocument.querySelector('input[name="date"]');
      var startFilter = iframeDocument.querySelector('input[name="start_time"]');
      var endFilter = iframeDocument.querySelector('input[name="end_time"]');

      //copy date and times over
      dateFilter.value = startDate;
      startFilter.value = startTime;
      endFilter.value=endTime;

      var filterButton = iframeDocument.querySelector('button[id="filterButton"]');
      filterButton.click();
      //open model
      modal2.modal();
    });
    const select = document.getElementById("selectBtn");
    select.addEventListener("click", function () {
      //copy over leader
      var selectedRadio = iframeDocument.querySelector('input.starradio:checked');
      if (selectedRadio){
        var leaderSlot = modal1.querySelector(".leaderInput");
        leaderSlot.value = selectedRadio.value;
      }
      //copy over trainers
      var checkedCheckboxes = iframeDocument.querySelectorAll(
          ".trainer-checkbox:checked"
        );
        var slots = modal1.querySelectorAll(".trainerInput");
        var slotContainer = modal1.querySelector(".trainer-slots");

        let j = 0; //slots counter
      for (let index = 0; index < checkedCheckboxes.length; index++) {
        if(checkedCheckboxes[index].disabled){
          continue;
        }
        if(slots.length > index){
          slots[j++].value = checkedCheckboxes[index].value;
        }
        else{
          const classSelector = "." + Array.from(modal1.querySelector(".trainer-search").classList).join(".");
          addTrainerSlot(classSelector,slotContainer.id);
          numberSlots(slotContainer);
          slots = modal1.querySelectorAll(".trainerInput");
          slots[j++].value = checkedCheckboxes[index].value;
        }
      }
      modal2.modal('toggle');
    });
  }

document.addEventListener("DOMContentLoaded", function () {
  function fetchDataAndInitializeCalendar() {
    return new Promise(function (resolve) {
      var createModal = document.getElementById("detail-expand");
      var updateModal = document.getElementById("update-assignment");
      var iframe = document.getElementById("advancedSearch");
      var iframeDocument;
      iframe.onload = function(){
        iframeDocument = iframe.contentDocument || iframe.contentWindow.document;
        initializeAdvancedSearch(iframeDocument,createModal);
        initializeAdvancedSearch(iframeDocument,updateModal);
      }
      var calendarEl = document.getElementById("calendar");
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        navLinks: true,
        fixedWeekCount: true,
        headerToolbar: {
          left: "prev,next",
          center: "title",
          right: "timeGridDay,dayGridMonth,timeGridWeek,multiMonthYear", // user can switch between the two
        },
        eventClick: function (info) {
          var event = info.event;
          if(!info.event.extendedProps.trainerTrue){
            var modal = $("#detail-expand");
            modal.find(".modal-title").text(event.title);
            modal.find(".description").text(event.extendedProps.description);
            modal
              .find(".time")
              .text(
                `${event.extendedProps.formattedStartDate} - ${event.extendedProps.formattedEndTime}`
              );
              modal.find(".numLearners").text(`${event.extendedProps.numLearners}`);
              modal.find(".targetTrainers").text(`${Math.ceil(event.extendedProps.numLearners/4)}`)
            var borderColor = event.borderColor
              ? event.borderColor
              : event.backgroundColor;
            modal.find(".modal-content").css("border-color", borderColor);
            $("#assignment-event-id").val(event.extendedProps.eventId);
            $("#assignment-start-date").val(event.startStr);
            $("#assignment-end-date").val(event.endStr);
            $("#assignment-formatted-start-date").val(
              event.extendedProps.formattedStartDate
            );
            $("#assignment-formatted-end-time").val(
              event.extendedProps.formattedEndTime
            );
            //copy request time into assigned time inputs fields
            var startTimeInput = modal.find('input[name="start_time"]').get(0);
            var endTimeInput = modal.find('input[name="end_time"]').get(0);
            //parse the values into date objects
            var parsedStart = new Date(event.start);
            console.log("parsedStart: " + parsedStart);
            var parsedEnd = new Date(event.end);
            const startHours = parsedStart.getHours();
            const startMinutes = String(parsedStart.getMinutes()).padStart(2, '0');
            const startTime = `${startHours}:${startMinutes}`;
            const endHours = parsedEnd.getHours();
            const endMinutes = String(parsedEnd.getMinutes()).padStart(2, '0');
            const endTime = `${endHours}:${endMinutes}`;
            startTimeInput.value = startTime;
            endTimeInput.value = endTime;
  
            //delete all previously copied slots
            const trainerSlotsContainer =
              document.getElementById("trainer-slots");
            const currentSlots =
              trainerSlotsContainer.querySelectorAll(".trainer-search");
            // Remove all but the first slot
            for (let i = 1; i < currentSlots.length; i++) {
              trainerSlotsContainer.removeChild(currentSlots[i]);
            }
            //clear slots
            var inputElements = document.querySelectorAll(".trainerInput, .leaderInput");
            inputElements.forEach(function(input) {
                input.value = "";
            });
            //copy the correct number of slots
            var defaultSlots = Math.ceil(event.extendedProps.numLearners / 4);
            var numSlots = defaultSlots < 8 ? defaultSlots : 8;
            for (var i = 2; i < numSlots; i++) {
              addTrainerSlot(".trainer-search","trainer-slots");
            }
            numberSlots(trainerSlotsContainer);
            //uncheck advanced search trainers
            const checkboxes = iframeDocument.querySelectorAll(
              ".trainer-checkbox"
            );
            checkboxes.forEach((checkbox) => {
              checkbox.checked = false;
            });
            //get availabilitySummary
            const weekdays = [
              "sunday",
              "monday",
              "tuesday",
              "wednesday",
              "thursday",
              "friday",
              "saturday",
            ];
            var availabilitySummaryIframe = document.getElementById("availabilitySummaryIframe");
            availabilitySummaryIframe.src = "/availabilitySummary/" + weekdays[parsedStart.getDay()];
            var asDocument;
            availabilitySummaryIframe.onload = function(){
              asDocument = availabilitySummaryIframe.contentWindow;
              asDocument.loadTimeBars(event.startStr,event.endStr);
            }

            modal.modal();
          }
        },
      });
      resolve({ calendar });
    });
  }

  fetchDataAndInitializeCalendar().then(({ calendar }) => {
    function updateEventSources() {
      $.getJSON(`/eventdata`, function (data) {
        // Retrieve checked checkboxes
        const checkedCheckboxes = document.querySelectorAll(
          ".event-checkbox:checked"
        );
        const uncheckedCheckboxes = document.querySelectorAll(
          ".event-checkbox:not(:checked)"
        );

        // Collect the event IDs associated with checked checkboxes
        const eventIds = Array.from(checkedCheckboxes).map((checkbox) =>
          checkbox.getAttribute("event-id")
        );
        const hiddenEventIds = Array.from(uncheckedCheckboxes).map((checkbox) =>
          checkbox.getAttribute("event-id")
        );

        // Remove existing event sources that should be hidden
        const removePromises = calendar.getEvents().map(function (event) {
          if (event.extendedProps.trainerTrue === false) {
            return event.remove(() => resolve());
          }
          // If the event doesn't meet the removal criteria, return a resolved promise
          return Promise.resolve();
        });

        // Add the updated event sources
        Promise.all(removePromises)
          .then(() => {
            // Add the updated event sources
            // Add eventDates associated with each event
            const addPromises = data.map((jsonsource) => {
              if (eventIds.includes(jsonsource.id.toString())) {
                const sourceArray = jsonsource;
                return calendar.addEventSource(sourceArray);
              }
              return Promise.resolve();
            });

            // Wait for all add promises to complete
            return Promise.all(addPromises);
          })
          .then(() => {
            // Finally, refetch events
            calendar.refetchEvents();
          })
          .catch((error) => {
            console.error("An error occurred:", error);
          });
      }).catch((error) => {
        console.error("An error occurred during the data fetch:", error);
      });
    }
    function updateAssignmentSources() {
      $.getJSON(`/assignmentdata`, function (data) {
        // Retrieve checked checkboxes
        const checkedCheckboxes = document.querySelectorAll(
          ".assignment-checkbox:checked"
        );
        const uncheckedCheckboxes = document.querySelectorAll(
          ".assignment-checkbox:not(:checked)"
        );

        const ids = Array.from(checkedCheckboxes).map((checkbox) =>
          checkbox.getAttribute("assignment-id")
        );
        const hiddenIds = Array.from(uncheckedCheckboxes).map(
          (checkbox) => checkbox.getAttribute("assignment-id")
        );

        const removePromises = calendar.getEvents().map(function (event) {
          if (event.extendedProps.trainerTrue === true) {
            return event.remove(() => resolve());
          }
          // If the event doesn't meet the removal criteria, return a resolved promise
          return Promise.resolve();
        });

        // Add the updated event sources
        Promise.all(removePromises).then(() => {
          // Add the updated event sources
          const addPromises = data.map((jsonsource) => {
            if (ids.includes(jsonsource.id.toString())) {
              const sourceArray = jsonsource;
              return calendar.addEventSource(sourceArray);
            }
            return Promise.resolve();
          });
          // Wait for all add promises to complete
          Promise.all(addPromises).then(() => {
            // Finally, refetch events
            calendar.refetchEvents();
          });
        }); 
      });
    }
    //add autocomplete to additional inputs
    document
      .getElementById("add-trainer-slot")
      .addEventListener("click", function() {
        addTrainerSlot(".trainer-search","trainer-slots");
        numberSlots(document.getElementById("trainer-slots"));
      });
    document
      .getElementById("update-add-trainer-slot")
      .addEventListener("click", function() {
        addTrainerSlot(".update.trainer-search","update-trainer-slots");
        numberSlots(document.getElementById("update-trainer-slots"));
      });
    // Event listener for checkbox change
    const eventCheckboxes = document.querySelectorAll(".event-checkbox");
    eventCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateEventSources);
    });
    const assignmentCheckboxes = document.querySelectorAll(".assignment-checkbox");
    assignmentCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateAssignmentSources);
    });
    //filter events
    filterEvents("#itemsToFilter li");
    calendar.id = "calendar"
    //render calendar
    calendar.render();
    //add autocomplete event listeners
    $.getJSON(`/trainerdata`, function (data) {
      let trainer_names = data
        .filter((person) => person.status !== "Suspended")
        .map((person) => `${person.name} (ID: ${person.id})`);
      let leader_names = data
      .filter((person) => person.status === "Team Lead")
      .map((person) => `${person.name} (ID: ${person.id})`);
      autocomplete(document.querySelectorAll(".trainerInput"), trainer_names);
      autocomplete(document.querySelectorAll(".leaderInput"), leader_names);
    });
  });
});
