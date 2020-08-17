var kw = {}

kw.setup = function (callback) {
  if (window.kawagarbo) { return callback() }
  if (window.KWJBCallbacks) { return window.KWJBCallbacks.push(callback) }
  window.KWJBCallbacks = [callback]
  var KWJBIframe = document.createElement('iframe')
  KWJBIframe.style.display = 'none'
  KWJBIframe.src = 'https://www.kawagarbo.com/bridge/inject'
  document.documentElement.appendChild(KWJBIframe)
  setTimeout(function () { document.documentElement.removeChild(KWJBIframe) }, 0)
}

kw.invoke = function (obj) {
  kw.setup(function () {
    window.kawagarbo.invoke('invoke', obj)
  })
}

kw.subscribe = function () {
  kw.setup(function () {
    window.kawagarbo.subscribe('subscribe', function (params) {
      alert('subscribe')
    })
  })
}

export { kw }
