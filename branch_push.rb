#!/usr/local/bin/ruby -w

require "open3"

class BranchPush

  def run
    _stdout, stderr, _status = Open3.capture3("git push")
    if /fatal: The current branch \S* has no upstream branch\./.match(stderr)
      new_cmd = stderr.match(/\s*git push [^$]*/)
      puts `#{new_cmd.to_s.strip}`
    end
  end

  private

  OPTIONS = {}
end
