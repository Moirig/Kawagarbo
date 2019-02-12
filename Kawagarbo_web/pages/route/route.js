
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