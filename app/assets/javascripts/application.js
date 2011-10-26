//= require jquery
//= require jquery_ujs
//= require_tree .

function setGlobalQuota(value) {
  $("#stats").text(value);
  if (value < 0)
    $("#stats").addClass("negative");
  else
    $("#stats").removeClass("negative");
}

function setProgress(elm, taskQuota, total) {
  var containerWidth = $("#tasks .task-container:first").width();
  if (taskQuota == 0) {
    value = containerWidth;
  } else {
    var slotWidth = containerWidth / taskQuota;
    var value = total * slotWidth;
    if (value > containerWidth)
      value = containerWidth;
  }
  elm.clearQueue().animate({ width: value }, "slow");
}

function initProgress() {
  $("#tasks tr").each(function() {
    setProgress($(this).find(".task-progress"), $(this).children(".quota:first").val(), $(this).children(".achieved:first").val());
  });
}

function updateQuota(elm) {
  var id = elm.parent().parent().attr("id").substring(4);
  var quota = elm.val();
  $.post("/days/" + id + "/change_quota", { "quota": quota });
}

function chartDays() {
  var data = [];
  for (var i = 0; i < $.chart_data.length; ++i) {
    if ($(".task-controls img.graph-visible:visible[data-task='" + $.chart_data[i].label + "']").length == 1 || $.chart_data[i].label == "Total") {
      data.push($.chart_data[i]);
    }
  }

  $.chart = $.plot($("#days-chart"), data, {
    series: {
      lines:  { show: true },
      points: { show: true, radius: 5 },
      shadowSize: 5
    },
    legend: {
      margin: [-140, 0]
    },
    xaxis: {
      mode: "time",
      ticks: $.chart_data[0].data.length,
      tickSize: [1, "day"]
    },
    yaxis: {
      min: 0
    },
    grid: {
      color: "#ddd"
    }
  });
  $(".yAxis:first .tickLabel").css({
    right: "auto",
    left: "0px",
    width: "50px",
    marginLeft: "-40px"
  });
}

function findDateIndex(date) {
  for (var i = 0; i < $.chart_data[0].data.length; ++i) {
    if ($.chart_data[0].data[i][0] == date)
      return i;
  }
  return -1;
}

/*
 * Check if the specified date exists in the chart, if not add it.
 */
function checkChartDataForDay(date) {
  var temp = $.chart_data[0].data;
  if (findDateIndex(date) == -1) {
    for (var i = 0; i < $.chart_data.length; ++i) {
      $.chart_data[i].data.push([date, 0]);
    }
  }
}

function updateTaskChart(taskName, achievedPoints, affectedDate) {
  var chart, cur;
  var total = $.chart_data[$.chart_data.length - 1];
  var dateIndex = findDateIndex(affectedDate);

  for (var i = 0; i < $.chart_data.length; ++i) {
    chart = $.chart_data[i];
    if (chart.label == taskName) {
      cur = chart.data[dateIndex][1];
      total.data[dateIndex][1] += achievedPoints - cur;
      chart.data[dateIndex][1] = achievedPoints;
      break;
    }
  }
  chartDays();
}

$(function() {  
  setTimeout(initProgress, 500);

  $(".day-quota").change(function() {
    updateQuota($(this));
  });

  $(".day-quota").keyup(function() {
    if ($.timeout !== undefined) clearTimeout($.timeout);
    $.timeout = setTimeout(updateQuota.apply(this, [$(this)]), 500);
  });
  
  $("img.graph-hidden").click(function() {
    $(this).hide();
    $(this).parent().parent().find("img.graph-visible").show();
    chartDays();
  });

  $("img.graph-visible").click(function() {
    $(this).hide();
    $(this).parent().parent().find("img.graph-hidden").show();
    chartDays();
  });

  $("form input:text").focusin(function() {
    if ($(this).val() == $(this).data("default")) {
      $(this).val("");
      $(this).addClass("filled");
    }
  });

  $("form input:text").focusout(function() {
    if ($(this).val() == "") {
      $(this).val($(this).data("default"));
      $(this).removeClass("filled");
    }
  });
});
