function filterEvents(filter_selector) {
  // get all of our list items
  var itemsToFilter = document.querySelectorAll(filter_selector);

  //setup click event handlers on our checkboxes
  var checkBoxes = document.querySelectorAll(
    ".filterSection li input[type='checkbox']"
  );

  for (var i = 0; i < checkBoxes.length; i++) {
    checkBoxes[i].addEventListener("click", filterItems, false);
    console.log("added event listener to:", checkBoxes[i]);
  }

  function filterItems(e) {
    console.log("filterItems() called");
    var clickedItem = e.target;

    if (clickedItem.checked == true) {
      hideOrShowItems(itemsToFilter,"data-type",clickedItem.value, "hideItem", "showItem");
    } else if (clickedItem.checked == false) {
      console.log(clickedItem + "is unchecked.");
      console.log("clickedItem type:", clickedItem.value);
      var boxesToUncheck = document.querySelectorAll(
        `input.event-checkbox[value="${clickedItem.value}"]`
      );
      var trigger = new Event("change");
      boxesToUncheck.forEach(function (boxToUncheck) {
        // Uncheck the checkboxes
        console.log("checkbox value:", boxToUncheck.value);
        boxToUncheck.checked = false;
        boxToUncheck.dispatchEvent(trigger);
      });
      hideOrShowItems(itemsToFilter,"data-type",clickedItem.value, "showItem", "hideItem");
    }
  }
}

function hideOrShowItems(listItems,attribute,itemType,classToRemove, classToAdd) {
  for (var i = 0; i < listItems.length; i++) {
    var currentItem = listItems[i];
    if (currentItem.getAttribute(attribute) == itemType) {
      removeClass(currentItem, classToRemove);
      addClass(currentItem, classToAdd);
    } else {
      console.log(
        "currentItem " + attribute + ": ",
        currentItem.getAttribute(attribute)
      );
      console.log("not equal to itemType:", itemType);
    }
  }
}

function addClass(element, classToAdd) {
  var currentClassValue = element.className;

  if (currentClassValue.indexOf(classToAdd) == -1) {
    if (currentClassValue == null || currentClassValue === "") {
      element.className = classToAdd;
    } else {
      element.className += " " + classToAdd;
    }
  }
}

function removeClass(element, classToRemove) {
  var currentClassValue = element.className;

  if (currentClassValue == classToRemove) {
    element.className = "";
    return;
  }

  var classValues = currentClassValue.split(" ");
  var filteredList = [];

  for (var i = 0; i < classValues.length; i++) {
    if (classToRemove != classValues[i]) {
      filteredList.push(classValues[i]);
    }
  }

  element.className = filteredList.join(" ");
}

function autocomplete(inputs, full_arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  console.log("autocomplete function called");
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inputs.forEach(function (inp) {
    inp.addEventListener("input", handleInput);
    inp.addEventListener("click", handleInput);
    /*execute a function presses a key on the keyboard:*/
    inp.addEventListener("keydown", function (e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) {
        //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
    });
    function addActive(x) {
      /*a function to classify an item as "active":*/
      if (!x) return false;
      /*start by removing the "active" class on all items:*/
      removeActive(x);
      if (currentFocus >= x.length) currentFocus = 0;
      if (currentFocus < 0) currentFocus = x.length - 1;
      /*add class "autocomplete-active":*/
      x[currentFocus].classList.add("autocomplete-active");
    }
    function removeActive(x) {
      /*a function to remove the "active" class from all autocomplete items:*/
      for (var i = 0; i < x.length; i++) {
        x[i].classList.remove("autocomplete-active");
      }
    }
    function closeAllLists(elmnt) {
      /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
      var x = document.getElementsByClassName("autocomplete-items");
      for (var i = 0; i < x.length; i++) {
        if (elmnt != x[i] && elmnt != inp) {
          x[i].parentNode.removeChild(x[i]);
        }
      }
    }
    function handleInput(e) {
      
      /*Get already entered trainer names and remove them from dropdown list*/
      var valuesArray = Array.from(document.querySelectorAll(".trainerInput, .leaderInput")).map(function(input) {
        return input.value;
       });

      var arr = full_arr.filter(n => !valuesArray.includes(n))

      var a,
        b,
        i,
        val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      console.log("iterating through autocomplete array");
      for (i = 0; i < arr.length; i++) {
        console.log(arr[i]);
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function (e) {
            /*insert the value for the autocomplete text field:*/
            inp.value = this.getElementsByTagName("input")[0].value;
            /*close the list of autocompleted values,
                (or any other open lists of autocompleted values:*/
            closeAllLists();
          });
          a.appendChild(b);
        }
      }
    }
    /*execute a function when someone clicks in the document:*/
    document.addEventListener("click", function (e) {
      closeAllLists(e.target);
    });
  });
}
