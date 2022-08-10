$(document).on('turbolinks:load', () => {

    if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|OperaMini/i.test(navigator.userAgent)) {
        $("#cookies-popup-box").css("opacity", "0")
        $("#cookies-disclaimer").on("mouseover", () => {
            $("#cookies-popup-box").css("opacity", "100")
        })
        $("#cookies-disclaimer").on("mouseout", () => {
            $("#cookies-popup-box").css("opacity", "0")
        })
    }

    $("#cookies-disclaimer").on("click", () => {
        document.cookie = "cookiesAllowed=true; expires=Fri, 31 Dec 9999 23:59:59 GMT";
    })


})

