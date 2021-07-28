require 'git_diff_parser'

module Danger
  class DangerRegexp < Plugin
    MAX_COMMENT_COUNT = 5

    ChangedLine = Struct.new(:file, :number, :content, keyword_init: true)

    def lint(&block)
      @map = {}

      instance_eval(&block)

      @map.each do |regexp, message|
        count = 0

        target_lines = changed_lines.select do |line|
          line.content.match?(regexp)
        end

        target_lines.first(MAX_COMMENT_COUNT).each do |line|
          markdown(message, file: line.file, line: line.number)
        end

        if target_lines.size > MAX_COMMENT_COUNT
          warn <<~MSG
            #{regexp.inspect} matched too many lines (#{target_lines.size}).
          MSG
        end
      end
    end

    private

    def match(*regexps, message)
      regexps.each do |regexp|
        @map[regexp] = message
      end
    end

    def changed_lines
      @changed_lines ||= git.diff.flat_map do |diff|
        GitDiffParser::Patch.new(diff.patch).changed_lines.map do |line|
          ChangedLine.new(file: file, number: line.number, content: line.content)
        end
      end
    end
  end
end
