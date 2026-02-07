let webSocket;
let authKey;
let lastCall;

const reactRoot = document.getElementById('react-root');
if (reactRoot) {
  reactRoot.innerHTML =
    "<h1>You shouldn't see this window, update your skin.</h1>";
}

Byond.subscribeTo('estop', () => {
  if (webSocket) {
    webSocket.close();
  } else {
    Byond.sendMessage('disconnected');
  }
});

Byond.subscribeTo('connect', (data) => {
  if (webSocket) {
    webSocket.close();
  }
  webSocket = new WebSocket(`ws://localhost:${data.port}`);
  webSocket.sendJson = (data) => {
    webSocket.send(JSON.stringify(data));
  };
  authKey = JSON.parse(window.hubStorage.getItem('virgo-shocker-authkey'));
  webSocket.onopen = (ev) => {
    Byond.sendMessage('connected');
  };
  webSocket.onerror = (ev) => {
    Byond.sendMessage('error', ev);
  };
  webSocket.onclose = (ev) => {
    Byond.sendMessage('disconnected');
  };
  webSocket.onmessage = (ev) => {
    Byond.sendMessage('incomingMessage', { data: ev.data, lastCall });
  };
});

Byond.subscribeTo('enumerateShockers', () => {
  if (!webSocket) {
    return;
  }

  lastCall = 'get_devices';
  webSocket.sendJson({
    cmd: 'get_devices',
    auth_key: authKey,
  });
});

// data: {
//   "intensity": 10, // 1 - 100 - int
//   "duration": 1, // 0.1 - 15 - float
//   "shocker_ids": [], // [] - List of shocker ids
//   "warning": false, // true, false - will send a vibrate with the same intensity and duration
// },
Byond.subscribeTo('shock', (data) => {
  if (!webSocket) {
    return;
  }

  lastCall = 'operate';
  webSocket.sendJson({
    cmd: 'operate',
    value: {
      intensity: data.intensity, // 1 - 100 - int
      duration: data.duration, // 0.1 - 15 - float
      shocker_option: 'all', // all, random
      action: 'shock', // shock, vibrate, beep, end
      shocker_ids: data.shocker_ids, // [] - List of shocker ids
      device_ids: [], // [] - list of pishock client ids, if one of these is provided it will activate all shockers associated with it
      warning: data.warning, // true, false - will send a vibrate with the same intensity and duration
      held: false, // true, false - for continuous commands
    },
    auth_key: authKey,
  });
});
