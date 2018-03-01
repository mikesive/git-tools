class CommandParser
  class << self
    def options(cmd, args)
      mappings = command_klass(cmd)::OPTIONS
      args.inject({}) do |sum, arg|
        if opt = mappings[arg]
          sum.merge!(opt => true)
        end
        sum
      end
    end

    def command_klass(cmd)
      unless cmd
        abort("Please specify a command.")
      end
      unless klass = COMMAND_CLASSES[cmd]
        abort("#{cmd} is an invalid command.")
      end
      klass
    end

    private

    COMMAND_CLASSES = {
      'clean' => BranchClean,
      'push' => BranchPush
    }
  end
end
