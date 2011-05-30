require 'meta_config_file'
require 'scheduler'

class StartCommand
	
	def initialize shell, view, upload_command
		@shell = shell
		@view = view
		@meta_file = MetaConfigFile.new @shell
		@upload_command = upload_command
	end
	
	def execute_from_shell params
		start params[1], params[2]
	end

	def start command, file
		unless command then @view.show_missing_command_argument_error "start", "shell_command"; return end
		if file then @view.show_deprecated_command_argument_warning "start", "kata_file" end # since 30-may-2011, remove argument in later version
	  @view.show_start_kata command, file, @meta_file.framework_property
	  runner = Runner.new @shell, SessionIdGenerator.new, @view
		runner.source_files = @meta_file.source_files
	  runner.run_command = command
	  scheduler = Scheduler.new runner, @view, [@upload_command]
	  scheduler.start
	end
	
	def accepts_shell_command? command
		command == 'start'
	end
	
end