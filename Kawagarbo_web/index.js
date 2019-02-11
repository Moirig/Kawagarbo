
wx.onReady(function () {

})

function toAlert() {
    window.location.href = 'pages/alert/alert.html'
}

function toGoback() {
    window.location.href = 'pages/goback/goback.html'
}

function setNavigationBarTitle() {
    wx.setNavigationBarTitle({
        title: '当前页面'
    })
}

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