document.addEventListener("DOMContentLoaded", function () {
  // create groups
  /*
  availability.forEach(function(trainerDate) {
    console.log(trainerDate);
  });
  */
  var groups = new vis.DataSet();
  trainers.forEach(function(trainer) {
    groups.add({
      id: trainer.id,
      content: "" + trainer.id + ". " + trainer.nickname,
    });
  });

  // create items
  var items = new vis.DataSet();

  availability.forEach(function(entry){
    var start = new Date(entry.iso_formatted_start_date)
    var end = new Date(entry.iso_formatted_end_date)

    items.add({
        id: entry.id,
        group: entry.trainer_id,
        start: start,
        end: end,
        content: "" + entry.formatted_start_time + " - " + entry.formatted_end_time,
      });
  })

  console.log(start);
  console.log(end);
  // specify options
  var options = {
    width: '100%',
    margin: { item: {horizontal:0, vertical:0},
              axis: 0    },
    stack: true,
    verticalScroll: true,
    moveable: false,
    autoResize: true,
    zoomKey: "ctrlKey",
    start: start,
    end: end,
    editable: false,
    orientation: "top",
    format: {
        minorLabels: {
            hour:       'hA',
          },
        majorLabels: {
            hour:       'dddd'
          }
    },
    timeAxis: {scale: 'hour', step: 1}
  };

  // create a Timeline
  var container = document.getElementById("visualization");
  timeline = new vis.Timeline(container, items, groups, options);
});
