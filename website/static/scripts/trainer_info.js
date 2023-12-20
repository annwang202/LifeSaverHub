import { filterList } from "./base.js";

document.addEventListener("DOMContentLoaded", function () {
    filterList("#trainerInfoFilter li");
    
    const trainerBoxes = document.querySelectorAll(".list-group-item");
    trainerBoxes.forEach(function (box) {
        var status = box.getAttribute("data-type");
        if (status === "Suspended"){
            box.style.borderColor = "#e3b1b1";
        }
        else if (status === "Team Lead"){
            box.style.borderColor = "#94b581";
        }
    });
});
