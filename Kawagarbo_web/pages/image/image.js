
function saveImageToPhotosAlbum() {
    wx.saveImageToPhotosAlbum({
        filePath: 'testImage.jpg'
        // filePath: 'https://github.com/Moirig/Kawagarbo_iOS/raw/master/Kawagarbo.jpg' //支持网络图片
    })
}

function getImageInfo() {
    wx.getImageInfo({
        src: 'testImage.jpg',
        // src: 'https://github.com/Moirig/Kawagarbo_iOS/raw/master/Kawagarbo.jpg',
        success: function (res) {
            document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        }
    })
}