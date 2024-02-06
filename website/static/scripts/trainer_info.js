document.addEventListener("DOMContentLoaded", function () {
    filterList("#trainerInfoFilter li");
    const container = document.getElementById("trainer-info-container");
    var inputs = container.querySelectorAll('input[type="date"], input[type="time"]');
    document.getElementById("clearButton").addEventListener("click",function() {
        clearInputs(inputs);
      });
    document.getElementById("filterButton").addEventListener("click",function() {
        filterAvailability(container);
      });

    const trainerBoxes = document.querySelectorAll(".list-group-item");
    trainerBoxes.forEach(function (box) {
        var status = box.getAttribute("data-type");
        if (status === "New"){
            box.style.borderColor = "#FCF55F";
        }
        else if (status === "Team Lead"){
            box.style.borderColor = "#94b581";
        }
        else if (status === "Basic Trainer"){
            box.style.borderColor = "DodgerBlue";
        }
    });
});

function clearInputs(inputs) {
    inputs.forEach(function(input) {
        input.value = '';
  });
}

function filterAvailability(container){
    console.log("filterAvailability called");
    const weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday"];
    let date = container.querySelector('input[name="date"]').value;
    let starttime = container.querySelector('input[name="start_time"]').value;
    let endtime = container.querySelector('input[name="end_time"]').value;
    var d1=Date.parse('20 Aug 2000 '+starttime);
    var d2=Date.parse('20 Aug 2000 '+endtime);

    if(date != '' && starttime != '' && endtime != '' && d2 >= d1){
        let weekday = weekdays[new Date(date).getDay()];
        console.log({weekday},{date},{starttime},{endtime});
        $.getJSON(
            `/trainer_availability/${weekday}/${starttime}/${endtime}`,
            function (data) {
              console.log("AJAX request successful");
              console.log(data);
            }
          );
    }
    else{
        alert("Please enter a valid date and time interval.")
    }
}