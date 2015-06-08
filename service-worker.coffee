
version  = '0.0.1'

log = (args...)->
    console.log 'sew', version, args...

log 'service worker', version

importScripts 'serviceworker-cache-polyfill.js'
cache_version = 1
current_caches =
    psl: 'psl-v-' + cache_version

self.addEventListener 'install', (event)->
    log 'install', event

self.addEventListener 'activate', (event)->
    log 'activate', event
    pslcache = caches.open current_caches.psl

self.addEventListener 'fetch', (event)->
    url = event.request.url
    log 'fetch', url

    event.respondWith caches.match(event.request).then (response)->
        console.log 'Matched ', response
        return response || fetch(event.request)

  
    caches.open(current_caches.psl).then (cache)->
        cache.match(event.request).then (response)->
            console.log 'Matched ', response
            return event.respondWith(response) if typeof response isnt 'undefined'

        return
        if true
            if true
                req = event.request.clone()
                console.log 'req clone: ', req
                fr = fetch(req).then (response)->
                    if (!response || response.status != 200 || response.type != 'basic')
                        return response
                    return response.json()
                fr.then (urls)->
                    console.log 'URLS', urls
                    cache.addAll(urls)
                    cache.put('http://localhost:5050/fake.html', new Response('<h1>Fake HTML</h1>'))
                    return

          #  console.log 'Not in cache'
          #  if url.indexOf('app.json') isnt -1 # app.json
          #      req = event.request.clone()
          #      console.log 'app.json'
          #      fr = fetch(req).then (response)->
          #          if (!response || response.status != 200 || response.type != 'basic')
          #              return response
          #          return response.json()
          #      fr.then (urls)->
          #          console.log 'URLS', urls
          #          cache.addAll(urls)
          #          cache.put('http://localhost:5050/fake.html', new Response('<h1>Fake HTML</h1>'))
          #          return
          #  #responseToCache = response.clone()
            #console.log 'responseToCache', responseToCache
            #response


self.addEventListener 'message', (event)->
    console.log 'message', event.data

    caches.open(current_caches.psl).then (cache)->
        cmd = switch event.data.command
            when 'keys' then ()->
                log 'keys'
                cache.keys().then (requests)->
                    urls = requests.map (request)->
                        request.url
                    event.ports[0].postMessage
                        error: null
                        urls: urls.sort()
            when 'add' then ()->
                log 'add', event.data.url
                request = new Request event.data.url
                if event.data.content is null
                    cache.add(request).then ()->
                        event.ports[0].postMessage
                            error: null
                else
                    cache.put(event.data.url, new Response(event.data.content)).then ()->
                        event.ports[0].postMessage
                            error: null
            when 'delete' then ()->
                log 'del', event.data.url
                request = new Request event.data.url
                cache.delete(request).then (success)->
                    event.ports[0].postMessage
                        error: success ? null : 'Item not in cache' + event.data.url
            else ()->
                null
        console.log cmd
        cmd()
