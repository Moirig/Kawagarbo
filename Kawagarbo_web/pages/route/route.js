
function navigateTo(url) {
    wx.navigateTo({
        url: url
    })
}

function navigateBack() {
    wx.navigateBack({
        delta: 1
    })
}

function redirectTo(url) {
    wx.redirectTo({
        url: url
    })
}

function reLaunch(url) {
    wx.reLaunch({
        url: url
    })
}

function switchTab(index) {
    wx.switchTab({
        index: index
    })
}