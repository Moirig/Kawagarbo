
function saveImageToPhotosAlbum() {
    wx.saveImageToPhotosAlbum({
        filePath: 'testImage.jpg'
        // filePath: 'https://github.com/Moirig/Kawagarbo_iOS/raw/master/Kawagarbo.jpg' //支持网络图片
    })
}