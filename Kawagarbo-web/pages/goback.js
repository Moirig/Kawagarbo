
window.onload = function () {

}

wx.onShow(function () {
    alert('onShow')
})

wx.onHide(function () {
    alert('onHide')
})

wx.onUnload(function () {
    alert('onUnload')
})

wx.onReady(function () {
    alert('onReady')
})

function goback() {
    // history.back(-1)
    location.href = document.referrer
}