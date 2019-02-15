
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

function setTabBarStyle() {
    wx.setTabBarStyle({
        color: '#ff0000',
        selectedColor: '#00ff00',
        backgroundColor: '#0000ff',
        borderStyle: 'white'
    })
}

function resetTabBarStyle() {
    wx.setTabBarStyle({
        color: '#A1A1A1',
        selectedColor: '#1CA5F5',
        backgroundColor: '#eeeeee',
        borderStyle: 'black'
    })
}