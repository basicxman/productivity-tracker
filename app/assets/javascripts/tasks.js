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
