class ZncConfig
  def initialize(config_path)
    @config = parse_config(config_path)
  end

  def user_exists(username)
    if @config.has_key?(username)
      return true
    end

    return false
  end

  def auth_user(username, password)
    if !user_exists(username)
      return false
    end

    authed = false

    hash = @config[username]['password']['hash']
    salt = @config[username]['password']['salt']
    authed = Digest::SHA256.hexdigest(password + salt)

    return authed == hash
  end

  private

  def parse_config(config_path)
    config = File.readlines config_path

    users = Hash.new
    current_user = nil
    current_network = nil
    current_channel = nil
    current_password = nil
    cur_obj = nil

    File.open(config_path).each do |line|
      words = line.split(" ")

      if words[0] == "<User"
        current_user = {
          'networks' => Array.new, 
          'modules' => Array.new, 
          'channels' => Array.new,
          'username' => words[1].chomp('>').downcase
        }
        cur_obj = current_user
      elsif words[0] == "</User>"
        if !current_user.nil?
          users[current_user['username']] = current_user
          current_user = cur_obj
          cur_obj = nil
        end
      elsif words[0] == "<Network"
        if !current_user.nil?
          current_network = {
            'name' => words[1].chomp('>'), 
            'channels' => Array.new
          }
          cur_obj = current_network
        end
      elsif words[0] == "</Network>"
        if !current_user.nil? && !current_network.nil?
          current_user['networks'].push current_network
          current_network = cur_obj 
          cur_obj = nil
        end
      elsif words[0] == "<Chan"
        if !current_network.nil?
          current_channel = {
            'name' => words[1].chomp('>')
          }
          cur_obj = current_channel
        end
      elsif words[0] == "</Chan>"
        if !current_channel.nil? && !current_network.nil?
          current_network['channels'].push current_channel
          current_channel = nil
          cur_obj = current_network
        end
      elsif words[0] == "<Pass"
        if !current_user.nil?
          current_password = {}
          cur_obj = current_password
        end
      elsif words[0] == "</Pass>"
        if !current_user.nil? && !current_password.nil?
          current_user['password'] = current_password
          current_password = cur_obj 
          cur_obj = nil
        end
      elsif words[0] != "//" && words[0] != "" && !words[0].nil?
        if cur_obj.nil? then
          next
        end

        key = words[0].downcase
        value = words[2,500].join(" ")

        if cur_obj.has_key?(key) && !cur_obj[key].kind_of?(Array)
          cur_obj[key] = [cur_obj[key]]
        end

        if cur_obj.has_key?(key) && cur_obj[key].kind_of?(Array)
          cur_obj[key].push value
        else
          cur_obj[key] = value
        end
      end
    end

    return users
  end
end