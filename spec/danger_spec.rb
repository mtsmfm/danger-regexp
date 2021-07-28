RSpec.describe Danger::Regexp do
  it do
    expect {
      system("bundle exec danger pr https://github.com/mtsmfm/danger-regexp/pull/1 --dangerfile=spec/fixtures/Dangerfile | grep -A 100 Results:", exception: true)
    }.to output(<<~MESSAGE).to_stdout_from_any_process
      Results:
      \e[32m
      Markdown:\e[0m
      .github/workflows/publish.yml#L7
      li
      lib/danger_plugin.rb#L17
      li
      lib/danger_plugin.rb#L18
      li
      lib/danger_plugin.rb#L21
      li
      lib/danger_plugin.rb#L22
      li
      lib/danger_plugin.rb#L25
      li
      lib/danger_plugin.rb#L27
      li
      lib/danger_plugin.rb#L41
      li
      lib/danger_plugin.rb#L42
      li
      lib/danger_plugin.rb#L43
      li
      lib/danger_plugin.rb#L44
      li
    MESSAGE
  end
end
