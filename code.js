function reloadCaptcha() {
    location.reload();
}
const span = document.createElement("span");
span.classList.add("info");
const cont = "Q2FwdGNoYSBQcm9qZWN0IC0gRGV2ZWxvcGVkIGJ5IEhhcmVlc2ggUmFqZW5kcmFuIGZvciBUQ1MgaU9OIEN5YmVyc2VjdXJpdHkgSW50ZXJuc2hpcCAyMDIz";
span.textContent = atob(cont);
document.body.appendChild(span);