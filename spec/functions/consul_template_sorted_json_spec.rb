require 'spec_helper'

describe 'consul_template::sorted_json' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge('staging_http_get' => 'curl',
                      'concat_basedir'   => '/var/lib/puppet/concat',
                      'architecture'     => 'x86_64')
        end

        params = {
          'log_level' => 'debug',
          'wait'      => '5s:30s',
          'max_stale' => '1s',
          'consul'    => 'localhost:8500',
        }

        describe 'non-pretty json' do
          it { is_expected.to run.with_params(params, false, 4).and_return('{"consul":"localhost:8500","log_level":"debug","max_stale":"1s","wait":"5s:30s"}') }
        end

        describe 'pretty json' do
          it {
            is_expected.to run.with_params(params, true, 4).and_return(
              "{\n    \"consul\": \"localhost:8500\",\n    \"log_level\": \"debug\",\n    \"max_stale\": \"1s\",\n    \"wait\": \"5s:30s\"\n}\n",
            )
          }
        end
      end
    end
  end
end
