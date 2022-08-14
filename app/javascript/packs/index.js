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
                $("#default-txt").text(txt[txt.length-1])
            }
        }
    }, 100)

    const exp = $(".exp")
    console.log(exp)

    let oldPadding=0

    exp.on('mouseenter', e => {
        oldPadding=$(e.target).css("padding-left")
        $(e.target).css("padding-left", "0")
        $(e.target).css("width", "3.5em")
        Array.from(e.target.getElementsByClassName("btn-txt")).forEach(e => {
            $(e).css("opacity", "100")
        })
    })
        exp.on('mouseleave', e => {
        $(e.target).css("padding-left", oldPadding)
        $(e.target).css("width", "2.5em")
        Array.from(e.target.getElementsByClassName("btn-txt")).forEach(e => {
            $(e).css("opacity", "0")
            $(e).css("padding-left", "0")
            $(e).css("width", "3.5em")
        })
    })
})

