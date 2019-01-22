window.onload = function () {


    wx.onShow(function () {
        alert('onShow')
    })

    wx.onHide(function () {
        alert('onHide')
    })

}


function navigateTo() {
    window.location.href = 'pages/goback.html'
}