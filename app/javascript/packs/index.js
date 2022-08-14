$(document).on('turbolinks:load', () => {
    $(".btn-txt").css("opacity", "0")
    const cookiesDisclaimer = $("#cookies-disclaimer")
    if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|OperaMini/i.test(navigator.userAgent)) {
        $("#cookies-popup-box").css("opacity", "0")
        cookiesDisclaimer.on("mouseover", () => {
            $("#cookies-popup-box").css("opacity", "100")
        })
        cookiesDisclaimer.on("mouseout", () => {
            $("#cookies-popup-box").css("opacity", "0")
        })
    }

    cookiesDisclaimer.on("click", () => {
        document.cookie = "cookiesAllowed=true; expires=Fri, 31 Dec 9999 23:59:59 GMT";
    })

    setInterval(() => {
        const uploadBtn = $("#nav-upload-btn")
        if (uploadBtn.length) {
            if (uploadBtn.val() !== "") {
                const txt = uploadBtn.val().split("\\")
                $("#default-txt").text(txt[txt.length - 1])
            }
        }
    }, 100)

    const exp = $(".exp")

    exp.mouseenter(e => {
        e.preventDefault()
        Array.from(e.target.getElementsByClassName("exp-img")).forEach(e => {
            $(e).css("opacity", "0")
        })
        Array.from(e.target.getElementsByClassName("btn-txt")).forEach(e => {
            $(e).css("opacity", "100")
        })
    })
    exp.mouseleave(e => {
        e.preventDefault()
        Array.from(e.target.getElementsByClassName("exp-img")).forEach(e => {
            $(e).css("opacity", "100")
        })
        Array.from(e.target.getElementsByClassName("btn-txt")).forEach(e => {
            $(e).css("opacity", "0")
        })
    })
})

