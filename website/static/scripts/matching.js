import { filterList } from './base.js';

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
          var borderColor = event.borderColor
            ? event.borderColor
            : event.backgroundColor;
          modal.find(".modal-content").css("border-color", borderColor);
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
    /*
    function updateTrainerSources() {
      $.getJSON(`/trainerdata`, function (data) {
        console.log("updateTrainerSources called");
        // Retrieve checked checkboxes
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
        });
      });
    }*/
    // Event listener for checkbox change
    const eventCheckboxes = document.querySelectorAll(".event-checkbox");
    eventCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateEventSources);
    });
    /*
    const trainerCheckboxes = document.querySelectorAll(".trainer-checkbox");
    trainerCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateTrainerSources);
    });*/
    filterList("#itemsToFilter li");
    calendar.render();
  });
});
