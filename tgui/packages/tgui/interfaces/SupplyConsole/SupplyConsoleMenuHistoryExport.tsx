import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { Data } from './types';

export const SupplyConsoleMenuHistoryExport = (props) => {
  const { act, data } = useBackend<Data>();
  const { receipts, order_auth } = data;

  if (!receipts.length) {
    return <Section>No receipts found.</Section>;
  }

  return (
    <Section>
      {receipts.map((r, ri) => (
        <Section key={ri}>
          <LabeledList>
            {r.title.map((title) => (
              <LabeledList.Item
                label={title.field}
                key={title.field}
                buttons={
                  order_auth ? (
                    <Button
                      icon="pen"
                      onClick={() =>
                        act('export_edit', {
                          ref: r.ref,
                          edit: title.field,
                          default: title.entry,
                        })
                      }
                    >
                      Edit
                    </Button>
                  ) : (
                    ''
                  )
                }
              >
                {title.entry}
              </LabeledList.Item>
            ))}
            {r.error ? (
              <LabeledList.Item labelColor="red" label="Error">
                {r.error}
              </LabeledList.Item>
            ) : (
              r.contents.map((item, i) => (
                <LabeledList.Item
                  label={item.object}
                  key={i}
                  buttons={
                    order_auth ? (
                      <>
                        <Button
                          icon="pen"
                          onClick={() =>
                            act('export_edit_field', {
                              ref: r.ref,
                              index: i + 1,
                              edit: 'meow',
                              default: item.object,
                            })
                          }
                        >
                          Edit
                        </Button>
                        <Button
                          icon="trash"
                          color="red"
                          onClick={() =>
                            act('export_delete_field', {
                              ref: r.ref,
                              index: i + 1,
                            })
                          }
                        >
                          Delete
                        </Button>
                      </>
                    ) : (
                      ''
                    )
                  }
                >
                  {item.quantity}x -&gt; {item.value} points
                </LabeledList.Item>
              ))
            )}
          </LabeledList>
          {order_auth ? (
            <>
              <Button
                mt={1}
                icon="plus"
                onClick={() => act('export_add_field', { ref: r.ref })}
              >
                Add Item To Record
              </Button>
              <Button
                icon="trash"
                onClick={() => act('export_delete', { ref: r.ref })}
              >
                Delete Record
              </Button>
            </>
          ) : (
            ''
          )}
        </Section>
      ))}
    </Section>
  );
};
