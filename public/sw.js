!function(){var e=["js/bundle.js","css/bundle.css","styles.css","/","/manifest.json"];self.addEventListener("fetch",function(e){e.respondWith(self.caches.match(e.request).then(function(t){return t||self.fetch(e.request)}))}),self.addEventListener("install",function(t){t.waitUntil(self.caches.open("1.0.0").then(function(t){return t.addAll(e)}))}),self.addEventListener("activate",function(e){e.waitUntil(self.caches.keys().then(function(e){return Promise.all(e.map(function(t,n){if("1.0.0"!==e[n])return self.caches.delete(e[n])}))}))})}();
//# sourceMappingURL=bankai-service-worker.js.map
