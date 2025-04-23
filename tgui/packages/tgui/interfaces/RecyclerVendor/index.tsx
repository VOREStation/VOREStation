import 'tgui/styles/interfaces/Recyclers.scss';

import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Section, Stack } from 'tgui-core/components';

import { AdCarousel } from './AdCarousel';
import { CategoryButton } from './CategorySelection';
import { VendorLogo } from './RecyclerLogo';
import { VendorItem } from './RecyclerVendorItem';

type Data = {
  items: {
    category: string;
    name: string;
    desc: string;
    cost: number;
    ad: string;
    icon: string;
    index: number;
  }[];
  userBalance: number;
  userName: string;
};

export const RecyclerVendor = (props) => {
  const [activeCategory, setActiveCategory] = useState('');
  const { act, data } = useBackend<Data>();

  const { items, userName, userBalance } = data;

  const categories: Record<
    string,
    { name: string; desc: string; cost: number }[]
  > = {};

  for (const item of data.items) {
    if (item.category in categories) {
      categories[item.category].push(item);
    } else {
      categories[item.category] = [item];
    }
  }

  return (
    <Window
      theme="crtsoul"
      title="Recycling Rewards Redemption Vendor"
      width={750}
      height={700}
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {/* top bar */}
            <Section>
              <Section title="RSG Trash 4 Cash Reward Redemption Terminal">
                <VendorLogo />
              </Section>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Stack fill vertical>
                  <Stack.Item>
                    <Section title="Categories" width="100%">
                      {Object.entries(categories).map(([category, items]) => (
                        <Box key={category}>
                          <CategoryButton
                            category={category}
                            action={() => setActiveCategory(category)}
                            activeCategory={activeCategory}
                          />
                        </Box>
                      ))}
                    </Section>
                  </Stack.Item>

                  <Stack.Item>
                    <Section title="User Info">
                      <Box> Welcome {userName}! </Box>
                      <Box> Balance: ♻️{userBalance} </Box>
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item grow>
                <Stack fill vertical>
                  <Stack.Item grow>
                    <Section fill scrollable>
                      {items
                        .filter((item) => item.category === activeCategory)
                        .map(
                          (item: {
                            name: string;
                            desc: string;
                            cost: number;
                            icon: string;
                            ad: string;
                            index: number;
                          }) => (
                            <VendorItem
                              key={item.index}
                              name={item.name}
                              desc={item.desc}
                              advert={item.ad}
                              icon={item.icon}
                              cost={item.cost}
                              index={item.index}
                              action={() =>
                                act('purchase', { index: item.index })
                              }
                            />
                          ),
                        )}
                    </Section>
                  </Stack.Item>
                  <Stack.Item>
                    <Section>
                      Issues? Send a message to our exonet helpline @
                      fc00:4910:49af:6b7f:6613!
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <AdCarousel />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
