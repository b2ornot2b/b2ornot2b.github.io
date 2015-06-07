
version  = '0.0.1'

log = (args...)->
  console.log 'sew', version, args...

log 'service worker', version

self.addEventListener 'install', (event)->
  log 'install', event

self.addEventListener 'activate', (event)->
  log 'activate', event

self.addEventListener 'fetch', (event)->
  log 'fetch', event

