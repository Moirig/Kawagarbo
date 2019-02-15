
function navigateTo(url) {
    wx.navigateTo({
        url: url
    })
}

function setNavigationBarTitle() {
    wx.setNavigationBarTitle({
        title: '当前页面'
    })
}

function setNavigationBarColor() {
    wx.setNavigationBarColor({
        frontColor: '#ffffff',
        backgroundColor: '#000000'
    })
}