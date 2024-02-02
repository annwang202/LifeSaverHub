document.addEventListener("DOMContentLoaded", function () {
    function initializeSchedule() {
      return new Promise(function (resolve) {
        var id = 1;
        var calendarEl = document.getElementById("scheduler");
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
        $("#scheduler .fc-day-number").each(function() { $(this).html(""); }); //remove day numbers
        
        //change headers to only show days of week
        function updateColumnHeaders() {
            var columnHeaderCells = document.querySelectorAll('#scheduler .fc-col-header-cell');
            columnHeaderCells.forEach(function(cell) {
                var date = cell.getAttribute('data-date');
                var formattedDate = new Date(date);
                var dayOfWeek = formattedDate.toLocaleDateString('en-US', { weekday: 'short' });
                cell.querySelector('#scheduler .fc-col-header-cell-cushion').textContent = dayOfWeek;
            });
        }
        
        document.getElementById('trainer_form').addEventListener('submit', function(event) {
          event.preventDefault();
          const formData = new FormData(event.target);  
          
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
              let eventSourceData = {events: eventPlainObjects};
              formData.append('eventSource', JSON.stringify(eventSourceData));
              //let jsonString = JSON.stringify(eventSource);
              //console.log('JSON Data to be sent:', jsonString);
              $.ajax({
                url: '/submit-trainer',  // Replace with your server endpoint
                type: 'POST',
                contentType: false,  // Use false for FormData
                processData: false,  // Use false for FormData
                data: formData,
                dataType: 'json',
                success: function (response) {
                    // Handle the success response from the server
                    console.log('Data successfully sent to the server');
                },
                error: function (error) {
                    // Handle errors
                    console.error('Error sending data to the server:', error);
                }
            });
            window.location.href = '/submit-trainer';
            }
        });
        calendar.id = "scheduler"
        calendar.render();
        resolve({ calendar });
      });
    }
    initializeSchedule();
});