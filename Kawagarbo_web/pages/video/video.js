
function saveVideoToPhotosAlbum() {
    wx.saveVideoToPhotosAlbum({
        filePath: 'https://video.cdnvue.com/uploads/1746405174696532785/video/asBF81t'
    })
}

function chooseVideo() {
    wx.chooseVideo({
        success: function (res) {
            var video = document.getElementById('video0')
            video.src = res.tempFilePath
            // video.src = 'https://video.cdnvue.com/uploads/1746405174696532785/video/asBF81t'
            // video.src = '../../kgtempCache/IMG_0321.MP4'
            // video.src = '1554110807088237.mp4'
        }
    })
}