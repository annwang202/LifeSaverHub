function deleteTrainerSlot(button,search_class) {
  var slot = button.closest(search_class);
  slot.parentNode.removeChild(slot);
}
function addTrainerSlot(search_class,container) {
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
      .map((person) => `${person.name} (${person.email})`);
    autocomplete(document.querySelectorAll(".myInput"), trainer_names);
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
  trainers,
} = {}) {
  var modal = $("#update-assignment");
  modal.find(".modal-title").text(title);
  modal.find(".time").text(`${formatted_start_date} - ${formatted_end_time}`);
  modal.find(".numLearners").text(`Estimated learners: ${learners}`);
  var borderColor = "grey";
  var currStatus = document.querySelector("#current-status");
  currStatus.value = eventStatus;
  currStatus.textContent = eventStatus;
  modal.find(".modal-content").css("border-color", borderColor);
  $("#update-assignment-event-id").val(eventId);
  $("#update-assignment-start-date").val(startDate);
  $("#update-assignment-end-date").val(endDate);
  $("#update-assignment-formatted-start-date").val(formatted_start_date);
  $("#update-assignment-formatted-end-time").val(formatted_end_time);
  //delete all previously copied slots
  const trainerSlotsContainer = document.getElementById("update-trainer-slots");
  const currentSlots =
    trainerSlotsContainer.querySelectorAll(".update-trainer-search");
  // Remove all but the first slot
  for (let i = 1; i < currentSlots.length; i++) {
    trainerSlotsContainer.removeChild(currentSlots[i]);
  }
  //copy the correct number of slots
  console.log("trainers length:" + trainers.length)
  for (let j = 1; j < trainers.length; j++) {
    addTrainerSlot(".update-trainer-search","update-trainer-slots");
    console.log("addTrainerSlot called")
  }
  const newSlots = trainerSlotsContainer.querySelectorAll(".update-trainer-search");
  for (index = 0; index < newSlots.length; index++) {
    let slot = newSlots[index];
    let input = slot.querySelector('input[type="text"]');
    input.value = trainers[index];
  }
  modal.modal();
}

document.addEventListener("DOMContentLoaded", function () {
  function fetchDataAndInitializeCalendar() {
    return new Promise(function (resolve) {
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
            .text(`Estimated learners: ${event.extendedProps.numLearners}`);
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
          //copy the correct number of slots
          var defaultSlots = Math.ceil(event.extendedProps.numLearners / 10);
          for (var i = 2; i < defaultSlots; i++) {
            addTrainerSlot(".trainer-search","trainer-slots");
          }
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
        addTrainerSlot(".update-trainer-search","update-trainer-slots");});
    // Event listener for checkbox change
    const eventCheckboxes = document.querySelectorAll(".event-checkbox");
    eventCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateEventSources);
    });
    const trainerCheckboxes = document.querySelectorAll(".trainer-checkbox");
    trainerCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateTrainerSources);
    });
    filterList("#itemsToFilter li");
    calendar.render();
    $.getJSON(`/trainerdata`, function (data) {
      let trainer_names = data
        .filter((person) => person.status !== "Suspended")
        .map((person) => `${person.name} (${person.email})`);
      autocomplete(document.querySelectorAll(".myInput"), trainer_names);
    });
  });
});
