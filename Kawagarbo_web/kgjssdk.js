;(function () {
    if (window.KGJSBridge) {
        return
    }

    if (!window.onerror) {
        window.onerror = function(msg, url, line) {
            console.log('JSBridge: ERROR:' + msg + '@' + url + ':' + line)
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
                console.log('JSBridge: WARNING: no handler for message from Native:', message)
                responseCallback({code: -1, message: 'No Api:' + message.handlerName + '!'})
            }
        }
    }

    function _toAbsURL(url){
        var a = document.createElement('a');
        a.href = url;
        return a.href;
    };

    const Code = {
        success: 200,
        cancel: -999,
        unknown: 404,
    }

    window.wx = {}

    wx.invokeHandler = function(path, object) {
        object = object || {}
        var obj = JSON.parse(JSON.stringify(object))
        delete obj.complete
        delete obj.success
        delete obj.cancel
        delete obj.unknown
        delete obj.fail

        callHandler(path, obj, function (res) {
            res.data = res.data || {}
            if (res.code == Code.success) {
                res.data.errMsg = path + ':ok'
                object.success && object.success(res.data)
            }

            else if (res.code == Code.cancel) {
                res.data.errMsg = path + ':' + res.message
                object.cancel && object.cancel(res.data)
            }

            else if (res.code == Code.unknown) {
                res.data.errMsg = path + ':' + res.message
                object.unknown && object.unknown(res.data)
            }

            else {
                res.data.errMsg = path + ':' + res.message
                object.fail && object.fail(res.data)
            }

            delete res.message
            object.complete && object.complete(res)
        })
    }

    wx.subscribeHandler = function(path, callback) {
        registerHandler(path, function (data, resCallback) {
            data = data || {}
            data.callback = resCallback
            callback && callback(data)
        })
    }

    //subscribeHandler

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

    //invokeHandler

    wx.canIUse = function(schema) {
        wx.invokeHandler('canIUse', {
            'schema': schema,
            success: function () {
                alert('success')
            },
            fail: function (res) {
                alert(res.message)
            }
        })
    }

    wx.getSystemInfo = function (object) {
        wx.invokeHandler('getSystemInfo', object)
    }



    wx.navigateTo = function (object) {
        object.url = _toAbsURL(object.url)
        wx.invokeHandler('navigateTo', object)
    }

    wx.navigateBack = function (object) {
        wx.invokeHandler('navigateBack', object)
    }

    wx.redirectTo = function(object) {
        object.url = _toAbsURL(object.url)
        wx.invokeHandler('redirectTo', object)
    }

    wx.reLaunch = function(object) {
        object.url = _toAbsURL(object.url)
        wx.invokeHandler('reLaunch', object)
    }

    wx.switchTab = function(object) {
        wx.invokeHandler('switchTab', object)
    }

    wx.showToast = function(object) {
        object.icon = object.icon || 'success'
        object.duration = object.duration || 1500
        object.mask = object.mask || false
        if (object.image) {
            object.image = _toAbsURL(object.image)
        }
        wx.invokeHandler('showToast', object)
    }

    wx.showLoading = function(object) {
        object.mask = object.mask || false
        wx.invokeHandler('showLoading', object)
    }

    wx.hideToast = function(object) {
        wx.invokeHandler('hideToast', object)
    }

    wx.hideLoading = function(object) {
        wx.invokeHandler('hideLoading', object)
    }

    wx.showModal = function(object) {
        object.showCancel = object.showCancel || true
        object.cancelText = object.cancelText || '取消'
        object.cancelColor = object.cancelColor || '#000000'
        object.confirmText = object.confirmText || '确定'
        object.confirmColor = object.confirmColor || '#576B95'
        wx.invokeHandler('showModal', object)
    }

    wx.showActionSheet = function(object) {
        object.cancelText = object.cancelText || '取消'
        object.cancelColor = object.cancelColor || '#000000'
        object.itemColor = object.itemColor || '#000000'
        wx.invokeHandler('showActionSheet', object)
    }


    wx.showNavigationBarLoading = function(object) {
        wx.invokeHandler('showNavigationBarLoading', object)
    }

    wx.setNavigationBarTitle = function (object) {
        wx.invokeHandler('setNavigationBarTitle', object)
    }

    wx.setNavigationBarColor = function (object) {
        wx.invokeHandler('setNavigationBarColor', object)
    }

    wx.hideNavigationBarLoading = function(object) {
        wx.invokeHandler('hideNavigationBarLoading', object)
    }


    wx.showTabBar = function (object) {
        wx.invokeHandler('showTabBar', object)
    }

    wx.hideTabBar = function (object) {
        wx.invokeHandler('hideTabBar', object)
    }

    wx.setTabBarStyle = function (object) {
        wx.invokeHandler('setTabBarStyle', object)
    }

    wx.setTabBarItem = function (object) {
        if (object.iconPath) {
            object.iconPath = _toAbsURL(object.iconPath)
        }
        if (object.selectedIconPath) {
            object.selectedIconPath = _toAbsURL(object.selectedIconPath)
        }
        wx.invokeHandler('setTabBarItem', object)
    }

    wx.showTabBarRedDot = function (object) {
        wx.invokeHandler('showTabBarRedDot', object)
    }

    wx.setTabBarBadge = function (object) {
        wx.invokeHandler('setTabBarBadge', object)
    }

    wx.hideTabBarRedDot = function (object) {
        wx.invokeHandler('hideTabBarRedDot', object)
    }

    wx.removeTabBarBadge = function (object) {
        wx.invokeHandler('removeTabBarBadge', object)
    }

    wx.pageScrollTo = function (object) {
        object.duration = object.duration || 300
        wx.invokeHandler('pageScrollTo', object)
    }


})();