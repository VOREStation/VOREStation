import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosScanner = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    scanner_name,
    using_scanner,
    scanner_enabled,
    check_scanning,
    can_save_scan,
    can_view_scan,
    data_buffer,
  } = data;

  return (
    <NtosWindow
      width={700}
      height={600}
      resizable>
      <NtosWindow.Content>
        <Section title="Scanner">
          {scanner_name && (
            <Section>
              <h2>Attached scanner hardware: {scanner_name}</h2>
              <div class="item">
                <div class="itemLabel">
                  Scanner installation status:
                </div>
                <div class="itemContent">
                  <Button
                    icon="power-off"
                    selected={using_scanner}
                    onClick={() => act("connect_scanner", { "connect_scanner": !using_scanner })}>
                    {using_scanner ? 'Installed' : 'Uninstalled'}
                  </Button>
                </div>
                <div class="itemLabel">
                  Scanner is:
                </div>
                <div class="itemContent">
                  <Button
                    icon="power-off"
                    selected={scanner_enabled}
                    onClick={() => act("PC_toggle_component", { "name": scanner_name })}>
                    {scanner_enabled ? 'Enabled' : 'Disabled'}
                  </Button>
                </div>
                <div class="itemLabel">
                  Scanner Actions:
                </div>
                <div class="itemContent">
                  <Button
                    disabled={!check_scanning}
                    onClick={() => act("scan")}>
                    Perform Scan
                  </Button>
                  <Button
                    disabled={!can_save_scan}
                    onClick={() => act("save")}>
                    Save Scan
                  </Button>
                </div>
              </div>
              {can_view_scan && (
                <Section>
                  <h3>Scan Preview:</h3><br />
                  <div class="block">
                    {data_buffer}
                  </div>
                </Section>
              )}
            </Section>
          ) || (
            <h2>There is no scanner attached.</h2>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
