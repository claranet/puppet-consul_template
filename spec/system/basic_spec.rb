require 'spec_helper_system'

describe 'basic tests' do
  it 'class should work without errors' do
    pp = <<-EOS
      class { 'consul_template': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
    end
  end
end
