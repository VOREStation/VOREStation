import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { Data } from './types';

export const CommunicationsConsoleAuth = (props) => {
  const { act, data } = useBackend<Data>();

  const { authenticated, is_ai, esc_status, esc_callable, esc_recallable } =
    data;

  let authReadable;
  if (!authenticated) {
    authReadable = 'Not Logged In';
  } else if (is_ai) {
    authReadable = 'AI';
  } else if (authenticated === 1) {
    authReadable = 'Command';
  } else if (authenticated === 2) {
    authReadable = 'Site Director';
  } else {
    authReadable = 'ERROR: Report This Bug!';
  }

  return (
    <>
      <Section title="Authentication">
        <LabeledList>
          {(is_ai && (
            <LabeledList.Item label="Access Level">AI</LabeledList.Item>
          )) || (
            <LabeledList.Item label="Actions">
              <Button
                icon={authenticated ? 'sign-out-alt' : 'id-card'}
                selected={authenticated}
                onClick={() => act('auth')}
              >
                {authenticated ? 'Log Out (' + authReadable + ')' : 'Log In'}
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section title="Escape Shuttle">
        <LabeledList>
          {!!esc_status && (
            <LabeledList.Item label="Status">{esc_status}</LabeledList.Item>
          )}
          {!!esc_callable && (
            <LabeledList.Item label="Options">
              <Button
                icon="rocket"
                disabled={!authenticated}
                onClick={() => act('callshuttle')}
              >
                Call Shuttle
              </Button>
            </LabeledList.Item>
          )}
          {!!esc_recallable && (
            <LabeledList.Item label="Options">
              <Button
                icon="times"
                disabled={!authenticated || is_ai}
                onClick={() => act('cancelshuttle')}
              >
                Recall Shuttle
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
    </>
  );
};
