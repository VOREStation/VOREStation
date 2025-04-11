import { useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
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
  adverts: string[];
  userBalance: number;
  userName: string;
};

export const RecyclerVendor = (props) => {
  const [activeCategory, setActiveCategory] = useState('');
  const { act, data } = useBackend<Data>();

  const { items, userName, userBalance, adverts } = data;

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

  // static advertisement list. 1991 is canon I can provide proof if needed

  return (
    <Window
      theme="crtsoul"
      title="Recycling Rewards Redemption Vendor"
      width={750}
      height={600}
    >
      <style>
        {`
          .carousel {
            display: flex;
            overflow: hidden;
            position: relative;
            white-space: nowrap;
          }

          .carousel-track {
            display: flex;
            animation: slide 220s linear infinite;
          }

          .carousel-box {
            display: inline-block;
            width: auto;
            height: 40px;
            margin: 0 10px;
            border-style: dashed;
            border-width: 1px;
            border-color: 00ff00;
            text-align: center;
            line-height: 40px;
          }

          @keyframes slide {
            0% {
              transform: translateX(0);
            }
            100% {
              transform: translateX(-50%);
            }
          }
        `}
      </style>

      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {/* top bar */}
            <Section>
              <Section title="RSG Trash 4 Cash Reward Redemption Terminal">
                <Stack align="center" justify="center" height="20%">
                  <Stack.Item>
                    <Box as="logo-container">
                      <Image
                        src={resolveAsset('recycle.gif')}
                        height="48px"
                        style={{
                          marginRight: '-10px',
                        }}
                      />
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box as="logo-container">
                      <Image src={resolveAsset('logo.png')} />
                    </Box>
                  </Stack.Item>
                </Stack>
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
                        <Box key={category} width="100%">
                          <Button
                            key={category}
                            onClick={() => setActiveCategory(category)}
                            disabled={activeCategory === category}
                            style={{
                              opacity: activeCategory === category ? 0.5 : 1,
                              pointerEvents:
                                activeCategory === category ? 'none' : 'auto',
                            }}
                          >
                            <h5>{category}</h5>
                          </Button>
                        </Box>
                      ))}
                    </Section>
                  </Stack.Item>

                  <Stack.Item>
                    <Section title="User Info">
                      <p>Welcome {userName}!</p>
                      <p>Balance: ♻️{userBalance}</p>
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
                            <Box
                              key={item.name}
                              style={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'space-between',
                                marginBottom: '10px',
                                padding: '10px',
                                border: '1px solid #ccc',
                                borderRadius: '5px',
                                borderColor: 'lime',
                                minHeight: '100px',
                              }}
                            >
                              <Box
                                className={classes([
                                  'MaintVendor32x32',
                                  item.icon,
                                ])}
                                style={{
                                  display: 'inline-block',
                                  transform: 'scale(2.5)',
                                  marginRight: '35px',
                                  marginLeft: '25px',
                                  minWidth: '32px',
                                }}
                              />
                              <Box style={{ flex: 1, marginRight: '10px' }}>
                                <h2>{item.name}</h2>
                                <p style={{ margin: 0, fontSize: '0.9em' }}>
                                  {item.desc}
                                </p>
                              </Box>
                              <Box
                                style={{
                                  display: 'inline-block',
                                  animation: 'bounce 0.5s infinite',
                                  transform: 'rotate(30deg)',
                                  marginRight: '10px',
                                }}
                              >
                                <b>
                                  <i>{item.ad}</i>
                                </b>
                              </Box>
                              <Button
                                tooltip={`${item.desc}`}
                                style={{ whiteSpace: 'nowrap' }}
                                onClick={() =>
                                  act('purchase', { index: item.index })
                                }
                              >
                                Redeem - ♻️{item.cost}
                              </Button>
                              <style>
                                {`
                                @keyframes bounce {
                                0%, 100% {
                                transform: scale(0.95) rotate(3deg);
                                }
                                50% {
                                transform: scale(1) rotate(5deg);
                                }
                                }
                                `}
                              </style>
                            </Box>
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
            <Section>
              <div className="carousel">
                <div className="carousel-track">
                  {/* shitty adverts */}
                  {adverts.concat(adverts).map((item, index) => (
                    <div key={index} className="carousel-box">
                      {item}
                    </div>
                  ))}
                </div>
              </div>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
