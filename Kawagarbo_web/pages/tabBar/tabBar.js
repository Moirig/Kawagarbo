
function hideTabBar() {
    wx.hideTabBar({
        complete: function (res) {
            wx.showToast({
                icon: 'none',
                title: JSON.stringify(res)
            })
        }
    })
}

function showTabBar() {
    wx.showTabBar({
        complete: function (res) {
            wx.showToast({
                icon: 'none',
                title: JSON.stringify(res)
            })
        }
    })
}