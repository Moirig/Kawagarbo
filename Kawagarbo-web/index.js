
wx.onReady(function () {


})


function navigateTo() {
    window.location.href = 'pages/goback.html'
}

function setTitle() {
    wx.setNavigationBarTitle({
        title: '当前页面'
    })
}