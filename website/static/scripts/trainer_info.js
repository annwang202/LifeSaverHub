document.addEventListener("DOMContentLoaded", function () {
    filterList("#trainerInfoFilter li");
    
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
