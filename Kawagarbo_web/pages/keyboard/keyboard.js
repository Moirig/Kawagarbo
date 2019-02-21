
wx.onReady(function () {

    wx.onKeyboardHeightChange(function (res) {
        alert(JSON.stringify(res))
    })

})