export function filterList(filter_selector) {
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

  // the event handler!
  function filterItems(e) {
    console.log("filterItems() called");
    var clickedItem = e.target;

    if (clickedItem.checked == true) {
      hideOrShowItems(clickedItem.value, "hideItem", "showItem");
    } else if (clickedItem.checked == false) {
      console.log(clickedItem + "is unchecked.");
      console.log("clickedItem type:", clickedItem.value);
      var boxesToUncheck = document.querySelectorAll(
        `input.event-checkbox[value="${clickedItem.value}"]`
      );
      var trigger = new Event("change");
      boxesToUncheck.forEach(function (boxToUncheck) {
        // Uncheck the checkboxes, if needed
        console.log("checkbox value:", boxToUncheck.value);
        boxToUncheck.checked = false;
        boxToUncheck.dispatchEvent(trigger);
      });
      hideOrShowItems(clickedItem.value, "showItem", "hideItem");
    } else {
      // deal with the indeterminate state if needed
    }
  }

  // add or remove classes to show or hide our content
  function hideOrShowItems(itemType, classToRemove, classToAdd) {
    for (var i = 0; i < itemsToFilter.length; i++) {
      var currentItem = itemsToFilter[i];
      if (currentItem.getAttribute("data-type") == itemType) {
        removeClass(currentItem, classToRemove);
        addClass(currentItem, classToAdd);
      } else {
        console.log(
          "currentItem data-type:",
          currentItem.getAttribute("data-type")
        );
        console.log("not equal to itemType:", itemType);
      }
    }
  }

  //
  // Helper functions for adding and removing class values
  //
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
}
