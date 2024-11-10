import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Button, Image, Section, Stack } from 'tgui-core/components';

export const IconSection = (props: { module?: string; sprite?: string }) => {
  const { act } = useBackend();
  const { module, sprite } = props;

  return (
    <Section
      title="Sprite"
      fill
      scrollable
      width="40%"
      buttons={
        <Button disabled={!sprite} onClick={() => act('confirm')}>
          Confirm
        </Button>
      }
    >
      {!!sprite && !!module && (
        <>
          <Stack.Item>
            <Image
              src={resolveAsset(module + sprite + '_N')}
              style={{
                width: '100%',
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Image
              src={resolveAsset(module + sprite + '_S')}
              style={{
                width: '100%',
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Image
              src={resolveAsset(module + sprite + '_W')}
              style={{
                width: '100%',
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Image
              src={resolveAsset(module + sprite + '_E')}
              style={{
                width: '100%',
              }}
            />
          </Stack.Item>
        </>
      )}
    </Section>
  );
};
