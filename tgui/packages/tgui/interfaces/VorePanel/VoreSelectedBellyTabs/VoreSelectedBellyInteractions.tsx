import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import type { selectedData } from '../types';

export const VoreSelectedBellyInteractions = (props: {
  belly: selectedData;
}) => {
  const { act } = useBackend();

  const { belly } = props;
  const { escapable, interacts, autotransfer_enabled, autotransfer } = belly;

  return (
    <Section
      title="Belly Interactions"
      buttons={
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_escapable' })}
          icon={escapable ? 'toggle-on' : 'toggle-off'}
          selected={escapable}
        >
          {escapable ? 'Interactions On' : 'Interactions Off'}
        </Button>
      }
    >
      {escapable ? (
        <LabeledList>
          <LabeledList.Item label="Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance' })
              }
            >
              {interacts.escapechance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Absorbed Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance_absorbed' })
              }
            >
              {interacts.escapechance_absorbed + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Escape Time">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapetime' })
              }
            >
              {interacts.escapetime / 10 + 's'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferchance' })
              }
            >
              {interacts.transferchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferlocation' })
              }
            >
              {interacts.transferlocation
                ? interacts.transferlocation
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Secondary Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferchance_secondary',
                })
              }
            >
              {interacts.transferchance_secondary + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Secondary Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferlocation_secondary',
                })
              }
            >
              {interacts.transferlocation_secondary
                ? interacts.transferlocation_secondary
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Absorb Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_absorbchance' })
              }
            >
              {interacts.absorbchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_digestchance' })
              }
            >
              {interacts.digestchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Belch Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_belchchance' })
              }
            >
              {interacts.belchchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
        </LabeledList>
      ) : (
        'These options only display while interactions are turned on.'
      )}
      <Section
        title="Auto-Transfer Options"
        buttons={
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_autotransfer_enabled' })
            }
            icon={autotransfer_enabled ? 'toggle-on' : 'toggle-off'}
            selected={autotransfer_enabled}
          >
            {autotransfer_enabled
              ? 'Auto-Transfer Enabled'
              : 'Auto-Transfer Disabled'}
          </Button>
        }
      >
        {autotransfer_enabled ? (
          <LabeledList>
            <LabeledList.Item label="Auto-Transfer Time">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_autotransferwait' })
                }
              >
                {autotransfer.autotransferwait / 10 + 's'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Min Amount">
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_min_amount',
                  })
                }
              >
                {autotransfer.autotransfer_min_amount}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Max Amount">
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_max_amount',
                  })
                }
              >
                {autotransfer.autotransfer_max_amount}
              </Button>
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Auto-Transfer Primary Chance">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_autotransferchance' })
                }
              >
                {autotransfer.autotransferchance + '%'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Location">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_autotransferlocation' })
                }
              >
                {autotransfer.autotransferlocation
                  ? autotransfer.autotransferlocation
                  : 'Disabled'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Location Extras">
              {(autotransfer.autotransferextralocation &&
                autotransfer.autotransferextralocation.join(', ')) ||
                ''}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransferextralocation',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Whitelist (Mobs)">
              {(autotransfer.autotransfer_whitelist.length &&
                autotransfer.autotransfer_whitelist.join(', ')) ||
                'Everything'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_whitelist',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Whitelist (Items)">
              {(autotransfer.autotransfer_whitelist_items.length &&
                autotransfer.autotransfer_whitelist_items.join(', ')) ||
                'Everything'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_whitelist_items',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Blacklist (Mobs)">
              {(autotransfer.autotransfer_blacklist.length &&
                autotransfer.autotransfer_blacklist.join(', ')) ||
                'Nothing'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_blacklist',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Blacklist (Items)">
              {(autotransfer.autotransfer_blacklist_items.length &&
                autotransfer.autotransfer_blacklist_items.join(', ')) ||
                'Nothing'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_blacklist_items',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Auto-Transfer Secondary Chance">
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransferchance_secondary',
                  })
                }
              >
                {autotransfer.autotransferchance_secondary + '%'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Location">
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransferlocation_secondary',
                  })
                }
              >
                {autotransfer.autotransferlocation_secondary
                  ? autotransfer.autotransferlocation_secondary
                  : 'Disabled'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Location Extras">
              {(autotransfer.autotransferextralocation_secondary &&
                autotransfer.autotransferextralocation_secondary.join(', ')) ||
                ''}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransferextralocation_secondary',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Whitelist (Mobs)">
              {(autotransfer.autotransfer_secondary_whitelist.length &&
                autotransfer.autotransfer_secondary_whitelist.join(', ')) ||
                'Everything'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_secondary_whitelist',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Whitelist (Items)">
              {(autotransfer.autotransfer_secondary_whitelist_items.length &&
                autotransfer.autotransfer_secondary_whitelist_items.join(
                  ', ',
                )) ||
                'Everything'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_secondary_whitelist_items',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Blacklist (Mobs)">
              {(autotransfer.autotransfer_secondary_blacklist.length &&
                autotransfer.autotransfer_secondary_blacklist.join(', ')) ||
                'Nothing'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_secondary_blacklist',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Secondary Blacklist (Items)">
              {(autotransfer.autotransfer_secondary_blacklist_items.length &&
                autotransfer.autotransfer_secondary_blacklist_items.join(
                  ', ',
                )) ||
                'Nothing'}
              <Button
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_autotransfer_secondary_blacklist_items',
                  })
                }
                ml={1}
                icon="plus"
              />
            </LabeledList.Item>
          </LabeledList>
        ) : (
          'These options only display while Auto-Transfer is enabled.'
        )}
      </Section>
    </Section>
  );
};
