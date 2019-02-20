
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

function setTabBarItem() {
    wx.setTabBarItem({
        index: 0,
        text: 'aaaa',
        iconPath: 'home_n.png',
        selectedIconPath: 'home_s.png'
    })
}

function showTabBarRedDot() {
    wx.showTabBarRedDot({
        index: 0
    })
}

function setTabBarBadge() {
    wx.setTabBarBadge({
        index: 0,
        text: '1234'
    })
}

function hideTabBarRedDot() {
    wx.hideTabBarRedDot({
        index: 0
    })
}

function removeTabBarBadge() {
    wx.removeTabBarBadge({
        index: 0
    })
}