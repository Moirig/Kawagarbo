
function request() {
    var requestTask = wx.request({
        url: 'https://httpbin.org/get',
        data: {testbody1: 123},
        header: {testheader1: '123'},
        complete: function (res) {
            document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        }
    })
    // requestTask.abort()
    requestTask.onHeadersReceived(function (res) {
        document.getElementById('headerPlaceholder').innerHTML = JSON.stringify(res)
    })
}

function downloadFile() {
    // var filePath = 'testTempPath.png'
    var filePath = 'testTempPath.mp4'
    var downloadTask = wx.downloadFile({
        url: 'https://video.cdnvue.com/uploads/1746405174696532785/video/asBF81t',
        // url: 'https://httpbin.org/image/png',
        header: {testheader1: '123'},
        filePath: filePath,
        success: function (res) {
            // var img = document.getElementById('imagePlaceHolder')
            // img.src = filePath
            var video = document.getElementById('videoPlaceHolder')
            video.src = filePath
        },
        complete: function (res) {
            document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        }

    })

    downloadTask.onProgressUpdate(function (res) {
        if (res.progress > 0.6) {
            downloadTask.offProgressUpdate()
        }
        document.getElementById('progressPlaceholder').innerHTML = JSON.stringify(res)
    })
}

function uploadFile() {
    var uploadTask = wx.uploadFile({
        url: 'https://httpbin.org/post',
        // filePath: 'home_n.png',
        filePath: 'testTempPath.mp4',
        name: 'home_n',
        header: {testheader1: '123'},
        formData: {testFormData1: 123},
        complete: function (res) {
            document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        }
    })

    uploadTask.onProgressUpdate(function (res) {
        document.getElementById('progressPlaceholder').innerHTML = JSON.stringify(res)
    })
}