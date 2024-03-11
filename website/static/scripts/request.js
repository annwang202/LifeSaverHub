var id = 1;
document.addEventListener("DOMContentLoaded", function () {
  function initializeSchedule() {
    return new Promise(function (resolve) {
      var calendarEl = document.getElementById("request_calendar");
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        navLinks: false,
        fixedWeekCount: true,
        headerToolbar: {
          left: "prev,next",
          center: "title",
          right: "timeGridDay,dayGridMonth,timeGridWeek,multiMonthYear",
        },
        editable: true,
        selectable: true,
        select: function (info) {
          //add event on click
          var modal = $("#modal");
          modal.modal();
        },
        eventClick: function (info) {
          //remove event source on click
          console.log("Clicked Event:", info.event);
          var slot = info.event;
          var slotId = slot.id;
          console.log("Event ID:", slotId);
          calendar.getEventById(slotId).remove();
        },
      });
      document
        .getElementById("event_form")
        .addEventListener("submit", function (event) {
          event.preventDefault();
          const formData = new FormData(event.target);

          // Send the selected events to the server when the form is submitted
          var trainerName = document.getElementById("trainer_name").value;
          if (trainerName.trim() != "") {
            var events = calendar.getEvents();
            console.log(events);
            let eventPlainObjects = events.map((event) => {
              return {
                id: event.id,
                start: event.start,
                end: event.end,
                startStr: event.startStr,
                endStr: event.endStr,
                extendedProps: {
                  trainerName: trainerName,
                  dayOfWeek: event.start.getDay(),
                },
              };
            });
            let eventSourceData = { events: eventPlainObjects };
            formData.append("eventSource", JSON.stringify(eventSourceData));
            //let jsonString = JSON.stringify(eventSource);
            //console.log('JSON Data to be sent:', jsonString);
            $.ajax({
              url: "/submit-trainer", // Replace with your server endpoint
              type: "POST",
              contentType: false, // Use false for FormData
              processData: false, // Use false for FormData
              data: formData,
              dataType: "json",
              success: function (response) {
                // Handle the success response from the server
                console.log("Data successfully sent to the server");
              },
              error: function (error) {
                // Handle errors
                console.error("Error sending data to the server:", error);
              },
            });
            window.location.href = "/submit-trainer";
          }
        });
      calendar.id = "scheduler";
      calendar.render();
      resolve({ calendar });
    });
  }
  initializeSchedule();
});


function initalizeDateClick() {
    const select = document.getElementById("selectBtn");
    select.addEventListener("click", function () {
      var new_event = {
          id: id,
          start: info.start,
          end: info.end,
          startStr: info.startStr,
          endStr: info.endStr,
          extendedProps: {
            trainerName: "Default trainer name",
            dayOfWeek: info.start.getDay(),
          },
        };
        id++;
        calendar.addEvent(new_event);
        calendar.refetchEvents();
        var events = calendar.getEvents();
        var jsonString = JSON.stringify(events);
        console.log(jsonString);
    });
}