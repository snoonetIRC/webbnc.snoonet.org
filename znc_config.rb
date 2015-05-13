class ZncConfig
  def initialize(config_path)
    @config = parse_config(config_path)
  end

  def user_exists(username)
    return true if @config.key?(username)

    false
  end

  def auth_user(username, password)
    return false unless user_exists(username)

    hash = @config[username]['password']['hash']
    salt = @config[username]['password']['salt']
    authed = Digest::SHA256.hexdigest(password + salt)
    authed == hash
  end

  private
  
  def parse_config(config_path)
    users = {}
    current_user = nil
    current_network = nil
    current_channel = nil
    current_password = nil
    cur_obj = nil

    File.open(config_path).each do |line|
      words = line.split(' ')

      if words[0] == '<User'
        current_user = {
          'networks' => [],
          'modules' => [],
          'channels' => [],
          'username' => words[1].chomp('>').downcase
        }
        cur_obj = current_user
      elsif words[0] == '</User>'
        unless current_user.nil?
          users[current_user['username']] = current_user
          current_user = cur_obj
          cur_obj = nil
        end
      elsif words[0] == '<Network'
        unless current_user.nil?
          current_network = {
            'name' => words[1].chomp('>'),
            'channels' => []
          }
          cur_obj = current_network
        end
      elsif words[0] == '</Network>'
        unless current_user.nil? || current_network.nil?
          current_user['networks'].push current_network
          current_network = cur_obj
          cur_obj = nil
        end
      elsif words[0] == '<Chan'
        unless current_network.nil?
          current_channel = {
            'name' => words[1].chomp('>')
          }
          cur_obj = current_channel
        end
      elsif words[0] == '</Chan>'
        unless current_channel.nil? || current_network.nil?
          current_network['channels'].push current_channel
          current_channel = nil
          cur_obj = current_network
        end
      elsif words[0] == '<Pass'
        unless current_user.nil?
          current_password = {}
          cur_obj = current_password
        end
      elsif words[0] == '</Pass>'
        unless current_user.nil? || current_password.nil?
          current_user['password'] = current_password
          current_password = cur_obj
          cur_obj = nil
        end
      elsif words[0] != '//' && words[0] != '' && !words[0].nil?
        next if cur_obj.nil?

        key = words[0].downcase
        value = words[2, 500].join(' ')

        if cur_obj.key?(key) && !cur_obj[key].is_a?(Array)
          cur_obj[key] = [cur_obj[key]]
        end

        if cur_obj.key?(key) && cur_obj[key].is_a?(Array)
          cur_obj[key].push value
        else
          cur_obj[key] = value
        end
      end
    end

    users
  end
end
