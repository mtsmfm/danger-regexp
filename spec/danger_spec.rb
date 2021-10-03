RSpec.describe Danger::Regexp do
  it do
    expect {
      system("bundle exec danger pr https://github.com/mtsmfm/danger-regexp/pull/1 --dangerfile=spec/fixtures/Dangerfile | grep -A 100 Results:", exception: true)
    }.to output(<<~MESSAGE).to_stdout_from_any_process
      Results:
      \e[32m
      \e[33mWarnings:\e[0m
      - [ ] Regexp `/li/` matched too many lines (11 lines). Only first comment is posted.
      \e[32m
      Markdown:\e[0m
      .github/workflows/publish.yml#L7
      li
      .github/workflows/publish.yml#L7
      li on .github
    MESSAGE
  end
end
