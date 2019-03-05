function setStorage() {
    wx.setStorage({
        key: 'key',
        data: 'value',
        complete: function(res) {
            alert(JSON.stringify(res))
        }
    })
}

function getStorage() {
    wx.getStorage({
        key: 'key',
        complete: function(res) {
            alert(JSON.stringify(res))
        }
    })
}

function removeStorage() {
    wx.removeStorage({
        key: 'key1',
        complete: function(res) {
            alert(JSON.stringify(res))
        }
    })
}

function getStorageInfo() {
    wx.getStorageInfo({
        complete: function(res) {
            alert(JSON.stringify(res))
        }
    })
}

function clearStorage() {
    wx.clearStorage({
        complete: function(res) {
            alert(JSON.stringify(res))
        }
    })
}
