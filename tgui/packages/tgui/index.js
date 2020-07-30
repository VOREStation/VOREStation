<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
// Polyfills
import 'core-js/es';
import 'core-js/web/immediate';
import 'core-js/web/queue-microtask';
import 'core-js/web/timers';
import 'regenerator-runtime/runtime';
import './polyfills/html5shiv';
import './polyfills/ie8';
import './polyfills/dom4';
import './polyfills/css-om';
import './polyfills/inferno';

// Themes
import './styles/main.scss';
<<<<<<< HEAD
import './styles/themes/abductor.scss';
import './styles/themes/cardtable.scss';
import './styles/themes/hackerman.scss';
import './styles/themes/malfunction.scss';
import './styles/themes/ntos.scss';
import './styles/themes/paper.scss';
import './styles/themes/retro.scss';
import './styles/themes/syndicate.scss';

import { perf } from 'common/perf';
import { render } from 'inferno';
import { setupHotReloading } from 'tgui-dev-server/link/client';
import { backendUpdate, backendSuspendSuccess, selectBackend, sendMessage } from './backend';
=======
import './styles/themes/cardtable.scss';
import './styles/themes/malfunction.scss';
import './styles/themes/ntos.scss';
import './styles/themes/hackerman.scss';
import './styles/themes/retro.scss';
import './styles/themes/syndicate.scss';

import { loadCSS } from 'fg-loadcss';
import { render } from 'inferno';
import { setupHotReloading } from 'tgui-dev-server/link/client';
import { backendUpdate } from './backend';
import { IS_IE8 } from './byond';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
import { setupDrag } from './drag';
import { logger } from './logging';
import { createStore, StoreProvider } from './store';

<<<<<<< HEAD
perf.mark('inception', window.__inception__);
perf.mark('init');

=======
const enteredBundleAt = Date.now();
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
const store = createStore();
let reactRoot;
let initialRender = true;

