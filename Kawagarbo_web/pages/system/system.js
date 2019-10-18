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

// function getSystemInfoSync() {
//     var res = wx.getSystemInfoSync()
//     alert(JSON.stringify(res))
// }