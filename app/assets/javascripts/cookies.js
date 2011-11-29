function setCookie(cookieName, value) {
  var expiry = new Date();
  expiry.setDate(expiry.getDate() + 365);
  document.cookie = cookieName + "=" + escape(value) + ";expires=" + expiry.toUTCString();
}

function getCookie(cookieName) {
  var cookies = document.cookie.split(";");
  for (var i = 0; i < cookies.length; i++) {
    var cookie = cookies[i];
    while (cookie.charAt(0) == " ") cookie = cookie.substring(1, cookie.length);
    if (cookie.indexOf(cookieName + "=") == 0) return cookie.substring(cookieName.length + 1, cookie.length);
  }
  return undefined;
}
