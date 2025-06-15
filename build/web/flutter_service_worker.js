'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "a65580e1fcd7a9e53c3dfe2855f96048",
"assets/AssetManifest.bin.json": "d523c5d1fb44cf103526333d6c2cde98",
"assets/AssetManifest.json": "3af95f36640acd8251fd57845e467565",
"assets/assets/animation/loading.json": "a470e7c0d59612a5e1e04cf844f47863",
"assets/assets/animation/loading2.json": "c8ecb40c141c362b38b2825368e17bcd",
"assets/assets/animation/loading3.json": "bbf8ee7182dbfe60cba3dfaeb97e3b2a",
"assets/assets/animation/loading4.json": "8c1ac511b3e89e0dbbc9a2d1cff802e1",
"assets/assets/animation/loading5.json": "40531a4a709f2fc9b346c83109d0e26f",
"assets/assets/animation/no_jobs.json": "3622bd897dc040c78c91010b1a40b64b",
"assets/assets/animation/planet.json": "e3042448116764a2d4924ebf08c5463b",
"assets/assets/animation/present.json": "4aeb53d180eea0aace02b6bcee7dc4b2",
"assets/assets/animation/present2.json": "d463f0f38998a63238271a6a17f3a490",
"assets/assets/animation/reveal-loading.json": "b02e2d507c2a6a37a1a0d36208e5d92f",
"assets/assets/animation/robot_armThrow.json": "61c6f5abaffe20199a93d6916e20b1fc",
"assets/assets/animation/robot_playing.json": "40531a4a709f2fc9b346c83109d0e26f",
"assets/assets/animation/robot_running.json": "cdb8467e58ef8c62e1940a2b5ee0ab13",
"assets/assets/animation/rocket_boost.json": "a5a83f7f127a97fc9b02d13aa969104b",
"assets/assets/animation/splash.json": "6436d9328030521ae0d2c29dea296628",
"assets/assets/animation/Tworobot_fun.json": "23a6c00ede0fe38ab65d579f6805c444",
"assets/assets/animation/user.png": "4ebac2364f999d9d35f0c033884fd4e3",
"assets/assets/appleios.png": "2d0b80edd285dbce71dcb60935f688f4",
"assets/assets/avatars/a.jpeg": "9e0942c7e723e32050f5507fc236ffb1",
"assets/assets/avatars/b.jpg": "f1a67ee5f64aa6d9810df63212cbcc99",
"assets/assets/avatars/c.jpg": "8dc2b88c43433df423034c7e102b2c9d",
"assets/assets/avatars/d.jpg": "ede5ea7bc186c4502da2f33ec6be80de",
"assets/assets/avatars/e.jpg": "b947ea2a39fe5d1da5036dbb83024f96",
"assets/assets/battlebot_preview.mp4": "f149b54a6da61b99479655bd54e5f9c3",
"assets/assets/both/onboarding1.json": "23fe3e8455f3c69a37e31675fe4592d1",
"assets/assets/both/onboarding2.json": "c21516960bf568523213410373156bfe",
"assets/assets/both/onboarding3.json": "98a80948c5f1226258f655aa49973044",
"assets/assets/both/onboarding4.json": "2f297076e658667afdf47374aaee609d",
"assets/assets/both/onboarding5.json": "05e14ea1d91796c3f725750f99cd1264",
"assets/assets/characters/images/bighead.png": "90be655d0bd4c130415f97db0a63aeda",
"assets/assets/characters/images/buddi.png": "ade170297ff3f6f5c3f648b0d11d1de7",
"assets/assets/characters/images/chuk.jpeg": "07b485326770d7f873c1dd563bf9aca0",
"assets/assets/characters/images/deepimg-1749109126227.png": "38750e263947bfa5a4cd5bad26bc932d",
"assets/assets/characters/images/DeepImg_20250605090306_889.png": "f8a1a94beb575374131414fb6bcdf5a1",
"assets/assets/characters/images/DeepImg_20250605090352_844.jpeg": "8edc3326db29cff53621f5b7b2a57b28",
"assets/assets/characters/images/diva.jpg": "d7922e892aa4616ddb9f19aeb8ac4b0b",
"assets/assets/characters/images/halo.png": "811563825a8112e827149224f0f91e4b",
"assets/assets/characters/images/hardshot.jpeg": "301afae3ccf14993ecbf2dc5379c7d4d",
"assets/assets/characters/images/jack.jpeg": "c428eeb5ed8492b205f73d1745e3ffd1",
"assets/assets/characters/images/k.png": "53331dbd6480381b1351fb1a0837105c",
"assets/assets/characters/images/lady_mara.jpg": "5b1a728eb97f110ad9155ff10c0af163",
"assets/assets/characters/images/minion.webp": "1751735118331282f4afe0c37f5d035a",
"assets/assets/characters/images/neji.jpeg": "9a08e943ec3be76a257f04cbc7e67b44",
"assets/assets/characters/images/nova.jpg": "abb832d94e52b155af67c2872b3420b9",
"assets/assets/characters/images/silverblade.png": "4e98252fe87994ffe389ad60d18c411d",
"assets/assets/characters/images/smoke.png": "810bd91903a2975316eecb071cf546cd",
"assets/assets/characters/images/snowflake.png": "25dc54399db051224795e48aefab121c",
"assets/assets/characters/images/space_cat.jpeg": "9659fb9c4c97c02d725c87e394e04ae3",
"assets/assets/characters/images/spectra.jpeg": "ce1247d9781cc3bb5dac70337ed5ffc9",
"assets/assets/characters/images/spectra.jpg": "22bfb7495e39f276e08d685182174eb3",
"assets/assets/client/onboarding1.json": "e2aeba3e9251febfc5bdc60dbc3020d4",
"assets/assets/client/onboarding2.json": "c267c2730aadaa0a8080e0dbb21a9dc0",
"assets/assets/client/onboarding3.json": "b6514d86384893a1c162a637d050b86e",
"assets/assets/client/onboarding4.json": "a4ac6c7a531d9ebf30a0a84273a64e9b",
"assets/assets/freelancer/onboarding1.gif": "3bf4c1517beeea41b4c6f93024879a54",
"assets/assets/freelancer/onboarding2.gif": "44fe7db7ba886046f5271344882d78e5",
"assets/assets/freelancer/onboarding2.json": "5ba35f0b56b2d43c194622d009334c45",
"assets/assets/freelancer/onboarding3.gif": "f9734f36355ab464fa616bf94ad21de5",
"assets/assets/freelancer/onboarding3.json": "4d31a760c8e7b157c8c1223d6e23df84",
"assets/assets/freelancer/onboarding4.gif": "8230a52cd6a4b6b471f149286b3f93f7",
"assets/assets/google.png": "87bb3083e2e2f163d80175a343cc1b00",
"assets/assets/logo.png": "53eac97009b711509e4b0aaa5bf99f57",
"assets/assets/robot_img/0.jpg": "251e245bea194cca3c2b8067edc8754b",
"assets/assets/robot_img/1.jpg": "3985933e6df8d1719e537e997ac3d66e",
"assets/assets/robot_img/10.jpg": "22451937bbd1a4be9cecd678e6e323ea",
"assets/assets/robot_img/11.jpg": "22bfb7495e39f276e08d685182174eb3",
"assets/assets/robot_img/2.jpg": "d7ac795f8182ebb6fd3bb870a95efb5a",
"assets/assets/robot_img/3.jpg": "5b0d426ed806bb0239e1f58933f014cd",
"assets/assets/robot_img/4.jpeg": "5cb1fc75f4f286ac5862a69d44450219",
"assets/assets/robot_img/5.jpg": "648debb5a947d64ff02f8ca32a815cd3",
"assets/assets/robot_img/6.jpg": "b977221d905148965e84e19e79190f6a",
"assets/assets/robot_img/7.jpg": "3e1707d41e99f9647762e696a8f688d3",
"assets/assets/robot_img/7.webp": "5ed5078afe133dbc590d9196c8a324b5",
"assets/assets/robot_img/8.jpg": "c222720026cbd64401ac444a409ef851",
"assets/assets/robot_img/81.jpg": "7b337352acc9f2f1878f7530684f8244",
"assets/assets/robot_img/9.jpg": "63a596b0c839432f0ba088b7d42b0e60",
"assets/assets/robot_img/91.jpg": "bf0634fbfac3081953d1d7861b33d2ce",
"assets/assets/robot_img/92.jpg": "47bae1cc605c0671dd37ee58ea4e0064",
"assets/assets/robot_slide/0.png": "03836c57ad7e428a1594c17c9626d4da",
"assets/assets/robot_slide/1.png": "09162fd3009e073655a536d8df18550a",
"assets/assets/robot_slide/2.png": "03668b90ab73b2154fe80f18fa075068",
"assets/assets/robot_slide/3.png": "4ce13d60fe922233802ad4551a8da277",
"assets/assets/robot_slide/4.png": "2d8412144fe15e49d53c0b077469ced0",
"assets/assets/skillfull_intro.gif": "c656187a443a35b326f6010d5868113e",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "27e38aff25a91c503b493a21cc271e15",
"assets/NOTICES": "66138468ed998e95bf800025fdffe195",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b6487389f90d347276eafbd2fe79dd6c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "1785d1b136126674535d29d5f6697add",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"characters/Bighead/intro_audio/bighead0.mp3": "03b44095c7589c4dcfaf664828218568",
"characters/Buddi/intro_audio/buddi0.mp3": "72573a80b3b4612c00ae39b14998003e",
"characters/Chuk/intro_audio/chuk0.mp3": "cd1f24145f39968520abdbcfca2bc697",
"characters/Diva/intro_audio/diva0.mp3": "70812db04e4d56635f0f71263d41a0f8",
"characters/Halo/intro_audio/halo0.wav": "fdd2dd9a59a866ef19ede3516d3cb066",
"characters/Hardshot/intro_audio/hardshot0.wav": "127c3822b7de19ffe7c3ea43c76f63ec",
"characters/Jackhammer/intro_audio/jackhammer0.mp3": "a1bda74f975f610f172a2be15ac98651",
"characters/Kay/intro_audio/kay0.mp3": "46d839525619b4b53c5078423f3328bf",
"characters/Ladymara/intro_audio/ladymara0.mp3": "047b074040a1cbd044af711a4f3ceb5a",
"characters/NejI/intro_audio/neji0.mp3": "c318bf9bea23593e2f11cb180ba16056",
"characters/Nova/intro_audio/nova0.mp3": "3d4c3e26bd9db92f572e7aca3652ce63",
"characters/Nova/main/bg_music.mp3": "33d1e7db7e18bb2bd3b26758b05697f9",
"characters/Nova/main/career/q1.mp3": "7c8f4aa889761e88a382e601c3280e3a",
"characters/Nova/main/career/q2.mp3": "a91e76b84b2bce5be787fe728cc565cf",
"characters/Nova/main/career/q3.mp3": "2521124f7f4d748472abb8a95c903b93",
"characters/Nova/main/fashion_style/q1.mp3": "db11c221828f10405227a42448ada0be",
"characters/Nova/main/fashion_style/q2.mp3": "cf733cc64a44a0e98679a07d56f19990",
"characters/Nova/main/personality/q1.mp3": "6e499ae7f639a8a7e70927213b9bcff6",
"characters/Nova/main/personality/q2.mp3": "b2736623631203913d730c1c9cd72902",
"characters/Nova/main/personality/q3.mp3": "623afe46959fc0f9c190c535bcfa687b",
"characters/Nova/main/personality/q4.mp3": "21ef032f59214d26281435b44cf438bc",
"characters/Nova/main/resume/q1.mp3": "6263f964c435db0864b937fbc647e411",
"characters/Nova/main/resume/q2.mp3": "31573faa185e70cceb7f4bcb62258f65",
"characters/Nova/main/resume/q3.mp3": "dfa1d5d8042d71392b3883d662221ffc",
"characters/Nova/main/youtube_videos/q1.mp3": "ce4bf78d021a900cf26610305d4e926c",
"characters/Nova/main/youtube_videos/q2.mp3": "e88a4987d355a2ecd425f0c39e9e6465",
"characters/Nova/main/youtube_videos/q3.mp3": "7b4cbd421d89aa68409336343746b81a",
"characters/Silverblade/intro_audio/silverblade0.mp3": "c785c535da9e2353b24e634a1d9bbe42",
"characters/Smoke/intro_audio/smoke0.mp3": "cf750c9937359193e1ee2a7c91282079",
"characters/SnoWflake/intro_audio/snowflake0.mp3": "5514fd9efffa69fc8095c47ce1af262f",
"characters/Spacecat/intro_audio/spacecat0.mp3": "bc489433366bd0de8f127a625f90940e",
"favicon.png": "53eac97009b711509e4b0aaa5bf99f57",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "c2bc608596ec33c2e4f94842b0e5f175",
"icons/Icon-192.png": "53eac97009b711509e4b0aaa5bf99f57",
"icons/Icon-512.png": "53eac97009b711509e4b0aaa5bf99f57",
"icons/Icon-maskable-192.png": "53eac97009b711509e4b0aaa5bf99f57",
"icons/Icon-maskable-512.png": "53eac97009b711509e4b0aaa5bf99f57",
"index.html": "5ed287a0c88dca8005e3e672a547d214",
"/": "5ed287a0c88dca8005e3e672a547d214",
"main.dart.js": "2fed03db6edb56f5cb13b2be9efd4c0d",
"manifest.json": "e231ccf1a89ea6833e2ecf8793356f6c",
"version.json": "2158f7e4f0a6b92617776534dbfe9554"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
