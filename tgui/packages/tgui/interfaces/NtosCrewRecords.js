import { useBackend } from "../backend";
import { Box, Button, Flex, LabeledList, Section } from "../components";
import { NtosWindow } from "../layouts";

export const NtosCrewRecords = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    message,
    uid,
    pic_edit,
    fields = [],
    creation,
    dnasearch,
    fingersearch,
    all_records = [],
  } = data;

  return (
    <NtosWindow width={600} height={500} resizable>
      <NtosWindow.Content>
        <Section>
          {message && (
            <Button
              content="X"
              onClick={() => act("PRG_clear_message")}>
              {message}
            </Button>
          )}
          {uid && (
            <Section>
              <Button
                content="BACK"
                onClick={() => act("PRG_clear_active")} />
              <Button
                content="PRINT"
                onClick={() => act("PRG_print_active")} />
              <div class="statusDisplay">
                <div>
                  <h3>GENERIC INFORMATION</h3>
                  <div>
                    <img src="front_{{uid}}.png" width="128px" />
                    <img src="side_{{uid}}.png" width="128px" />
                  </div>
                </div>
                {pic_edit && (
                  <div class="item">
                    <div class="itemLabel">&nbsp</div>
                    <div class="itemBody">
                      <Button
                        icon="pencil"
                        content="Edit Front"
                        onClick={() => act("PRG_edit_photo_front")} />
                      <Button
                        icon="pencil"
                        content="Edit Side"
                        onClick={() => act("PRG_edit_photo_side")} />
                    </div>
                  </div>
                )}
                {fields.length && fields.map(field => (
                  <Flex key={field.ID}>
                    {field.access && (
                      <div class="item">
                        {field.access_edit && (
                          <div class="itemLabel">
                            <Button
                              icon="pencil"
                              content={field.name}
                              onClick={() => act("PRG_edit_field", { field_id: field.ID })} />
                          </div>
                        ) || (
                          <div class="itemLabel">{field.name}</div>
                        )}
                        {field.needs_big_box && (
                          <div>
                            {field.value}
                          </div>
                        ) || (
                          <div class="itemBody">{field.value}</div>
                        )}
                      </div>
                    )}
                  </Flex>
                ))}
              </div>
            </Section>
          ) || (
            <Section>
              {creation && (
                <Button
                  icon="document"
                  content="New Record"
                  onClick={() => act("PRG_new_record")} />
              )}
              <Button
                icon="search"
                content="Name Search"
                onClick={() => act("PRG_search", { type: 'Name' })} />
              {dnasearch && (
                <Button
                  icon="search"
                  content="DNA Search"
                  onClick={() => act("PRG_search", { type: 'DNA' })} />
              )}
              {fingersearch && (
                <Button
                  icon="search"
                  content="Fingerprint Search"
                  onClick={() => act("PRG_search", { type: 'Fingerprint' })} />
              )}
              <br /><br />
              <h2>Available records:</h2>
              <table>
                <tr><td>Name</td><th>Position</th><th>Rank</th></tr>
                {all_records.length && all_records.map(record => (
                  <tr class="candystripe" key={record.id}>
                    <td>
                      <Button
                        icon="search"
                        content={record.name}
                        onClick={() => act("PRG_set_active", { record_id: record.id })} />
                    </td>
                    <td>{record.rank}</td>
                    <td>{record.milrank}</td>
                  </tr>
                ))}
              </table>
            </Section>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
