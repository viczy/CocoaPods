require File.expand_path('../../../spec_helper', __FILE__)

module Pod
  describe Command::IPC do

    describe Command::IPC::Spec do

      it "converts a podspec to yaml and prints it to STDOUT" do
        out = run_command('ipc', 'spec', fixture('banana-lib/BananaLib.podspec'))
        out.should.include('---')
        out.should.match /name: BananaLib/
        out.should.match /version: .1\.0./
        out.should.match /description: Full of chunky bananas./
      end

    end

    #-------------------------------------------------------------------------#

    describe Command::IPC::Podfile do

      it "converts a Podfile to yaml and prints it to STDOUT" do
        out = run_command('ipc', 'podfile', fixture('Podfile'))
        out.should.include('---')
        out.should.match /target_definitions:/
        out.should.match /platform: ios/
        out.should.match /- SSZipArchive:/
      end

    end

    #-------------------------------------------------------------------------#

    describe Command::IPC::List do

      it "converts a podspec to yaml and prints it to STDOUT" do
        spec = fixture_spec('banana-lib/BananaLib.podspec')
        set = Specification.new('BananaLib')
        set.stubs(:specification).returns(spec)
        SourcesManager.stubs(:all_sets).returns([set])

        out = run_command('ipc', 'list')
        out.should.include('---')
        out.should.match /BananaLib:/
        out.should.match /description: Full of chunky bananas./
      end

    end

    #-------------------------------------------------------------------------#

    describe Command::IPC::Repl do

      it "prints the version of CocoaPods as its first message" do
        command = Command::IPC::Repl.new(CLAide::ARGV.new([]))
        command.stubs(:listen)
        command.run

        out = UI.output
        out.should.match /version: #{Pod::VERSION}/
      end

      it "converts forwards the commands to the other ipc subcommands prints the result to STDOUT" do
        command = Command::IPC::Repl.new(CLAide::ARGV.new([]))
        command.execute_repl_command("podfile #{fixture('Podfile')}")

        out = UI.output
        out.should.include('---')
        out.should.match /target_definitions:/
        out.should.match /platform: ios/
        out.should.match /- SSZipArchive:/
        out.should.match />>> @LISTENING <<<$/
      end

    end

    #-------------------------------------------------------------------------#

  end
end
