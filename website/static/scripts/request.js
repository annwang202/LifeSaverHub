var id = 1;
document.addEventListener("DOMContentLoaded", function () {
  function initializeSchedule() {
    return new Promise(function (resolve) {
      var calendarEl = document.getElementById("request_calendar");
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        navLinks: true,
        fixedWeekCount: true,
        timezone: false,
        headerToolbar: {
          left: "prev,next",
          center: "title",
          right: "timeGridDay,dayGridMonth,timeGridWeek,multiMonthYear",
        },
        editable: true,
        selectable: true,
        select: function (info) {
          //add event on click
          var parsedStart = new Date(info.start);
          var parsedEnd = new Date(info.end);
          var startHours = String(parsedStart.getHours()).padStart(2, "0");
          var startMinutes = String(parsedStart.getMinutes()).padStart(2, "0");
          var startTime = `${startHours}:${startMinutes}`;
          var endHours = String(parsedEnd.getHours()).padStart(2, "0");
          var endMinutes = String(parsedEnd.getMinutes()).padStart(2, "0");
          var endTime = `${endHours}:${endMinutes}`;
          var modal = $("#modal");
          modal
            .find(".modal-title")
            .text(
              `${parsedStart.toLocaleDateString("en-us", {
                weekday: "long",
                year: "numeric",
                month: "long",
                day: "numeric",
              })}`
            );
          if (startTime == endTime) {
            startTime = "";
            endTime = "";
          }
          document.getElementById("startStr").value = info.startStr;
          document.getElementById("endStr").value = info.endStr;
          document.getElementById("start").value = info.startStr.split('T')[0];
          document.getElementById("end").value = info.endStr.split('T')[0];
          document.getElementById("start_time").value = startTime;
          document.getElementById("end_time").value = endTime;
          modal.modal();
        },
        eventClick: function (info) {
          //remove event source on click
          if (confirm("Are you sure you want to delete this timeslot?")) {
            var slot = info.event;
            var slotId = slot.id;
            calendar.getEventById(slotId).remove();
          }
        },
      });
      document
        .getElementById("event_form")
        .addEventListener("submit", function (event) {
          event.preventDefault();
          const formData = new FormData(event.target);
          // Send the selected events to the server when the form is submitted
          var events = calendar.getEvents();
          var eventDates = []
          events.forEach(function(event){
            eventDates.push({"start_date":event.start,"end_date":event.end,"allDay":event.allDay,"timeOfDay":event.extendedProps.timeOfDay})
          });
          formData.append("eventDates", JSON.stringify(eventDates));
          $.ajax({
            url: "/submit-event", // Replace with your server endpoint
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
          window.location.href = "/submit-event";
        });
      calendar.id = "scheduler";
      calendar.render();
      initalizeDateClick(calendar);
      resolve({ calendar });
    });
  }
  initializeSchedule();
});

function initalizeDateClick(calendar, modal) {
  const select = document.getElementById("selectBtn");
  select.addEventListener("click", function (event) {
    event.preventDefault();
    var start = document.getElementById("start").value;
    var end = document.getElementById("end").value;
    var startStr = document.getElementById("startStr").value;
    var endStr = document.getElementById("endStr").value;
    var start_time = document.getElementById("start_time").value;
    var end_time = document.getElementById("end_time").value;
    var timeOfDay = document.getElementById("timeOfDay").value;
    var allDay = false;
    var title = "";
    if (start_time == end_time) {
      allDay = true;
      title = timeOfDay;
    } else {
      var combinedStartStr = start + "T" + start_time;
      var combinedEndStr = start + "T" + end_time; //use startStr instead of endStr,
      var start = new Date(combinedStartStr);
      var end = new Date(combinedEndStr); //because endStr will include the next day unless specific time slots were selected*/
      console.log(combinedEndStr);
    }
    var new_event = {
      id: id,
      title: title,
      allDay: allDay,
      start: start,
      end: end,
      startStr: startStr,
      endStr: endStr,
      extendedProps: {
        timeOfDay: title,
      },
    };
    id++;
    calendar.addEvent(new_event);
    calendar.refetchEvents();
    var events = calendar.getEvents();
    var jsonString = JSON.stringify(events);
    console.log(jsonString);
    var modal = $("#modal");
    modal.modal("toggle");
  });
}
