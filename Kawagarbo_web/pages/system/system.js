function canIUse() {
    wx.canIUse('getSystemInfo')
}

function getSystemInfo() {
    wx.getSystemInfo({
        success: function (res) {
            alert(JSON.stringify(res))
        }
    })
}