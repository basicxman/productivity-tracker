function updateQuotas(rollingQuota, todaysQuota, todaysPoints) {
  setProgress($("#rolling-quota .task-progress"), rollingQuota, todaysPoints);
  setProgress($("#todays-quota .task-progress"), todaysQuota, todaysPoints);
  $("#todays-quota  span.achieved").text(todaysPoints);
  $("#rolling-quota span.achieved").text(todaysPoints);
  $("#todays-quota  span.quota").text(todaysQuota);
  $("#rolling-quota span.quota").text(rollingQuota);
}

$(function() {
  $(".task-bar.pointer").live("click", function() {
    var elm = $(this).parent().next();
    if (elm.css("display") == "none") {
      elm.fadeIn("slow");
      var value = "visible";
    } else {
      elm.fadeOut("slow");
      var value = "hidden";
    }
    setCookie(elm.attr("id") + "-state", value);
  });

  $(".controls-panel").each(function() {
    var state = getCookie($(this).attr("id") + "-state");
    if (state == "visible")
      $(this).show();
  });
});
