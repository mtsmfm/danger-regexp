require 'git_diff_parser'

module Danger
  class DangerRegexp < Plugin
    MAX_COMMENT_COUNT = 1

    ChangedLine = Struct.new(:file, :number, :content, keyword_init: true)
    MatchArgs = Struct.new(:regexps, :message, :file, keyword_init: true)

    def lint(&block)
      @data = []

      instance_eval(&block)

      @data.each do |match_args|
        count = 0

        match_args.regexps.each do |regexp|
          target_lines = changed_lines.select do |line|
            (match_args.file ? line.file.match?(match_args.file) : true) && line.content.match?(regexp)
          end

          target_lines.first(MAX_COMMENT_COUNT).each do |line|
            markdown(match_args.message, file: line.file, line: line.number)
          end

          if target_lines.size > MAX_COMMENT_COUNT
            warn <<~MSG
              Regexp `#{regexp.inspect}` matched too many lines (#{target_lines.size} lines). Only first comment is posted.
            MSG
          end
        end
      end
    end

    private

    def match(*regexps, message, file: nil)
      @data << MatchArgs.new(regexps: regexps, message: message, file: file)
    end

    def changed_lines
      @changed_lines ||= git.diff.flat_map do |diff|
        GitDiffParser::Patch.new(diff.patch).changed_lines.map do |line|
          ChangedLine.new(file: diff.path, number: line.number, content: line.content)
        end
      end
    end
  end
end
