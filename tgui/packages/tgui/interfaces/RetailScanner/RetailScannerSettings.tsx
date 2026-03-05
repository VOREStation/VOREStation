import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import type { Data } from './types';

export const RetailScannerSettings = (model) => {
  const { act, data } = useBackend<Data>();
  const { locked, linked_account } = data;
  const [accountName, setAccountName] = useState('');
  const [accountPin, setAccountPin] = useState('');
  const [orderPurpose, setOrderPurpose] = useState('');
  const [orderAmount, setOrderAmount] = useState(1);
  const [orderPrice, setOrderPrice] = useState(0);

  return (
    <Section
      title="Settings"
      fill
      buttons={
        <Button
          color={locked ? 'red' : 'green'}
          onClick={() => act('toggle_lock')}
        >{`${locked ? 'L' : 'Unl'}ocked`}</Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Linked Account">
          <Stack.Item>{linked_account}</Stack.Item>
        </LabeledList.Item>
        {!locked && (
          <>
            <LabeledList.Item label="Link Account">
              <Stack vertical fill>
                <Stack.Item>
                  <Stack>
                    <Stack.Item width="113px">Accoount Number:</Stack.Item>
                    <Stack.Item>
                      <Input
                        fluid
                        value={accountName}
                        onBlur={setAccountName}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item width="113px">Account Pin:</Stack.Item>
                    <Stack.Item>
                      <Input fluid value={accountPin} onBlur={setAccountPin} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!accountName || !accountPin}
                    color={!accountName || !accountPin ? 'red' : 'green'}
                    tooltip="Link station thaler account."
                    onClick={() => {
                      act('link_account', {
                        name: accountName,
                        pin: accountPin,
                      });
                      setAccountName('');
                      setAccountPin('');
                    }}
                  >
                    Link
                  </Button>
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Custom Order">
              <Stack vertical fill>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>Order Purpose:</Stack.Item>
                    <Stack.Item>
                      <Input
                        fluid
                        maxLength={200}
                        value={orderPurpose}
                        onBlur={setOrderPurpose}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>Amount:</Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        width="20px"
                        minValue={1}
                        maxValue={20}
                        unit="x"
                        value={orderAmount}
                        onChange={setOrderAmount}
                      />
                    </Stack.Item>
                    <Stack.Item>Unit Price:</Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        width="100px"
                        minValue={0}
                        unit="₮"
                        value={orderPrice}
                        onChange={setOrderPrice}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!orderPurpose}
                    onClick={() => {
                      act('custom_order', {
                        purpose: orderPurpose,
                        amount: orderAmount,
                        price: orderPrice,
                      });
                      setOrderPurpose('');
                      setOrderAmount(1);
                      setOrderPrice(0);
                    }}
                  >
                    Create Order
                  </Button>
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};
