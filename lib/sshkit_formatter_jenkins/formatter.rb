require 'sshkit'

module SSHKitFormatterJenkins
  class Formatter < SSHKit::Formatter::Abstract
    LEVEL_NAMES = %w(DEBUG INFO WARN ERROR FATAL).freeze
    LEVEL_COLORS = [:black, :blue, :yellow, :red, :red].freeze

    def write(obj)
      if obj.is_a?(SSHKit::LogMessage)
        write_message(obj.verbosity, obj.to_s)
      else
        fail "write only supports formatting SSHKit::LogMessage, called with #{obj.class}: #{obj.inspect}"
      end
    end

    def log_command_start(command)
      host_prefix = command.host.user ? "as #{colorize(command.host.user, :blue)}@" : 'on '
      message = "Running #{colorize(command, :yellow, :bold)} #{host_prefix}#{colorize(command.host, :blue)}"
      write_message(command.verbosity, message, command.uuid)
      write_message(Logger::DEBUG, "Command: #{colorize(command.to_command, :blue)}", command.uuid)
    end

    def log_command_data(command, stream_type, stream_data)
      color = \
        case stream_type
        when :stdout then :green
        when :stderr then :red
        else fail "Unrecognised stream_type #{stream_type}, expected :stdout or :stderr"
        end
      write_message(Logger::DEBUG, colorize("\t#{stream_data}".chomp, color), command.uuid)
    end

    def log_command_exit(command)
      runtime = sprintf('%5.3f seconds', command.runtime)
      successful_or_failed = command.failure? ? colorize('failed', :red, :bold) : colorize('successful', :green, :bold)
      message = "Finished in #{runtime} with exit status #{command.exit_status} (#{successful_or_failed})."
      write_message(command.verbosity, message, command.uuid)
    end

    protected

    def format_message(verbosity, message, uuid = nil)
      message = "[#{colorize(uuid, :green)}] #{message}" unless uuid.nil?
      level = colorize(Pretty::LEVEL_NAMES[verbosity], Pretty::LEVEL_COLORS[verbosity])
      '%6s %s' % [level, message]
    end

    private

    def write_message(verbosity, message, uuid = nil)
      original_output << "#{format_message(verbosity, message, uuid)}\n" if verbosity >= SSHKit.config.output_verbosity
    end
  end
end
