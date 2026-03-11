importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

// Initialize Firebase in Service Worker
firebase.initializeApp({
  apiKey: "AIzaSyCmDFLzf2pA20q8G31qvlQ5LEowlgn0n5s",
  authDomain: "rizqmart-486b8.firebaseapp.com",
  projectId: "rizqmart-486b8",
  storageBucket: "rizqmart-486b8.firebasestorage.app",
  messagingSenderId: "570019429913",
  appId: "1:570019429913:web:269440b2234eddcb623488",
  measurementId: "G-7L6Y3YRF9C"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/app-icon-192x192.png',
    badge: '/icons/badge-72x72.png',
    click_action: payload.notification.clickAction || '/',
    tag: 'rizqmart-admin-msg',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', function (event) {
  console.log('[firebase-messaging-sw.js] Notification click received.');
  event.notification.close();

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function (clientList) {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url === '/' && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});