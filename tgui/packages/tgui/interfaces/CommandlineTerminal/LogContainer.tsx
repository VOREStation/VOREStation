import 'tgui/styles/components/CommandlineComponents.scss';

import React, {
  useCallback,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';
import { Box, Section, Tabs } from 'tgui-core/components';

import { LogEntry } from './LogEntry';
import { type Log } from './types';
export const LogContainer = (props: { logs: Log[]; source: string }) => {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [isAtBottom, setIsAtBottom] = useState(true);

  // jank!
  const handleScroll = useCallback(() => {
    const el = scrollRef.current;
    if (!el) return;
    const { scrollTop, scrollHeight, clientHeight } = el;
    setIsAtBottom(scrollHeight - scrollTop - clientHeight < 5);
  }, []);

  useEffect(() => {
    const el = scrollRef.current;
    if (el) el.scrollTop = el.scrollHeight;
  }, []);

  useLayoutEffect(() => {
    const el = scrollRef.current;
    if (el && isAtBottom) {
      el.scrollTop = el.scrollHeight;
    }
  }, [props.logs, isAtBottom]);

  const [tab, setTab] = useState('logs');

  return (
    <Box className="commandline_log_bg" id="commandline_logcontainer">
      <Tabs>
        <Tabs.Tab
          id="logs"
          onClick={() => setTab('logs')}
          selected={tab === 'logs'}
        >
          Local Logs
        </Tabs.Tab>
        <Tabs.Tab
          id="global"
          onClick={() => setTab('packet')}
          selected={tab === 'packet'}
        >
          Packet Sniffer
        </Tabs.Tab>
      </Tabs>
      <Section scrollable fill ref={scrollRef} onScroll={handleScroll}>
        {props.logs.map((entry, entryIndex) =>
          Object.entries(entry.logs)
            .filter(
              ([nodeId, [type, message]]) =>
                tab === 'packet' || entry.source === props.source,
            )
            .map(([nodeId, [type, message]], logIndex) => (
              <LogEntry
                key={`log-${entryIndex}-${logIndex}`}
                command={entry.command}
                owner={entry.owner}
                warning={type === 'error'}
                entry={message}
                timestamp={entry.station_time}
                source={entry.source}
              />
            )),
        )}
      </Section>
    </Box>
  );
};
