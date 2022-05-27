import { useBackend } from "../backend";
import { Box, Button, Flex, LabeledList, Section } from "../components";
import { NtosWindow } from "../layouts";

export const NtosReports = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    prog_state,
    view_only,
    report_data = [],
    printer,
    reports = [],
  } = data;

  return (
    <NtosWindow width={600} height={500} resizable>
      <NtosWindow.Content>
        <Section>
          {prog_state === 1 && (
            <Section title="Report Editor">
              <div class="item">
                <Button
                  enabled={printer}
                  content="Load Report"
                  onClick={() => act("load", { warning: (data.report_data && !data.view_only) })} />
                <Button
                  enabled={(data.report_data && !data.view_only)}
                  content="Save Report"
                  onClick={() => act("save", { save_as: 0 })} />
                <Button
                  enabled={(data.report_data && !data.view_only)}
                  content="Save Copy"
                  onClick={() => act("save", { save_as: 1 })} />
                <Button
                  enabled={printer}
                  content="New Report"
                  onClick={() => act("download", { warning: (data.report_data && !data.view_only) })} />
              </div>
              <center><h2>Report Editor</h2></center>
              {report_data && (
                <Box>
                  {report_data.length && report_data.map(data => (
                    <Box key={data.uid}>
                      <h3>{data.name}</h3>
                      {data.fields.length && data.fields.map(field => (
                        <Flex key={field.ID}>
                          <div class="item">
                            {field.ignore_value && (
                              <Flex>
                                {field.name}
                              </Flex>
                            ) || (
                              <Flex>
                                <div class="itemLabel">
                                  {field.can_edit && field.access_edit && !view_only && (
                                    <Button
                                      icon="pencil"
                                      onClick={() => act("edit", { ID: field.ID })} />
                                  )}
                                  {field.name}:
                                </div>
                                {field.access && (
                                  <div class="itemContent">
                                    {field.needs_big_box && (
                                      <div class="block">
                                        {field.value}
                                      </div>
                                    ) || (
                                      <div class="statusDisplayComm">
                                        {field.value}
                                      </div>
                                    )}
                                  </div>
                                ) || (
                                  <div class="itemContent">Access Denied.</div>
                                )}
                              </Flex>
                            )}
                          </div>
                        </Flex>
                      ))}
                      <div class="item">
                        <div class="itemContent">
                          <Button
                            enabled={printer}
                            content="Print Copy"
                            onClick={() => act("print", { print_mode: 0 })} />
                          <Button
                            enabled={printer}
                            content="Print With Fields"
                            onClick={() => act("print", { print_mode: 1 })} />
                          <Button
                            content="Export to Text"
                            onClick={() => act("export")} />
                        </div>
                      </div>
                      <Flex>
                        {!view_only && (
                          <div class="item">
                            <div class="itemContent">
                              <Button
                                enabled={data.access_edit}
                                content="Submit Report"
                                onClick={() => act("submit")} />
                              <Button
                                enabled={data.access_edit}
                                content="Discard Changes"
                                onClick={() => act("discard", { warning: 1 })} />
                            </div>
                          </div>
                        ) || (
                          <div class="item">
                            <div class="itemContent">
                              <Button
                                content="Close Report"
                                onClick={() => act("discard")} />
                            </div>
                          </div>
                        )}
                      </Flex>
                    </Box>
                  ))}
                </Box>
              )}
            </Section>
          )}
          {prog_state === 2 && (
            <Section title="Report Download">
              <Button
                content="Back"
                onClick={() => act("home")} />
              <center><h2>Report Download</h2></center>
              {reports.length && reports.map(report => (
                <div class="item" key={report.uid}>
                  <div class="itemLabel">
                    <Button
                      content={report.name}
                      onClick={() => act("get_report", { report: report.uid })} />
                  </div>
                </div>
              )) || (
                <Box color="average">
                  There are no reports available for downloading.
                </Box>
              )}
            </Section>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
