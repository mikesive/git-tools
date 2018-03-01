require 'set'

class BranchClean
  def run(confirm_each: false)
    if unwanted_branches.empty?
      puts 'No branches to clean.'
      return
    end

    puts "The following branches will be deleted:"
    puts unwanted_branches.join("\n")
    puts "\n"

    if confirm_each
      unwanted_branches.each do |ub|
        puts "Delete #{ub}?"
        confirm = STDIN.gets.chomp
        puts `git branch -D #{ub}` if confirm == 'y'
      end
    else
      puts "Continue?"
      confirm = STDIN.gets.chomp
      if confirm == 'y'
        puts `git branch -D #{unwanted_branches.join(" ")}`
      end
    end
  end

  private

  CONFIG_PATH = './.branches'
  DEFAULT_EXCEPTED_BRANCHES = Set.new(['master', 'devel', 'develop', 'test', 'prod', 'production'])
  OPTIONS = { '-c' => :confirm_each }

  def configuration?
    File.exist?(CONFIG_PATH)
  end

  def configured_exceptions
    @configured_exceptions ||= configuration? ? File.read(CONFIG_PATH).split("\n").map(&:strip) : []
  end

  def excepted_branches
    @excepted_branches ||= (DEFAULT_EXCEPTED_BRANCHES + configured_exceptions).uniq
  end

  def unwanted_branches
    current_branch = `git rev-parse --abbrev-ref HEAD`.strip
    @unwanted_branches ||= `git for-each-ref --format '%(refname:short)' refs/heads`.split("\n").map(&:strip).select do |b|
      current_branch != b  && !excepted_branches.include?(b)
    end
    @unwanted_branches
  end
end
