var RecorderManager = wx.getRecorderManager()

wx.onReady(function () {

    RecorderManager.onStart = function () {
        document.getElementById('placeholder').innerHTML = 'onStart'
    }

    RecorderManager.onStop = function (res) {
        document.getElementById('placeholder').innerHTML = JSON.stringify(res)
        var audio = document.getElementById('audio0')
        audio.src = res.tempFilePath
    }

    RecorderManager.onPause = function () {
        document.getElementById('placeholder').innerHTML = 'onPause'
    }

    RecorderManager.onResume = function () {
        document.getElementById('placeholder').innerHTML = 'onResume'
    }

    RecorderManager.onError = function (res) {
        document.getElementById('placeholder').innerHTML = JSON.stringify(res)
    }

})


function start() {
    RecorderManager.start()
}


function stop() {
    RecorderManager.stop()
}


function pause() {
    RecorderManager.pause()
}


function resume() {
    RecorderManager.resume()
}

