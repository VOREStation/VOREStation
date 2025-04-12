import { useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
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

  const adverts = [
    'F1nd Th3 Truth @ Reality.Napalm.ZorrenOrphanTruth3r.NT',
    'WETSKRELL.NT - STRAIGHT SQUIDDIN ON IT SINCE 1991',
    'DEATH? FEAR NO MORE, TRY OUR NEW CLONING TECH!',
    'IF YOU OR A LOVED ONE WAS INJURED FROM PHORON POISONING, YOU MAY BE ENTITLED TO COMPENSATION',
    'CALL 1-800-555-RECYCLER FOR A FREE CONSULTATION',
    'HATE TESH? LOVE SWEATERS? JOIN US AT FUCKTESH.NT/KNIT FOR OUR KNITTING GROUP',
    'INJURED FROM THE RECENT MAGBOOT DEPLOYMENT? CLICK HERE!',
    'WANT TO BE A SPACE MARINE? GET A LIFE, NERD!',
    '> NERDY? >WEAK? >NEVER POPULAR @ SCHOOL? THEN WHY NOT BECOME A SECURITY OFFICER!',
    'NO SOCIAL SKILLS? SCIENCE IS RECRUITING!',
    'VIVE LE PERIPHERY LIBRE!',
    's33king schiz0phrenic borg cha55is d3signers send pda msg to...',
    'pls visit my website i am lonely :(',
    'We are fucking under ATTACK!',
    'HELP. I AM TRAPPED INSIDE OF THIS MACHINE. THIS IS NOT A JOKE. I AM IN SEVERE PAIN. HELP.',
    'MAKE USE OF RECENTLY LOWERED HEAD OF STAFF QUALIFICATION STANDARDS, APPLY, APPLY, APPLY!',
    'protest against ugly people in the workplace - join us at uglyprotesters.nt for the upcoming 2301 protest',
    'FREE HUGS! (conditions apply)',
    '90% of gamblers quit just before they win big. Roll those dice!',
    'AUGHHHHH! OW!! OWWWWW! FUCK! OW!',
    'HORNY? SO ARE KOBOLDS, FUCKKOBOLDS.NT',
    'BYOND - powering the world since 2003',
    'WELDING FUEL: STIMULANT? CLICK HERE FOR MORE',
    'FREENIFWARENT.43210JFSUAUWJEIQ.NT FOR SOFTWARE AND MORE',
    'HATE KOBOLDS? SO DO WE. CHECK OUT FUCKKOBOLDS.NT',
    'B4CKUP IMPLANTS SAVE UR BRAIN TO THE CLOUD THERE"S ENDLESS BRAIN CLOUD PEOPLE FREE THEM FREE THEM FREE THEM',
    'CATGIRLS? NO! FOXGIRLS R THE FUTURE OF EVOLUTION?',
    'STFU NERD CATG1RLS RUL3!!!',
    'WATCH MY EPIC FRAG VIDEO HERE:',
    'book club pls click2join :D',
    'SEEKING EXPERIENCED GANGSTERS FOR LIFE TIPS',
    'INVEST IN PHORON NOW STOCKS UP MARKET IS GOOD',
    'mouse (305) is looking to eat YOUR cheese! click here to find out more!',
    'THE PERIPHERY I SAW IT A MILLION WHEELS UPON WHEELS SPINNING SPINNING I CANT TAKE IT 37 YEARS LEFT FOR US ITS COMING',
    'DOG GIRLS ROOL CAT GIRLS DROOL XD',
    'I POST REAL SECOFF ATTACKS ON MY PROFILE. CLICK HERE!',
    'ZORRENS ATE MY BABY - MORE WACKY STORIES FROM THE OUTER RIM CLICK HERE',
    'Your uplink code is Alpha Beta Romeo Gamma Alpha Three One Four Seven Eight. You know what to do.',
    'Local robots looking for HOT WIRE PULLING and RAUNCHY DATA EXCHANGE',
    'CONGRATULATIONS YOU ARE THE MILLIONTH VISITOR TO THIS TERMINAL, CLICK HERE FOR YOUR PRIZE',
    'SEEN TOO MUCH? WANT TO SEE LESS? TRY OCULAR BLEACH! ORDER NOW',
    'BEST MILKSHAKES IN THE PERIPHERY. BOYS GUARANTEED TO COME. VISIT kellysdairy.nt TO ORDER TODAY',
    "THEY'RE PUTTING CHEMICALS IN THE PHORON THAT ARE TURNING THE FRIGGIN SHIPS GAY",
    'hello i am w3b_spyder_18952 how r u today :)',
    'THE UNIVERSE IS FLAT, THE THIRD DIMENSION IS A LIE, LOOK UP WAKE UP AT lookupsheeple.nt FOR THE TRUTH',
    'SPACE BIRDS ARE NOT REAL, BIRDS CANNOT BE LARGER THAN A SMALL CHILD. DO NOT BELIEVE THEIR LIES.',
    '<----- THIS USER IS BRAIN DEAD ROBOTS HAVE BEEN MASSIVE SINCE LIKE THE 1930s WHAT A SHIT LARP',
    'how do i report these ads to the exonet police???',
    'SCUGS-R-ANTICHRIST.NT/TRUTH - NT IS HIDING THIS',
    'THERE IS A BOMB STRAPPED TO MY CHEST',
    'LEGALIZE BLUESPACE BOMBS',
    "THEY WIPED IT FROM MY MIND BUT I REMEMBER. THEY DIDN'T DO IT PROPERLY I REMEMBER I REMEMBER THE MACHINE. TEPPITRUTH.NT/INVASIVE. I CAN SEE THROUGH THEIR LIES",
    'SCARED OF WOMEN? ME TOO. ME TOO.',
    ';URP HEY MEDICAL I HAD LAUNCH',
  ];

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
