;(function () {
    if (window.KGJSBridge) {
        return
    }

    if (!window.onerror) {
        window.onerror = function(msg, url, line) {
            console.log("JSBridge: ERROR:" + msg + "@" + url + ":" + line)
        }
    }

    window.KGJSBridge = {
        registerHandler: registerHandler,
        callHandler: callHandler,
        _subscribeHandler: _subscribeHandler
    };

    var messageHandlers = {}

    var responseCallbacks = {}

    var uniqueId = 1

    function registerHandler(handlerName, handler) {
        messageHandlers[handlerName] = handler
    }

    function callHandler(handlerName, data, responseCallback) {
        if (arguments.length == 2 && typeof data == 'function') {
            responseCallback = data
            data = null
        }
        _doSend({ handlerName:handlerName, data:data }, responseCallback)
    }

    function _doSend(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime()
            responseCallbacks[callbackId] = responseCallback
            message['callbackId'] = callbackId
        }

        _postMessage(message)
    }

    function _postMessage(message) {
        if (window.invokeHandler) {
            window.invokeHandler.postMessage(JSON.stringify(message))
        }
        else {
            window.webkit.messageHandlers.invokeHandler.postMessage(message)
        }
    }

    function _subscribeHandler(messageJSON) {
        var message = JSON.parse(messageJSON)
        var responseCallback

        if (message.responseId) {
            responseCallback = responseCallbacks[message.responseId]
            if (!responseCallback) {
                return
            }

            responseCallback(message.responseData)
            delete responseCallbacks[message.responseId]
        }
        else {
            if (message.callbackId) {
                var callbackResponseId = message.callbackId
                responseCallback = function (responseData) {
                    _doSend({
                        handlerName: message.handlerName,
                        responseId: callbackResponseId,
                        responseData: responseData
                    })
                }
            }

            var handler = messageHandlers[message.handlerName]
            if (handler) {
                handler(message.data, responseCallback)
            }
            else {
                console.log("JSBridge: WARNING: no handler for message from Native:", message)
                responseCallback({code: -1, message: 'No Api:' + message.handlerName + '!'})
            }
        }
    }

    const Code = {
        success: 200,
        cancel: -999,
        unknown: 404,
    }

    window.wx = {}

    wx.invokeHandler = function(req) {
        callHandler(req.path, req.data, function (res) {
            if (res.code == Code.success) { req.data.success && req.data.success(res.data) }

            else if (res.code == Code.cancel) { req.data.cancel && req.data.cancel(res.message) }

            else if (res.code == Code.unknown) { req.data.unknown && req.data.unknown(res.message) }

            else { req.data.fail && req.data.fail(res) }
        })
    }

    wx.subscribeHandler = function(path, callback) {
        registerHandler(path, function (data, resCallback) {
            data = data || {}
            data.callback = resCallback
            callback && callback(data)
        })
    }

    wx.onShow = function (callback) {
        wx.subscribeHandler('onShow', callback)
    }

    wx.onHide = function (callback) {
        wx.subscribeHandler('onHide', callback)
    }

    wx.onUnload = function (callback) {
        wx.subscribeHandler('onUnload', callback)
    }

    wx.onReady = function (callback) {
        wx.subscribeHandler('onReady', callback)
    }


})();