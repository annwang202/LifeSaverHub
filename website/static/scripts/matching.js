function deleteTrainerSlot(button,search_class) {
  var slot = button.closest(search_class);
  slot.parentNode.removeChild(slot);
}
function addTrainerSlot(search_class,container) {
  console.log("addtrainerslot called");
  const slotsContainer = document.getElementById(container);
  const slotEntry = document.querySelector(search_class).cloneNode(true);
  const input = slotEntry.querySelector('input[type="text"]');
  input.value = "";
  //delete slot button
  const deleteButton = document.createElement("button");
  deleteButton.type = "button";
  deleteButton.className = "delete-slot";
  deleteButton.textContent = "X";
  deleteButton.addEventListener("click", function () {
    deleteTrainerSlot(this,search_class);
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
  modal.find(".numLearners").html(`Estimated learners: ${learners}<br>Target # of trainers: ${Math.ceil(learners/4)}`);
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
  console.log("trainers length:" + trainers.length)
  for (let j = 1; j < trainers.length; j++) {
    addTrainerSlot(".update.trainer-search","update-trainer-slots");
  }
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
      console.log("hi");
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


      console.log(startDate);
      console.log(startTime);
      console.log(endTime);

      //clear selected trainers
      var checkboxesAndRadios = iframeDocument.querySelectorAll('.trainer-checkbox, .starradio');
      checkboxesAndRadios.forEach(function (box) {
          box.checked = false;
      });

      //pre-select trainers that are already named in slots
      var lead = modal1.querySelector('input[name="leader-slot"]').value;
      console.log("Selected lead: " + lead);
      var regex = /ID: (\d+)/;
      var leadMatch = lead.match(regex);
      if(leadMatch){
        var leadId = leadMatch[1];
        console.log(leadId);
        var input = iframeDocument.querySelector('input[name="stars"][trainer="' + leadId + '"]')
        console.log("lead input: ", input);
        input.checked = true;
      } 
      else {
        console.log(lead);
        console.log("No match found");
      }

      var trainers = modal1.querySelectorAll('input[name="trainer-slot[]"]');
      trainers.forEach(function(trainer){
        console.log(trainer.value);
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
      console.log("select button clicked");
      //copy over leader
      var selectedRadio = iframeDocument.querySelector('input.starradio:checked');
      if (selectedRadio){
        var leaderSlot = modal1.querySelector(".leaderInput");
        console.log(selectedRadio);
        console.log(leaderSlot);
        leaderSlot.value = selectedRadio.value;
      }
      //copy over trainers
      var checkedCheckboxes = iframeDocument.querySelectorAll(
          ".trainer-checkbox:checked"
        );
        console.log(checkedCheckboxes);
        var slots = modal1.querySelectorAll(".trainerInput");
        var slotContainer = modal1.querySelector(".trainer-slots");
        console.log(checkedCheckboxes.length);

        let j = 0; //slots counter
      for (let index = 0; index < checkedCheckboxes.length; index++) {
        console.log(index);
        if(checkedCheckboxes[index].disabled){
          continue;
        }
        if(slots.length > index){
          console.log("checkbox value: " + checkedCheckboxes[index]);
          slots[j++].value = checkedCheckboxes[index].value;
        }
        else{
          const classSelector = "." + Array.from(modal1.querySelector(".trainer-search").classList).join(".");
          console.log(classSelector);
          addTrainerSlot(classSelector,slotContainer.id);
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
          var modal = $("#detail-expand");
          var event = info.event;
          modal.find(".modal-title").text(event.title);
          modal.find(".description").text(event.extendedProps.description);
          modal
            .find(".time")
            .text(
              `${event.extendedProps.formattedStartDate} - ${event.extendedProps.formattedEndTime}`
            );
          modal
            .find(".numLearners")
            .html(`Estimated learners: ${event.extendedProps.numLearners}<br>Target # of trainers: ${Math.ceil(event.extendedProps.numLearners/4)}`);
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
          for (var i = 2; i < defaultSlots; i++) {
            addTrainerSlot(".trainer-search","trainer-slots");
          }
          //uncheck advanced search trainers
          const checkboxes = iframeDocument.querySelectorAll(
            ".trainer-checkbox"
          );
          checkboxes.forEach((checkbox) => {
            checkbox.checked = false;
          });
          modal.modal();
        },
      });
      resolve({ calendar });
    });
  }

  fetchDataAndInitializeCalendar().then(({ calendar }) => {
    function updateEventSources() {
      $.getJSON(`/eventdata`, function (data) {
        console.log("updateEventSources called");
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
        console.log("checked events:");
        console.log(eventIds);
        const hiddenEventIds = Array.from(uncheckedCheckboxes).map((checkbox) =>
          checkbox.getAttribute("event-id")
        );
        console.log("unchecked events:");
        console.log(hiddenEventIds);

        // Remove existing event sources that should be hidden
        console.log("Event sources", calendar.getEventSources());
        const removePromises = calendar.getEvents().map(function (event) {
          if (event.extendedProps.trainerTrue === false) {
            console.log("Removing", event);
            return event.remove(() => resolve());
          }
          // If the event doesn't meet the removal criteria, return a resolved promise
          return Promise.resolve();
        });

        // Add the updated event sources
        console.log("Attempt to add events");
        Promise.all(removePromises)
          .then(() => {
            // Add the updated event sources
            // Add eventDates associated with each event
            console.log("eventIds", eventIds);
            const addPromises = data.map((jsonsource) => {
              console.log("jsonsource", jsonsource);
              if (eventIds.includes(jsonsource.id.toString())) {
                const sourceArray = jsonsource;
                console.log("addEventSource called on:");
                console.log(sourceArray);
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
            console.log("calendar events:");
            console.log(calendar.getEvents());
          })
          .catch((error) => {
            console.error("An error occurred:", error);
          });
      }).catch((error) => {
        console.error("An error occurred during the data fetch:", error);
      });
    }
    function updateTrainerSources() {
      $.getJSON(`/trainerdata`, function (data) {
        console.log("updateTrainerSources called");
        // Retrieve checked checkboxes
        /*
        const checkedCheckboxes = document.querySelectorAll(
          ".trainer-checkbox:checked"
        );
        const uncheckedCheckboxes = document.querySelectorAll(
          ".trainer-checkbox:not(:checked)"
        );

        const trainerIds = Array.from(checkedCheckboxes).map((checkbox) =>
          checkbox.getAttribute("trainer-id")
        );
        console.log(trainerIds);
        const hiddenTrainerIds = Array.from(uncheckedCheckboxes).map(
          (checkbox) => checkbox.getAttribute("trainer-id")
        );

        const removePromises = calendar.getEvents().map(function (event) {
          if (event.extendedProps.trainerTrue === true) {
            console.log("Removing", event);
            return event.remove(() => resolve());
          }
          // If the event doesn't meet the removal criteria, return a resolved promise
          return Promise.resolve();
        });

        // Add the updated event sources
        console.log("Attempt to add events");
        Promise.all(removePromises).then(() => {
          // Add the updated event sources
          // Add eventDates associated with each event
          console.log("trainerIds", trainerIds);
          const addPromises = data.map((jsonsource) => {
            console.log("jsonsource", jsonsource);
            if (trainerIds.includes(jsonsource.id.toString())) {
              const sourceArray = jsonsource;
              console.log("addEventSource called on:");
              console.log(sourceArray);
              return calendar.addEventSource(sourceArray);
            }
            return Promise.resolve();
          });
          // Wait for all add promises to complete
          Promise.all(addPromises).then(() => {
            // Finally, refetch events
            calendar.refetchEvents();
            console.log("calendar sources:");
            console.log(calendar.getEventSources());
          });
        }); */
      });
    }
    //add autocomplete to additional inputs
    document
      .getElementById("add-trainer-slot")
      .addEventListener("click", function() {
        addTrainerSlot(".trainer-search","trainer-slots");});
    document
      .getElementById("update-add-trainer-slot")
      .addEventListener("click", function() {
        addTrainerSlot(".update.trainer-search","update-trainer-slots");});
    // Event listener for checkbox change
    const eventCheckboxes = document.querySelectorAll(".event-checkbox");
    eventCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateEventSources);
    });
    const trainerCheckboxes = document.querySelectorAll(".trainer-checkbox");
    trainerCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateTrainerSources);
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
