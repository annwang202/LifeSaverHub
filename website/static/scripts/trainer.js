document.addEventListener("DOMContentLoaded", function () {
    function initializeSchedule() {
      return new Promise(function (resolve) {
        var id = 1;
        var calendarEl = document.getElementById("calendar");
        var calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: "timeGridWeek",
          navLinks: false,
          headerToolbar: {
            left:   '',
            center: '',
            right:  ''
          },
          editable: true,
          selectable: true,
          allDaySlot: false,
          initialDate: new Date("2024-01-01"), //set fixed date for consistency, since all we care about is day of week
          firstDay: 1,
          select: function(info) { //add event on click
            var new_event = {
                id: id,
                start: info.start,
                end: info.end,
                startStr: info.startStr,
                endStr: info.endStr,
                extendedProps:{
                    trainerName: 'Default trainer name',
                    dayOfWeek: info.start.getDay() 
                  },    
              };
              id++;
            calendar.addEvent(new_event);
            calendar.refetchEvents();
            var events = calendar.getEvents();
            console.log(events)
            /*let eventPlainObjects = events.map((event) => {
                return {
                    id: event.id,
                    start: event.start,
                    end: event.end,
                    startStr: event.startStr,
                    endStr: event.endStr,
                    extendedProps:{
                        trainerName: 'Default trainer name',
                        dayOfWeek: event.start.getDay() 
                      }
                }
              })*/
            var jsonString = JSON.stringify(events);
            console.log(jsonString);
          },
          eventClick: function (info) {   //remove event source on click
            console.log('Clicked Event:', info.event);
            var slot = info.event;
            var slotId = slot.id;
            console.log('Event ID:', slotId);
            calendar.getEventById( slotId ).remove();
          },
          viewDidMount: function (info) {
            updateColumnHeaders();
        }
        });
        $(".fc-day-number").each(function() { $(this).html(""); }); //remove day numbers
        
        //change headers to only show days of week
        function updateColumnHeaders() {
            var columnHeaderCells = document.querySelectorAll('.fc-col-header-cell');
            columnHeaderCells.forEach(function(cell) {
                var date = cell.getAttribute('data-date');
                var formattedDate = new Date(date);
                var dayOfWeek = formattedDate.toLocaleDateString('en-US', { weekday: 'short' });
                cell.querySelector('.fc-col-header-cell-cushion').textContent = dayOfWeek;
            });
        }
        
        $("#trainer_submit").click(function () {
            // Send the selected events to the server when the form is submitted
            var trainerName = document.getElementById("trainer_name").value;
            if(trainerName.trim() != ""){
              var events = calendar.getEvents();
              console.log(events);
              let eventPlainObjects = events.map((event) => {
                  return {
                    id: event.id,
                    start: event.start,
                    end: event.end,
                    startStr: event.startStr,
                    endStr: event.endStr,
                    extendedProps:{
                        trainerName: trainerName,
                        dayOfWeek: event.start.getDay() 
                      },    
                  };
                })
              let eventSource = [{events: eventPlainObjects}]
              let jsonString = JSON.stringify(eventSource);
              console.log('JSON Data to be sent:', jsonString);
              $.ajax({
                  url: '/trainer_availability',  // Replace with your Flask endpoint
                  type: 'POST',
                  contentType: 'application/json',
                  data: jsonString,
                  dataType: 'json',
                  success: function (response) {
                      console.log('Events successfully sent to the server');
                      events = [];  // Clear the selected events after submission
                  },
                  error: function (error) {
                      console.error('Error sending events to the server:', error);
                  }
              });
            }
        });

        calendar.render();
        resolve({ calendar });
      });
    }
    initializeSchedule();
});