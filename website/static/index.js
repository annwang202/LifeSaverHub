function deleteNote(noteId) {
  fetch("/delete-note", {
    method: "POST",
    body: JSON.stringify({ noteId: noteId }),
  }).then((_res) => {
    window.location.href = "/";
  });
}

document.addEventListener("DOMContentLoaded", function () {
  function fetchDataAndInitializeCalendar() {
    return new Promise(function (resolve) {
      var calendarEl = document.getElementById("calendar");
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        headerToolbar: {
          left: "prev,next",
          center: "title",
          right: "dayGridMonth,dayGridWeek,multiMonthYear", // user can switch between the two
        },
        eventClick: function (info) {
          var modal = $("#detail-expand");
          var event = info.event;
          modal.find(".modal-title").text(event.title);
          modal
            .find(".description")
            .text(event.extendedProps.description);
          modal
            .find(".time")
            .text(
              `${event.extendedProps.formattedStartDate} - ${event.extendedProps.formattedEndTime}`
            );
          var borderColor = event.borderColor ? event.borderColor : event.backgroundColor;
          modal.find(".modal-content").css("border-color", borderColor);
          modal.modal();
        },
      });
        resolve({calendar });
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

      // Collect the event IDs associated with checked checkboxes
      const eventIds = Array.from(checkedCheckboxes).map((checkbox) =>
        checkbox.getAttribute("event-id")
      );
      console.log(eventIds);

      // Remove existing event sources that should be hidden
      const removePromises = calendar.getEventSources().map((eventSource) => {
        if (!eventIds.includes(eventSource.id.toString())) {
          return eventSource.remove();
        }
        return Promise.resolve();
      });

      // Add the updated event sources
      Promise.all(removePromises).then(() => {
        // Add the updated event sources
        // Add eventDates associated with each event
        const addPromises = data.map((eventSource) => {
          if (
            eventIds.includes(eventSource.extendedProps.eventId.toString()) &&
            !calendar.getEventSources().some((source) => source.id === eventSource.extendedProps.eventId)
          ) {
            const sourceArray = [eventSource];
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
    }
    function updateTrainerSources() {
      $.getJSON(`/trainerdata`, function (data) {
      console.log("updateTrainerSources called");
      // Retrieve checked checkboxes
      const checkedCheckboxes = document.querySelectorAll(
        ".trainer-checkbox:checked"
      );

      const trainerNames = Array.from(checkedCheckboxes).map((checkbox) =>
        checkbox.getAttribute("trainer-name")
      );
      console.log(trainerNames);

      const removePromises = calendar.getEventSources().map((eventSource) => {
        if (!trainerNames.includes(eventSource.title)) {
          return eventSource.remove();
        }
        return Promise.resolve();
      });

      Promise.all(removePromises).then(() => {
        const addPromises = data.map((eventSource) => {
          if (
            trainerNames.includes(eventSource.title) &&
            !calendar.getEventSources().some((source) => source.title === eventSource.title)
          ) {
            const sourceArray = [eventSource];
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
    }

    // Event listener for checkbox change
    const eventCheckboxes = document.querySelectorAll(".event-checkbox");
    eventCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateEventSources);
    });

    const trainerCheckboxes = document.querySelectorAll(".trainer-checkbox");
    trainerCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", updateTrainerSources);
    });
    calendar.render();
  });
});
