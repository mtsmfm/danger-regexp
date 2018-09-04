require 'git_diff_parser'

module Danger
  class DangerRegexp < Plugin
    def lint(&block)
      @map = {}

      instance_eval(&block)

      git.diff.each do |diff|
        GitDiffParser::Patch.new(diff.patch).changed_lines.each do |line|
          @map.each do |regexp, message|
            if line.content.match?(regexp)
              markdown(message, file: diff.path, line: line.number)
            end
          end
        end
      end
    end

    private

    def match(*regexps, message)
      regexps.each do |regexp|
        @map[regexp] = message
      end
    end
  end
end
