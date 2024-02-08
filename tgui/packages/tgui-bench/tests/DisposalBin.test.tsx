import { backendUpdate, setGlobalStore } from 'tgui/backend';
import { DisposalBin } from 'tgui/interfaces/DisposalBin';
import { createRenderer } from 'tgui/renderer';
import { configureStore } from 'tgui/store';

const store = configureStore({ sideEffects: false });

const renderUi = createRenderer((dataJson: string) => {
  setGlobalStore(store);

  store.dispatch(
    backendUpdate({
      data: Byond.parseJson(dataJson),
    })
  );
  return <DisposalBin />;
});

export const data = JSON.stringify({
  flush: 0,
  full_pressure: 1,
  pressure_charging: 0,
  panel_open: 0,
  per: 1,
  isai: 0,
});

export const Default = () => renderUi(data);
