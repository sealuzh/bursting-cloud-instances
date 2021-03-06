# The following variables are available
# benchmark_name: Name of the benchmark definition from the web interface
# benchmark_name_sanitized: benchmark_name where all non-word-characters are replaced with an underscore '_'
# benchmark_id: The unique benchmark definition identifier
# execution_id: The unique benchmark execution identifier
# chef_node_name: The default node name used for Chef client provisioning
# tag_name: The default tag name set as aws name tag

SSH_USERNAME = 'ubuntu'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider :aws do |aws, override|
    aws.region = 'eu-west-1'
    aws.availability_zone = "eu-west-1c"
    # Official Ubuntu 14.04 LTS (pv:ebs) image for eu-west-1 from Canonical:
    #  https://cloud-images.ubuntu.com/locator/ec2/
    aws.ami = 'ami-edfd6e9a'
    aws.security_groups = ["sg-55d4a130"]
    aws.instance_type = 't2.medium'
    aws.subnet_id = "subnet-8bae11fc"
    # aws.security_groups = %w(default my_own_group)
  end

  config.vm.provision 'chef_client', id: 'chef_client' do |chef|
    chef.add_recipe 'cli-benchmark@1.0.1'  # Version is optional
    chef.json =
    {
      'benchmark' =>  {
          'ssh_username' => SSH_USERNAME,
      },
      'cli-benchmark' => {
          #'packages' => %w(lmbench),
          'install' => [
            'sudo apt-add-repository multiverse && sudo apt-get update',
            'sudo printf "Y" | sudo apt-get install sysbench',
          ],

          'run' => '''
          sysbench --test=fileio --file-total-size=5G prepare
          curr=$(date +"%Y%m%d%H%M")
          until=$(date -d  "70 minutes" +"%Y%m%d%H%M")
          while [ $curr -lt $until ]; do
            sysbench --test=cpu --num-threads=2--cpu-max-prime=20000 run > /dev/null
            curr=$(date +"%Y%m%d%H%M")
          done
          sysbench --test=fileio --file-total-size=5G --file-test-mode=rndrw --init-rng=on --max-time=600 --max-requests=0 run        ''',
          'metrics' => {
            'Sysbench Result' => '\((.*sec.*)\)',
          }
      }
    } # END json
  end
end

# Google Compute Engine provider
# config.vm.provider :google do |google, override|
#   google.image = 'debian-7-wheezy-v20140619'
#   override.ssh.username = SSH_USERNAME
#   google.machine_type = 'n1-standard-1'
#   google.zone = 'europe-west1-a'
# end

