
function saveImageToPhotosAlbum() {
    wx.saveImageToPhotosAlbum({
        filePath: 'testImage.jpg'
        // filePath: 'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2246038698,370269254&fm=26&gp=0.jpg' //支持网络图片
    })
}

function getImageInfo() {
    wx.getImageInfo({
        src: 'testImage.jpg',
        // src: 'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2246038698,370269254&fm=26&gp=0.jpg',
        success: function (res) {
            document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        }
    })
}

function previewImage() {
    wx.previewImage({
        urls: ['https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1508751943,3638847536&fm=26&gp=0.jpg',
               'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2246038698,370269254&fm=26&gp=0.jpg',
               'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2659309470,1593635336&fm=26&gp=0.jpg',
               'testImage.jpg'],
        current: 'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2246038698,370269254&fm=26&gp=0.jpg'
    })
}

function compressImage() {
    wx.compressImage({
        src: 'testImage.jpg',
        quality: 10
    })
}