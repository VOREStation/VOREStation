import { BooleanLike } from 'common/react';

import { useBackend } from '../../../backend';
import { Button, Flex, Section } from '../../../components';
import { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesMechanical = (props: {
  show_pictures: BooleanLike;
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { show_pictures, preferences } = props;

  return (
    <Section
      title="Mechanical Preferences"
      buttons={
        <Button
          icon="eye"
          selected={show_pictures}
          onClick={() => act('show_pictures')}
        >
          Contents Preference: {show_pictures ? 'Show Pictures' : 'Show List'}
        </Button>
      }
    >
      <Flex spacing={1} wrap="wrap" justify="center">
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.digestion} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.absorbable} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.devour} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.mobvore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.feed} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.healbelly}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.dropnom_prey} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.dropnom_pred} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_drop_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_slip_vore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.toggle_stumble_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_throw_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_food_vore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.toggle_digest_pain} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.inbelly_spawning} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.noisy} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.resize} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.steppref}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.vore_fx}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem
            spec={preferences.remains}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.pickuppref}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.spontaneous_tf} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <Button fluid onClick={() => act('switch_selective_mode_pref')}>
            Selective Mode Preference
          </Button>
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.mind_transfer} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.eating_privacy_global} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.allow_mimicry} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
