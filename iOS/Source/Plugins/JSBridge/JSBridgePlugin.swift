//
//  JSBridge.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

private let JSBridgeInjectFlag = "https://www.kawagarbo.com/bridge/inject"

private let JSBridge = """

;(function() {
    if (window.kawagarbo) {
        return;
    }

    if (!window.onerror) {
        window.onerror = function(msg, url, line) {
            console.log('JSBridge: ERROR:' + msg + '@' + url + ':' + line);
        }
    }

    window.kawagarbo = {};
    var _invokes = {};
    var _subscribes = {};
    var _uniqueId = 1;
    const SUCCESS = 200;
    const CANCEL = -999;
    const UNKNOWN = 404;

    kawagarbo.invoke = function(path, obj) {
        obj = obj || {};
        var params = JSON.parse(JSON.stringify(obj));
        delete params.complete;
        delete params.success;
        delete params.cancel;
        delete params.unknown;
        delete params.fail;

        kawagarbo._invoke(path, params, function(res) {
            res.data = res.data || {};
            if (res.code == SUCCESS) {
                res.data.errMsg = path + ':ok';
                obj.success && obj.success(res.data);
            }
            else if (res.code == CANCEL) {
                res.data.errMsg = path + ':' + res.message;
                obj.cancel && obj.cancel(res.data);
            }
            else if (res.code == UNKNOWN) {
                res.data.errMsg = path + ':' + res.message;
                obj.unknown && obj.unknown(res.data);
            }
            else {
                res.data.errMsg = path + ':' + res.message;
                obj.fail && obj.fail(res.data);
            }

            obj.complete && obj.complete(res);
        });
    }

    kawagarbo._invoke = function(path, params, callback) {
        var message = { path: path, params: params };
        message.msgId = 'invoke_' + (_uniqueId++) + '_' + new Date().getTime();
        _invokes[message.msgId] = callback;
        window.webkit.messageHandlers.invokeHandler.postMessage(message);
    }

    kawagarbo._invokeCallback = function(messageJSON) {
        var message = JSON.parse(messageJSON);
        var callback = _invokes[message.msgId];
        if (callback) {
            callback(message.res);
            delete _invokes[message.msgId];
        }
        else {
            console.log("JSBridge: JS unknown invoke: ", message);
        }
    }


    kawagarbo.subscribe = function(path, callback) {
        kawagarbo._subscribe(path, function(params, resCallback) {
            params = params || {};
            params.callback = resCallback;
            callback && callback(params);
        });
    }

    kawagarbo._subscribe = function(path, callback) {
        _subscribes[path] = callback;
    }

    kawagarbo._subscribeNative = function(messageJSON) {
        var message = JSON.parse(messageJSON);
        var subscribe = _subscribes[message.path];

        if (subscribe) {
            var callback;
            if (message.msgId) {
                callback = function(res) {
                    window.webkit.messageHandlers.subscribeHandler.postMessage({
                        msgId: message.msgId,
                        path: message.path,
                        res: res
                    });
                };
            }
            subscribe(message.params, callback);
        }
        else {
            console.log("JSBridge: JS no subscribe: " + message.path);
        }
    }

    setTimeout(function() {
        var callbacks = window.KWJBCallbacks;
        delete window.KWJBCallbacks;
        for (var i = 0; i < callbacks.length; i++) {
            callbacks[i]();
        }
    }, 0);
    
})();

"""

class JSBridgePlugin: NSObject, NavigationPlugin {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString == JSBridgeInjectFlag {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: InvokeHandleName)
            webView.configuration.userContentController.removeScriptMessageHandler(forName: SubscribeHandleName)
            webView.configuration.userContentController.add(webView.kw.viewController, name: InvokeHandleName)
            webView.configuration.userContentController.add(webView.kw.viewController, name: SubscribeHandleName)
            webView.evaluateJavaScript(JSBridge, completionHandler: nil)
            decisionHandler(.cancel)
        }
    }
    
}
