
wx.onReady(function () {

})

function toAlert() {
    window.location.href = 'pages/alert/alert.html'
}

function toGoback() {
    window.location.href = 'pages/goback/goback.html'
}

function toSystem() {
    window.location.href = 'pages/system/system.html'
}

function toRoute() {
    window.location.href = 'pages/route/route.html'
}

function toInteraction() {
    window.location.href = 'pages/interaction/interaction.html'
}

function toNavigationBar() {
    window.location.href = 'pages/navigationBar/navigationBar.html'
}

function navigateTo(url) {
    wx.navigateTo({
        url: url
    })
}

