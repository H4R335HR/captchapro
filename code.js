function reloadCaptcha() {
    var captchaImage = document.getElementById("imgCaptcha");
    var imgBaseName = imgNameExtract(captchaImage.src);
    captchaImage.src = imgBaseName +"?" + new Date().getTime();
}
const span = document.createElement("span");
span.classList.add("info");
const cont = "Q2FwdGNoYSBQcm9qZWN0IC0gRGV2ZWxvcGVkIGJ5IEhhcmVlc2ggUmFqZW5kcmFuIGZvciBUQ1MgaU9OIEN5YmVyc2VjdXJpdHkgSW50ZXJuc2hpcCAyMDIz";
span.textContent = atob(cont);
document.body.appendChild(span);

function imgNameExtract(text) {
    var regex = /^[^?]+/;
    var matches = text.match(regex);
    if (matches && matches.length > 0) {
      return matches[0];
    } else {
      return text;
    }
  }