const renderLayout = () => {
<<<<<<< HEAD
  perf.mark('render/start');
  const state = store.getState();
  const { suspended, assets } = selectBackend(state);
  // Initial render setup
  if (initialRender) {
    logger.log('initial render', state);
    // Setup dragging
    if (initialRender !== 'recycled') {
      setupDrag();
    }
  }
  // Start rendering
  const { getRoutedComponent } = require('./routes');
  const Component = getRoutedComponent(state);
  const element = (
    <StoreProvider store={store}>
      <Component />
    </StoreProvider>
  );
  if (!reactRoot) {
    reactRoot = document.getElementById('react-root');
  }
  render(element, reactRoot);
  if (suspended) {
    return;
  }
  perf.mark('render/finish');
  // Report rendering time
  if (process.env.NODE_ENV !== 'production') {
    if (initialRender === 'recycled') {
      logger.log('rendered in',
        perf.measure('render/start', 'render/finish'));
    }
    else if (initialRender) {
      logger.debug('serving from:', location.href);
      logger.debug('bundle entered in',
        perf.measure('inception', 'init'));
      logger.debug('initialized in',
        perf.measure('init', 'render/start'));
      logger.log('rendered in',
        perf.measure('render/start', 'render/finish'));
      logger.log('fully loaded in',
        perf.measure('inception', 'render/finish'));
    }
    else {
      logger.debug('rendered in',
        perf.measure('render/start', 'render/finish'));
=======
  // Mark the beginning of the render
  let startedAt;
  if (process.env.NODE_ENV !== 'production') {
    startedAt = Date.now();
  }
  try {
    const state = store.getState();
    // Initial render setup
    if (initialRender) {
      logger.log('initial render', state);
      // Setup dragging
      setupDrag(state);
    }
    // Start rendering
    const { getRoutedComponent } = require('./routes');
    const Component = getRoutedComponent(state);
    const element = (
      <StoreProvider store={store}>
        <Component />
      </StoreProvider>
    );
    if (!reactRoot) {
      reactRoot = document.getElementById('react-root');
    }
    render(element, reactRoot);
  }
  catch (err) {
    logger.error('rendering error', err);
    throw err;
  }
  // Report rendering time
  if (process.env.NODE_ENV !== 'production') {
    const finishedAt = Date.now();
    if (initialRender) {
      logger.debug('serving from:', location.href);
      logger.debug('bundle entered in', timeDiff(
        window.__inception__, enteredBundleAt));
      logger.debug('initialized in', timeDiff(
        enteredBundleAt, startedAt));
      logger.log('rendered in', timeDiff(
        startedAt, finishedAt));
      logger.log('fully loaded in', timeDiff(
        window.__inception__, finishedAt));
    }
    else {
      logger.debug('rendered in', timeDiff(startedAt, finishedAt));
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    }
  }
  if (initialRender) {
    initialRender = false;
  }
};

<<<<<<< HEAD
=======
const timeDiff = (startedAt, finishedAt) => {
  const diff = finishedAt - startedAt;
  const diffFrames = (diff / 16.6667).toFixed(2);
  return `${diff}ms (${diffFrames} frames)`;
};

>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
// Parse JSON and report all abnormal JSON strings coming from BYOND
const parseStateJson = json => {
  let reviver = (key, value) => {
    if (typeof value === 'object' && value !== null) {
      if (value.__number__) {
        return parseFloat(value.__number__);
      }
    }
    return value;
  };
  // IE8: No reviver for you!
  // See: https://stackoverflow.com/questions/1288962
<<<<<<< HEAD
  if (Byond.IS_LTE_IE8) {
=======
  if (IS_IE8) {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    reviver = undefined;
  }
  try {
    return JSON.parse(json, reviver);
  }
  catch (err) {
    logger.log(err);
    logger.log('What we got:', json);
    const msg = err && err.message;
    throw new Error('JSON parsing error: ' + msg);
  }
};

const setupApp = () => {
  // Subscribe for redux state updates
  store.subscribe(() => {
    renderLayout();
  });

  // Subscribe for bankend updates
<<<<<<< HEAD
  window.update = messageJson => {
    const { suspended } = selectBackend(store.getState());
    // NOTE: messageJson can be an object only if called manually from console.
    // This is useful for debugging tgui in external browsers, like Chrome.
    const message = typeof messageJson === 'string'
      ? parseStateJson(messageJson)
      : messageJson;
    logger.debug(`received message '${message?.type}'`);
    const { type, payload } = message;
    if (type === 'update') {
      window.__ref__ = payload.config.ref;
      if (suspended) {
        logger.log('resuming');
        initialRender = 'recycled';
      }
      // Backend update dispatches a store action
      store.dispatch(backendUpdate(payload));
      return;
    }
    if (type === 'suspend') {
      store.dispatch(backendSuspendSuccess());
      return;
    }
    if (type === 'ping') {
      sendMessage({
        type: 'pingReply',
      });
      return;
    }
    // Pass the message directly to the store
    store.dispatch(message);
=======
  window.update = stateJson => {
    // NOTE: stateJson can be an object only if called manually from console.
    // This is useful for debugging tgui in external browsers, like Chrome.
    const state = typeof stateJson === 'string'
      ? parseStateJson(stateJson)
      : stateJson;
    // Backend update dispatches a store action
    store.dispatch(backendUpdate(state));
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  };

  // Enable hot module reloading
  if (module.hot) {
    setupHotReloading();
    module.hot.accept([
      './components',
      './layouts',
      './routes',
    ], () => {
      renderLayout();
    });
  }

  // Process the early update queue
  while (true) {
    let stateJson = window.__updateQueue__.shift();
    if (!stateJson) {
      break;
    }
    window.update(stateJson);
  }
<<<<<<< HEAD
};

// Setup a fatal error reporter
window.__logger__ = {
  fatal: (error, stack) => {
    // Get last state for debugging purposes
    const backendState = selectBackend(store.getState());
    const reportedState = {
      config: backendState.config,
      suspended: backendState.suspended,
      suspending: backendState.suspending,
    };
    // Send to development server
    logger.log('FatalError:', error || stack);
    logger.log('State:', reportedState);
    // Append this data to the stack
    stack += '\nState: ' + JSON.stringify(reportedState);
    // Return an updated stack
    return stack;
  },
=======

  // Dynamically load font-awesome from browser's cache
  loadCSS('font-awesome.css');
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', setupApp);
}
else {
  setupApp();
}
